defmodule Meetings.MeetingDate do
  use Meetings.Web, :model

  schema "meeting_dates" do
    field :month, :integer
    field :day, :integer
    field :year, :integer
    belongs_to :meeting_type, Meetings.MeetingType

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:meeting_type_id, :month, :day, :year])
    |> validate_required([:meeting_type_id, :month, :day, :year])
  end
end
