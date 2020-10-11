defmodule PhoenixU2FWeb do
  def controller do
    quote do
      use Phoenix.Controller, namespace: PhoenixU2FWeb

      import Plug.Conn
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/phoenix_u2f_web/templates"

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import PhoenixU2FWeb.ErrorHelpers
      import PhoenixU2FWeb.Router.Helpers
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
