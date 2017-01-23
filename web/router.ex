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

  scope "/", Meetings do
    pipe_through :browser # Use the default browser stack

    coherence_routes

    get "/", PageController, :index
    get "/meetings", MeetingController, :index
  end

  scope "/", Meetings do
    pipe_through :protected

    coherence_routes :protected

    resources "/meeting_types", MeetingTypeController
    resources "/meeting_dates", MeetingDateController
    resources "/meeting_extra", MeetingExtraController

    # this is a fall back route incase someone types
    # the plural of extra (github issue #11)
    resources "/meeting_extras", MeetingExtraController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Meetings do
  #   pipe_through :api
  # end
end
