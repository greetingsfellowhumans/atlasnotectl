defmodule AtlasWeb.Live.Handlers.IncUnitNum do
  #alias Atlas.Repo
  #alias Atlas.Customers.Unit
  #use AtlasWeb, :live_view
  #alias Sorcery.Src


  defmacro __using__(_) do
    quote do
      

      def handle_event("inc-unit-number:" <> id_str, _, socket) do
        id = String.to_integer(id_str)

        Sorcery.Src.new(socket.assigns.portals, %{unit_id: id})
        |> Interceptors.IncUnit.inc_unit()
        |> src_push!()

        {:noreply, socket}
      end


    end
  end

end
