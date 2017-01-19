defmodule Meetings.Repo.Migrations.CreateMeetingDate do
  use Ecto.Migration

  def change do
    create table(:meeting_dates) do
      add :month, :integer
      add :day, :integer
      add :year, :integer
      add :meeting_type_id, references(:meeting_types, on_delete: :nothing)

      timestamps()
    end
    create index(:meeting_dates, [:meeting_type_id])

  end
end
