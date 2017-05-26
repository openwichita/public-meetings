defmodule Meetings.Router do
  use Meetings.Web, :router
  use Coherence.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session
  end

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, protected: true
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :browser
    coherence_routes()
  end

  scope "/" do
    pipe_through :protected
    coherence_routes :protected
  end

  scope "/", Meetings do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/meetings", MeetingController, :index
    get "/meetings/types", MeetingController, :types
    get "/meetings/:id", MeetingController, :show
    get "/meetings/:type_id/date/:date_id", MeetingController, :show_date
  end

  scope "/", Meetings do
    pipe_through :protected

    resources "/meeting_types", MeetingTypeController
    resources "/meeting_dates", MeetingDateController
    resources "/meeting_extras", MeetingExtraController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Meetings do
  #   pipe_through :api
  # end
end
