defmodule Meetings.MeetingExtraControllerTest do
  use Meetings.ConnCase

  alias Meetings.MeetingExtra
  @valid_attrs %{field: "some content", value: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, meeting_extra_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing meeting extras"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, meeting_extra_path(conn, :new)
    assert html_response(conn, 200) =~ "New meeting extra"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, meeting_extra_path(conn, :create), meeting_extra: @valid_attrs
    assert redirected_to(conn) == meeting_extra_path(conn, :index)
    assert Repo.get_by(MeetingExtra, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, meeting_extra_path(conn, :create), meeting_extra: @invalid_attrs
    assert html_response(conn, 200) =~ "New meeting extra"
  end

  test "shows chosen resource", %{conn: conn} do
    meeting_extra = Repo.insert! %MeetingExtra{}
    conn = get conn, meeting_extra_path(conn, :show, meeting_extra)
    assert html_response(conn, 200) =~ "Show meeting extra"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, meeting_extra_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    meeting_extra = Repo.insert! %MeetingExtra{}
    conn = get conn, meeting_extra_path(conn, :edit, meeting_extra)
    assert html_response(conn, 200) =~ "Edit meeting extra"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    meeting_extra = Repo.insert! %MeetingExtra{}
    conn = put conn, meeting_extra_path(conn, :update, meeting_extra), meeting_extra: @valid_attrs
    assert redirected_to(conn) == meeting_extra_path(conn, :show, meeting_extra)
    assert Repo.get_by(MeetingExtra, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    meeting_extra = Repo.insert! %MeetingExtra{}
    conn = put conn, meeting_extra_path(conn, :update, meeting_extra), meeting_extra: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit meeting extra"
  end

  test "deletes chosen resource", %{conn: conn} do
    meeting_extra = Repo.insert! %MeetingExtra{}
    conn = delete conn, meeting_extra_path(conn, :delete, meeting_extra)
    assert redirected_to(conn) == meeting_extra_path(conn, :index)
    refute Repo.get(MeetingExtra, meeting_extra.id)
  end
end
