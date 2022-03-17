defmodule AtlasWeb.Live.Handlers.CreateCall do
  alias Atlas.Repo
  alias Atlas.Customers.ServiceCall
  #import Phoenix.LiveView, only: [assign: 3]
  use AtlasWeb, :live_view


  def change(%{"service_call" => attrs}, socket) do
    num = socket.assigns.location_number
    cs = ServiceCall.create_changeset(%ServiceCall{location_number: num}, attrs)
    socket = assign(socket, :changeset, cs)
    {:noreply, socket}
  end


  def submit(%{"service_call" => attrs}, socket) do
    num = socket.assigns.location_number
    call = Map.put(attrs, "location_number", num)
    
    Sorcery.Src.new(%{}, %{})
    |> Map.put(:changes_db, %{
      service_call: %{
        "$sorcery:service_call:1" => call
      },
    })
    |> src_push!
    
    {:noreply, socket}
  end

  def render(assigns), do: ~H""

end
