defmodule Meetings.MeetingExtra do
  use Meetings.Web, :model

  schema "meeting_extras" do
    field :field, :string
    field :value, :string
    belongs_to :meeting_type, Meetings.MeetingType

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:field, :value])
    |> validate_required([:field, :value])
  end
end
