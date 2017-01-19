defmodule Meetings.MeetingTypeControllerTest do
  use Meetings.ConnCase

  alias Meetings.MeetingType
  @valid_attrs %{agenda: "some content", description: "some content", duration: 42, email: "some content", hour: 42, location: "some content", minute: 42, subtype: "some content", title: "some content", type: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, meeting_type_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing meeting types"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, meeting_type_path(conn, :new)
    assert html_response(conn, 200) =~ "New meeting type"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, meeting_type_path(conn, :create), meeting_type: @valid_attrs
    assert redirected_to(conn) == meeting_type_path(conn, :index)
    assert Repo.get_by(MeetingType, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, meeting_type_path(conn, :create), meeting_type: @invalid_attrs
    assert html_response(conn, 200) =~ "New meeting type"
  end

  test "shows chosen resource", %{conn: conn} do
    meeting_type = Repo.insert! %MeetingType{}
    conn = get conn, meeting_type_path(conn, :show, meeting_type)
    assert html_response(conn, 200) =~ "Show meeting type"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, meeting_type_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    meeting_type = Repo.insert! %MeetingType{}
    conn = get conn, meeting_type_path(conn, :edit, meeting_type)
    assert html_response(conn, 200) =~ "Edit meeting type"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    meeting_type = Repo.insert! %MeetingType{}
    conn = put conn, meeting_type_path(conn, :update, meeting_type), meeting_type: @valid_attrs
    assert redirected_to(conn) == meeting_type_path(conn, :show, meeting_type)
    assert Repo.get_by(MeetingType, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    meeting_type = Repo.insert! %MeetingType{}
    conn = put conn, meeting_type_path(conn, :update, meeting_type), meeting_type: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit meeting type"
  end

  test "deletes chosen resource", %{conn: conn} do
    meeting_type = Repo.insert! %MeetingType{}
    conn = delete conn, meeting_type_path(conn, :delete, meeting_type)
    assert redirected_to(conn) == meeting_type_path(conn, :index)
    refute Repo.get(MeetingType, meeting_type.id)
  end
end
