defmodule Meetings.MeetingDateTest do
  use Meetings.ModelCase

  alias Meetings.MeetingDate

  @valid_attrs %{day: 42, month: 42, year: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = MeetingDate.changeset(%MeetingDate{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = MeetingDate.changeset(%MeetingDate{}, @invalid_attrs)
    refute changeset.valid?
  end
end
