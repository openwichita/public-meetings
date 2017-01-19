defmodule Meetings.MeetingExtraController do
  use Meetings.Web, :controller

  alias Meetings.MeetingExtra

  def index(conn, _params) do
    meeting_extras = Repo.all(MeetingExtra)
    render(conn, "index.html", meeting_extras: meeting_extras)
  end

  def new(conn, _params) do
    changeset = MeetingExtra.changeset(%MeetingExtra{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"meeting_extra" => meeting_extra_params}) do
    changeset = MeetingExtra.changeset(%MeetingExtra{}, meeting_extra_params)

    case Repo.insert(changeset) do
      {:ok, _meeting_extra} ->
        conn
        |> put_flash(:info, "Meeting extra created successfully.")
        |> redirect(to: meeting_extra_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    meeting_extra = Repo.get!(MeetingExtra, id)
    render(conn, "show.html", meeting_extra: meeting_extra)
  end

  def edit(conn, %{"id" => id}) do
    meeting_extra = Repo.get!(MeetingExtra, id)
    changeset = MeetingExtra.changeset(meeting_extra)
    render(conn, "edit.html", meeting_extra: meeting_extra, changeset: changeset)
  end

  def update(conn, %{"id" => id, "meeting_extra" => meeting_extra_params}) do
    meeting_extra = Repo.get!(MeetingExtra, id)
    changeset = MeetingExtra.changeset(meeting_extra, meeting_extra_params)

    case Repo.update(changeset) do
      {:ok, meeting_extra} ->
        conn
        |> put_flash(:info, "Meeting extra updated successfully.")
        |> redirect(to: meeting_extra_path(conn, :show, meeting_extra))
      {:error, changeset} ->
        render(conn, "edit.html", meeting_extra: meeting_extra, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    meeting_extra = Repo.get!(MeetingExtra, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(meeting_extra)

    conn
    |> put_flash(:info, "Meeting extra deleted successfully.")
    |> redirect(to: meeting_extra_path(conn, :index))
  end
end
