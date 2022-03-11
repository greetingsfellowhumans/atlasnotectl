defmodule AtlasWeb.LiveHelpers do
  import Phoenix.LiveView
  alias Atlas.Accounts

  def put_args(%{assigns: assigns} = socket, k, v) do
    old_args = Map.get(assigns, :args, %{})
    args = Map.put(old_args, k, v)
    assign(socket, :args, args)
  end

  def assign_defaults(socket, session) do
    case find_current_user(session) do
      {:ok, %{user: user, tech: tech}} ->
        socket
        |> assign(:user_id, user.id)
        |> assign(:tech_id, tech.id)
        |> assign(:tech_name, tech.name)

      _ ->
        socket
        |> assign(:current_user_id, nil)
        |> assign(:current_tech_id, nil)
        |> assign(:tech_name, "Anon")
      end
  end


  defp find_current_user(session) do
    with user_token when not is_nil(user_token) <- session["user_token"],
         %Accounts.User{} = user <- Accounts.get_user_by_session_token(user_token), 
         %Accounts.Tech{} = tech <- Accounts.get_tech_by_user(user) do
        {:ok, %{user: user, tech: tech}}
    end
  end


  def lawn_or_flash({:error, :banner, msg}, socket) do
    put_flash(socket, :error, msg)
  end
  def lawn_or_flash({:ok,    :banner, msg}, socket) do
    put_flash(socket, :info, msg)
  end
  def lawn_or_flash({:ok, m}, socket) when is_map(m) do
    new_lawn = Map.merge(socket.assigns.lawn, m)
    assign(socket, :lawn, new_lawn)
  end

end
