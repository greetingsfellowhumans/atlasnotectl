defmodule AtlasWeb.Live.Handlers.EditCall do
  #alias Atlas.Repo
  #alias Atlas.Customers.ServiceCall, as: Call
  #import Phoenix.LiveView, only: [assign: 3]


  defmacro __using__(_) do
    quote do

      def handle_event("toggle_call_edit_mode", _, socket) do
        editing = socket.assigns.editing_call
        socket = assign(socket, :editing_call, !editing)
        {:noreply, socket}
      end

      def handle_event("toggle_call_key:" <> call_id_str, %{"service_call" => attrs}, socket) do
        call_id = String.to_integer(call_id_str)
        call = socket.assigns.portals.service_call[call_id]

        src = %Sorcery.Src{
          original_db: %{service_call: %{call_id => call}},
          changes_db: %{service_call: %{call_id => attrs}}
        }

        src_push!(src)

        {:noreply, socket}
      end

    end
  end

end
