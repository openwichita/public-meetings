# Aggregates meeting_types, meeting_dates and meeting_extras into one model
defmodule Meetings.Meeting do
  alias Meetings.MeetingType
  alias Meetings.MeetingDate
  alias Meetings.MeetingExtra
  alias Meetings.Repo


  defstruct type_id: 0, title: "", location: "", date_id: 0, date: DateTime.utc_now(), duration: 0

  # create new struct with data based on defstruct above
  def new(data) do
    datetime = Timex.to_datetime(
      {{data.year, data.month, data.day}, {data.hour, data.minute, 0}},
      "America/Chicago"
    )

    %__MODULE__{
      type_id: data.type_id,
      title: data.title,
      location: data.location,
      date_id: data.date_id,
      date: datetime,
      duration: data.duration
   }
  end

  # Create a list of meeting events
  # Need joined list of meetings, not list of dates within each meeting (Repo.all)
  def list(mtype \\ "") do
    import Ecto.Query

    query = from mt in MeetingType,
      join: md in MeetingDate, where: md.meeting_type_id == mt.id

    now = DateTime.utc_now()

    # Extend the query
    query = from [mt, md] in query,
      select: %{type_id: mt.id,
                title: mt.title,
                location: mt.location,
                date_id: md.id,
                year: md.year,
                month: md.month,
                day: md.day,
                hour: mt.hour,
                minute: mt.minute,
                duration: mt.duration},
      where: md.year == ^(now.year) and md.month >= ^(now.month) and md.day >= ^(now.day),
      order_by: [md.year, md.month, md.day]

    query = if (String.length(mtype) != 0) do
      query |> where([mt], mt.type == ^(mtype))
    else
      query
    end

    data = Repo.all(query)
    Enum.map(data, fn md -> new(md) end)
  end

  # Need to load db table models since has_many relationship
  def preload(query) do
    query
    |> Repo.preload(:meeting_dates)
    |> Repo.preload(:meeting_extras)
  end

  def from_meeting_date(id) do
    meeting_date = get_event(id)
    meeting_type = meeting_date.meeting_type
    new(%{type_id: meeting_type.id,
          title: meeting_type.title,
          location: meeting_type.location,
          date_id: meeting_date.id,
          year: meeting_date.year,
          month: meeting_date.month,
          day: meeting_date.day,
          hour: meeting_type.hour,
          minute: meeting_type.minute,
          duration: meeting_type.duration})
  end

  def get(id) do
     Repo.get(MeetingType, id)
     |> preload
  end

  def get_event(id) do
     Repo.get(MeetingDate, id)
     |> Repo.preload(:meeting_type)
  end

  def types do
    Repo.all(MeetingType)
    |> preload
  end

  # list of all meeting dates preloaded with meeting_type for each date
  def dates do
    Repo.all(MeetingDate)
    |> Repo.preload(:meeting_types)
  end

  # list of all meeting extra fields preloaded with meeting_type for each date
  def extras do
    Repo.all(MeetingExtra)
    |> Repo.preload(:meeting_types)
  end

  # convert to ical event
  def to_ical(meeting) do
    event = get(meeting.type_id)
    datetime = meeting.date

    %ICalendar.Event{
      summary: event.title,
      dtstart: datetime,
      dtend: Timex.shift(datetime, minutes: event.duration),
      description: event.description,
      location: event.location
    }
  end
end
