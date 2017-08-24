defmodule Meetings.MeetingController do
  use Meetings.Web, :controller

  alias Meetings.Meeting

  def index(conn, %{"type" => mtype, "title" => title} = params) do
    meetings = Meeting.list(mtype) |> Enum.map(&meeting_tuple/1)

    case Map.get(params, "format") do
      "ics" -> ical_response_meetings(conn, meetings)
      _ -> render(conn, "index.html", meetings: meetings, title: title)
    end
  end

  def index(conn, params) do
    meetings = Meeting.list |> Enum.map(&meeting_tuple/1)

    case Map.get(params, "format") do
      "ics" -> ical_response_meetings(conn, meetings)
      _ -> render(conn, "index.html", meetings: meetings, title: "All")
    end
  end

  def types(conn, _params) do
    meeting_types = Meeting.types
    render(conn, "types.html", types: meeting_types)
  end

  def show(conn, %{"id" => id} = params) do
    meeting_data = Meeting.get(id)
    render(conn, "show.html", meeting: meeting_data)
  end

  def show_date(conn, %{"type_id" => type_id, "date_id" => date_id} = params) do
    meeting = Meeting.from_meeting_date(date_id)

    case Map.get(params, "format") do
      "ics" -> ical_response_meetings(conn, [meeting])
      # TODO: this doesn't actually work at the moment, but probably useful to
      # have a display page for a single meeting at some point
      _ -> render(conn, "show.html", meeting: meeting)
    end
  end

  defp meeting_tuple(meeting) do
      {meeting, Meeting.to_ical(meeting)}
  end

  defp ical_response_meetings(conn, meetings) do
    events = Enum.map(meetings, fn meeting -> Meeting.to_ical(meeting) end)
    conn |> ical_response(events)
  end

  defp ical_response(conn, events) do
    ics_content = %ICalendar{ events: events } |> ICalendar.to_ics
    conn
    |> put_resp_content_type("text/meeting")
    |> put_resp_header("content-disposition", "attachment; filename=events.ics")
    |> send_resp(200, ics_content)
  end
end
