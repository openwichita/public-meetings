# Aggregates meeting_types, meeting_dates and meeting_extras into one model
defmodule Meetings.Meeting do
  alias Meetings.MeetingType
  alias Meetings.MeetingDate
  alias Meetings.MeetingExtra
  alias Meetings.Repo


  defstruct id: 0, title: "", location: "", date: DateTime.utc_now(), duration: 0

  # create new struct with data based on defstruct above
  def new(data) do
    %__MODULE__{ 
      id: elem(data, 0),
      title: elem(data, 1),
      location: elem(data, 2),
      date: %DateTime{
        calendar: Calendar.ISO, 
        time_zone: "CST/UTC", 
        zone_abbr: "CST", 
        std_offset: 6, 
        utc_offset: 6,
        year: elem(data, 3), 
        month: elem(data, 4), 
        day: elem(data, 5), 
        hour: elem(data, 6), 
        minute: elem(data, 7), 
        second: 0 
      },
      duration: elem(data, 8)
   }
  end

  # Create a list of meeting events
  # Need joined list of meetings, not list of dates within each meeting (Repo.all)
  def list(mtype \\ "") do
    import Ecto.Query

    query = from mt in MeetingType,
      join: md in MeetingDate, where: md.meeting_type_id == mt.id

    now = DateTime.utc_now()

    # ^(now.year) and md.month = ^(now.month) and md.day >= ^(now.day),
    
    # Extend the query
    query = from [mt, md] in query,
      select: {mt.id, mt.title, mt.location, md.year, md.month, md.day, mt.hour, mt.minute, mt.duration},
      where: md.year == ^(now.year) and md.month >= ^(now.month) and md.day >= ^(now.day),
      order_by: [md.year, md.month, md.day]


    IO.puts mtype
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

  # list of all meeting extra fieds preloaded with meeting_type for each date
  def extras do
    Repo.all(MeetingExtra)
    |> Repo.preload(:meeting_types)
  end

  # convert to ical event ics byte string
  def to_ical(id) do
    event = get_event(id)
    event # needs to be converted
  end
end