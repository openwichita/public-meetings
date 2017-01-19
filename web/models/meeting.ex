defmodule Meetings.Meeting do
  defstruct title: "", date: DateTime.utc_now(), duration: 0, location: "", description: "", email: "", agenda: ""

  def new(data) do
   %Meetings.Meeting{ 
     title: elem(data, 0), 
     date: %DateTime{calendar: Calendar.ISO, time_zone: "CST/UTC", zone_abbr: "CST", std_offset: 6, utc_offset: 6,
       year: elem(data, 1), month: elem(data, 2), day: elem(data, 3), hour: elem(data, 4), minute: elem(data, 5), second: 0 },
     duration: elem(data, 6),
     location: elem(data, 7),
     description: elem(data, 8),
     email: elem(data, 9),
     agenda: elem(data, 10),
   }
  end

  def to_ics do
    "Convert fields to ical bytestring"
  end
end