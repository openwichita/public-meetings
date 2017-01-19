defmodule Meetings.Repo.Migrations.CreateMeetingType do
  use Ecto.Migration

  def change do
    create table(:meeting_types) do
      add :type, :string
      add :subtype, :string
      add :title, :string
      add :description, :text
      add :location, :string
      add :hour, :integer
      add :minute, :integer
      add :duration, :integer
      add :email, :string
      add :agenda, :string

      timestamps()
    end

  end
end
