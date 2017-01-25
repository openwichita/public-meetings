# Aggregates meeting_types, meeting_dates and meeting_extras into one model
defmodule Meetings.Meeting do
  defstruct id: 0, title: "", location: "", date: DateTime.utc_now(), duration: 0

  alias Meetings.MeetingType
  alias Meetings.MeetingDate
  alias Meetings.MeetingExtra
  alias Meetings.Repo
  
  def new(data) do
    %Meetings.Meeting{ 
      id: elem(data, 0),
      title: elem(data, 1),
      location: elem(data, 2),
      date: %DateTime{calendar: Calendar.ISO, time_zone: "CST/UTC", zone_abbr: "CST", std_offset: 6, utc_offset: 6,
      year: elem(data, 3), month: elem(data, 4), day: elem(data, 5), hour: elem(data, 6), minute: elem(data, 7), second: 0 },
      duration: elem(data, 8)
   }
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

  def types do
    Repo.all(MeetingType)
    |> preload
  end

  def dates do
    Repo.all(MeetingDate)
    |> Repo.preload(:meeting_types)
  end

  def extras do
    Repo.all(MeetingExtra)
    |> Repo.preload(:meeting_types)
  end

  
  def list do
    # Need joined list of meetings, not list of dates within each meeting (Repo.all)
    import Ecto.Query

    query = from mt in MeetingType,
      join: md in MeetingDate, where: md.meeting_type_id == mt.id
    
    # Extend the query
    query = from [mt, md] in query,
      select: {mt.id, mt.title, mt.location, md.year, md.month, md.day, mt.hour, mt.minute, mt.duration},
      order_by: [md.year, md.month, md.day]

    data = Repo.all(query)
    Enum.map(data, fn md -> new(md) end)
  end

  def to_ics do
    "Convert fields to ical bytestring"
  end
end