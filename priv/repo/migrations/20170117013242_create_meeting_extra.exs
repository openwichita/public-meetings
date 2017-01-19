defmodule Meetings.Repo.Migrations.CreateMeetingExtra do
  use Ecto.Migration

  def change do
    create table(:meeting_extras) do
      add :field, :string
      add :value, :text
      add :meeting_type_id, references(:meeting_types, on_delete: :nothing)

      timestamps()
    end
    create index(:meeting_extras, [:meeting_type_id])

  end
end
