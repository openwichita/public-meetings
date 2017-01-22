defmodule Meetings.MeetingType do
  use Meetings.Web, :model

  schema "meeting_types" do
    field :type, :string
    field :subtype, :string
    field :title, :string
    field :description, :string
    field :location, :string
    field :building, :string
    field :hour, :integer
    field :minute, :integer
    field :duration, :integer
    field :email, :string
    field :agenda, :string
    field :website, :string

    has_many :meeting_dates, Meetings.MeetingDate
    has_many :meeting_extras, Meetings.MeetingExtra

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:type, :subtype, :title, :description, :location, :building, :hour, :minute, :duration, :email, :agenda, :website])
    |> validate_required([:type, :subtype, :title, :description, :location, :building, :hour, :minute, :duration, :email, :agenda, :website])
  end
end
