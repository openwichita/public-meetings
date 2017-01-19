defmodule Meetings.MeetingExtraTest do
  use Meetings.ModelCase

  alias Meetings.MeetingExtra

  @valid_attrs %{field: "some content", value: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = MeetingExtra.changeset(%MeetingExtra{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = MeetingExtra.changeset(%MeetingExtra{}, @invalid_attrs)
    refute changeset.valid?
  end
end
