defmodule Meetings.MeetingDateController do
  use Meetings.Web, :controller

  alias Meetings.MeetingDate

  def index(conn, _params) do
    meeting_dates = Repo.all(MeetingDate)
    render(conn, "index.html", meeting_dates: meeting_dates)
  end

  def new(conn, _params) do
    changeset = MeetingDate.changeset(%MeetingDate{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"meeting_date" => meeting_date_params}) do
    changeset = MeetingDate.changeset(%MeetingDate{}, meeting_date_params)

    case Repo.insert(changeset) do
      {:ok, _meeting_date} ->
        conn
        |> put_flash(:info, "Meeting date created successfully.")
        |> redirect(to: meeting_date_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    meeting_date = Repo.get!(MeetingDate, id)
    render(conn, "show.html", meeting_date: meeting_date)
  end

  def edit(conn, %{"id" => id}) do
    meeting_date = Repo.get!(MeetingDate, id)
    changeset = MeetingDate.changeset(meeting_date)
    render(conn, "edit.html", meeting_date: meeting_date, changeset: changeset)
  end

  def update(conn, %{"id" => id, "meeting_date" => meeting_date_params}) do
    meeting_date = Repo.get!(MeetingDate, id)
    changeset = MeetingDate.changeset(meeting_date, meeting_date_params)

    case Repo.update(changeset) do
      {:ok, meeting_date} ->
        conn
        |> put_flash(:info, "Meeting date updated successfully.")
        |> redirect(to: meeting_date_path(conn, :show, meeting_date))
      {:error, changeset} ->
        render(conn, "edit.html", meeting_date: meeting_date, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    meeting_date = Repo.get!(MeetingDate, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(meeting_date)

    conn
    |> put_flash(:info, "Meeting date deleted successfully.")
    |> redirect(to: meeting_date_path(conn, :index))
  end
end
