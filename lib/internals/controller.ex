defmodule PhoenixU2F.U2FController do
  use PhoenixU2FWeb, :controller

  alias PhoenixU2F.U2FKey

  alias U2FEx.KeyMetadata

  @repo Application.get_env(:phoenix_u2f, :repo)

  @doc """
  This is the first interaction in the u2f flow. We'll challenge the u2f token to
  provide a public key and sign our challenge (+ other info) proving their ownership
  of the corresponding private key.
  """
  def start_registration(conn, _params) do
    with {:ok, registration_data} <- U2FEx.start_registration(get_user_id(conn)) do
      output = %{
        registerRequests: [
          %{
            appId: registration_data.appId,
            version: "U2F_V2",
            challenge: registration_data.challenge,
            padding: false
          }
        ],
        registeredKeys: []
      }

      conn
      |> json(output)
    end
  end

  @doc """
  This is the second step of the registration where we'll store their key metadata for
  use later in the authentication portion of the flow.
  """
  def finish_registration(conn, device_response) do
    user_id = get_user_id(conn)

    with {:ok, %KeyMetadata{} = key_metadata} <-
           U2FEx.finish_registration(user_id, device_response),
         :ok <- store_key_data(user_id, key_metadata) do
      conn
      |> json(%{"success" => true})
    else
      _error ->
        conn |> put_status(:bad_request) |> json(%{"success" => false})
    end
  end

  @doc """
  Should the user be logging in, and they have a u2f key registered in our system, we
  should challenge that user to prove their identity and ownership of the u2f device.
  """
  def start_authentication(conn, _params) do
    with {:ok, %{} = sign_request} <- U2FEx.start_authentication(get_user_id(conn)) do
      conn
      |> json(sign_request)
    end
  end

  @doc """
  After the user has attempted to verify their identity, U2FEx will verify they actually who are
  they say they are. Once this step has exited successfully, then we can be reasonably assured the
  user is who they claim to be.
  """
  def finish_authentication(conn, device_response) do
    with :ok <- U2FEx.finish_authentication(get_user_id(conn), device_response |> Jason.encode!()) do
      conn
      |> json(%{"success" => true})
    else
      _ -> json(conn, %{"success" => false})
    end
  end

  @doc """
  Fill in with however you want to persist keys. See U2FEx.KeyMetadata struct for more info
  """
  @spec store_key_data(user_id :: any(), KeyMetadata.t()) :: :ok | {:error, any()}
  def store_key_data(user_id, key_metadata) do
    # TODO(ian); Fill this in
    %U2FKey{}
    |> U2FKey.changeset(%{key_metadata | user_id: user_id})
    |> @repo.save()
  end

  @spec get_user_id(Plug.Conn.t()) :: String.t() | {:error, :no_user_id_found}
  defp get_user_id(%Plug.Conn{assigns: %{user_id: user_id}}) do
    # TODO(ian): Add a sensible default here (conn.assigns.user_id) and then add a config value to override this with a function
    user_id
  end

  defp get_user_id(_), do: {:error, :no_user_id_found}
end
