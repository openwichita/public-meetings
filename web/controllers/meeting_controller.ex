defmodule Meetings.MeetingController do
  use Meetings.Web, :controller

  alias Meetings.MeetingType
  alias Meetings.MeetingDate
  alias Meetings.Meeting

  def index(conn, _params) do
    # Create a query
    query = from mt in MeetingType,
          join: md in MeetingDate, where: md.meeting_type_id == mt.id

    # Extend the query
    query = from [mt, md] in query,
          select: {mt.title, md.year, md.month, md.day, mt.hour, mt.minute, mt.duration, mt.location, mt.description, mt.email, mt.agenda},
          order_by: [md.month, md.day]

    meeting_data = Repo.all(query)
    meetings = Enum.map(meeting_data, fn md -> Meeting.new(md) end)

    render(conn, "index.html", meetings: meetings)
  end
end