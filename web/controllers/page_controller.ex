defmodule Meetings.PageController do
  use Meetings.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
