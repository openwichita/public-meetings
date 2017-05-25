defmodule Meetings.MeetingController do
  use Meetings.Web, :controller

  alias Meetings.Meeting

  def index(conn, %{"type" => mtype, "title" => title} = params) do
    meetings = Meeting.list(mtype)

    case Map.get(params, "format") do
      "ics" -> ical_response_meetings(conn, meetings)
      _ -> render(conn, "index.html", meetings: meetings, title: title)
    end
  end

  def index(conn, params) do
    meetings = Meeting.list

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

    case Map.get(params, "format") do
      "ics" -> ical_response_meetings(conn, [meeting_data])
      _ -> render(conn, "show.html", meeting: meeting_data)
    end
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
