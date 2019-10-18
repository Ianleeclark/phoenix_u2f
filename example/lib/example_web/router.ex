defmodule ExampleWeb.Router do
  use ExampleWeb, :router

  use PhoenixU2FWeb.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ExampleWeb do
    pipe_through :browser

    get "/", PageController, :index
    phoenix_u2f_routes()
  end
end
