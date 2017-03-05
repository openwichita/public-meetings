defmodule Meetings.MeetingController do
  use Meetings.Web, :controller

  alias Meetings.Meeting

  def index(conn, %{"type" => mtype, "title" => title} = params) do
    meetings = Meeting.list(mtype)
    render(conn, "index.html", meetings: meetings, title: title)
  end

  def index(conn, _params) do
    meetings = Meeting.list
    render(conn, "index.html", meetings: meetings, title: "All")
  end

  def types(conn, _params) do
    meeting_types = Meeting.types
    render(conn, "types.html", types: meeting_types)
  end

  def show(conn, %{"id" => id}) do
    meeting_data = Meeting.get(id)
    render(conn, "show.html", meeting: meeting_data)
  end

  def ical(conn, %{"id" => id}) do
    event = Meeting.to_ical(id)
    render(conn, "ical.html", event: event)
  end
end