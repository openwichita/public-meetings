defmodule Meetings.MeetingTypeController do
  use Meetings.Web, :controller

  alias Meetings.MeetingType

  def index(conn, _params) do
    meeting_types = Repo.all(MeetingType)
    render(conn, "index.html", meeting_types: meeting_types)
  end

  def new(conn, _params) do
    changeset = MeetingType.changeset(%MeetingType{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"meeting_type" => meeting_type_params}) do
    changeset = MeetingType.changeset(%MeetingType{}, meeting_type_params)

    case Repo.insert(changeset) do
      {:ok, _meeting_type} ->
        conn
        |> put_flash(:info, "Meeting type created successfully.")
        |> redirect(to: meeting_type_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    meeting_type = Repo.get!(MeetingType, id)
    |> Repo.preload(:meeting_dates)
    render(conn, "show.html", meeting_type: meeting_type)
  end

  def edit(conn, %{"id" => id}) do
    meeting_type = Repo.get!(MeetingType, id)
    changeset = MeetingType.changeset(meeting_type)
    render(conn, "edit.html", meeting_type: meeting_type, changeset: changeset)
  end

  def update(conn, %{"id" => id, "meeting_type" => meeting_type_params}) do
    meeting_type = Repo.get!(MeetingType, id)
    changeset = MeetingType.changeset(meeting_type, meeting_type_params)

    case Repo.update(changeset) do
      {:ok, meeting_type} ->
        conn
        |> put_flash(:info, "Meeting type updated successfully.")
        |> redirect(to: meeting_type_path(conn, :show, meeting_type))
      {:error, changeset} ->
        render(conn, "edit.html", meeting_type: meeting_type, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    meeting_type = Repo.get!(MeetingType, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(meeting_type)

    conn
    |> put_flash(:info, "Meeting type deleted successfully.")
    |> redirect(to: meeting_type_path(conn, :index))
  end
end
