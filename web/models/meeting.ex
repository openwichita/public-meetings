defmodule Meetings.Meeting do
  defstruct title: "", location: "", date: DateTime.utc_now(), duration: 0

  alias Meetings.MeetingType
  alias Meetings.MeetingDate
  alias Meetings.MeetingExtra
  alias Meetings.Repo
  
  def new(data) do
    %Meetings.Meeting{ 
      title: elem(data, 0),
      location: elem(data, 1),
      date: %DateTime{calendar: Calendar.ISO, time_zone: "CST/UTC", zone_abbr: "CST", std_offset: 6, utc_offset: 6,
      year: elem(data, 2), month: elem(data, 3), day: elem(data, 4), hour: elem(data, 5), minute: elem(data, 6), second: 0 },
      duration: elem(data, 7),
   }
  end

  def get(id) do
     Repo.get(MeetingType, id)
     |> Repo.preload(:meeting_dates)
     |> Repo.preload(:meeting_extras)
  end

  def types do
    Repo.all(MeetingType)
  end

  def dates do
    Repo.all(MeetingDate)
  end

  def extras do
    Repo.all(MeetingExtra)
  end

  def list do
    # Need joined list of meetings, not list of dates within each meeting (Repo.all)
    import Ecto.Query

    query = from mt in MeetingType,
      join: md in MeetingDate, where: md.meeting_type_id == mt.id
    
    # Extend the query
    query = from [mt, md] in query,
      select: {mt.title, mt.location, md.year, md.month, md.day, mt.hour, mt.minute, mt.duration}

    data = Repo.all(query)
    Enum.map(data, fn md -> new(md) end)
  end

  def to_ics do
    "Convert fields to ical bytestring"
  end
end