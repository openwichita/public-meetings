defmodule Meetings.MeetingController do
  use Meetings.Web, :controller

  alias Meetings.Meeting

  def index(conn, _params) do
    meetings = Meeting.list
    render(conn, "index.html", meetings: meetings)
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