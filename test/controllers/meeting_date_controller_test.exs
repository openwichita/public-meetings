defmodule Meetings.MeetingDateControllerTest do
  use Meetings.ConnCase

  alias Meetings.MeetingDate
  @valid_attrs %{day: 42, month: 42, year: 42}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, meeting_date_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing meeting dates"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, meeting_date_path(conn, :new)
    assert html_response(conn, 200) =~ "New meeting date"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, meeting_date_path(conn, :create), meeting_date: @valid_attrs
    assert redirected_to(conn) == meeting_date_path(conn, :index)
    assert Repo.get_by(MeetingDate, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, meeting_date_path(conn, :create), meeting_date: @invalid_attrs
    assert html_response(conn, 200) =~ "New meeting date"
  end

  test "shows chosen resource", %{conn: conn} do
    meeting_date = Repo.insert! %MeetingDate{}
    conn = get conn, meeting_date_path(conn, :show, meeting_date)
    assert html_response(conn, 200) =~ "Show meeting date"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, meeting_date_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    meeting_date = Repo.insert! %MeetingDate{}
    conn = get conn, meeting_date_path(conn, :edit, meeting_date)
    assert html_response(conn, 200) =~ "Edit meeting date"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    meeting_date = Repo.insert! %MeetingDate{}
    conn = put conn, meeting_date_path(conn, :update, meeting_date), meeting_date: @valid_attrs
    assert redirected_to(conn) == meeting_date_path(conn, :show, meeting_date)
    assert Repo.get_by(MeetingDate, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    meeting_date = Repo.insert! %MeetingDate{}
    conn = put conn, meeting_date_path(conn, :update, meeting_date), meeting_date: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit meeting date"
  end

  test "deletes chosen resource", %{conn: conn} do
    meeting_date = Repo.insert! %MeetingDate{}
    conn = delete conn, meeting_date_path(conn, :delete, meeting_date)
    assert redirected_to(conn) == meeting_date_path(conn, :index)
    refute Repo.get(MeetingDate, meeting_date.id)
  end
end
