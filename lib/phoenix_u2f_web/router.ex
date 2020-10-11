defmodule PhoenixU2FWeb.Router do
  use PhoenixU2FWeb, :router

  defmacro __using__(_opts \\ []) do
    quote do
      import unquote(__MODULE__)
    end
  end

  defmacro phoenix_u2f_routes(opts \\ []) do
    base_uri = Access.get(opts, :base_uri) || "/u2f"

    quote do
      scope(unquote(base_uri)) do
        get("/start_registration", PhoenixU2FWeb.Controller, :begin_registration)
        post("/start_registration", PhoenixU2FWeb.Controller, :start_registration)
        post("/finish_registration", PhoenixU2FWeb.Controller, :finish_registration)
        post("/start_authentication", PhoenixU2FWeb.Controller, :start_authentication)
      end
    end
  end
end
