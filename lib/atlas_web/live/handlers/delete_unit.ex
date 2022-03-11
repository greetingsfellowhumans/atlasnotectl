defmodule AtlasWeb.Live.Handlers.DeleteUnit do
  #alias Atlas.Repo
  #alias Atlas.Customers.Unit
  #use AtlasWeb, :live_view
  #alias Sorcery.Src


  defmacro __using__(_) do
    quote do
      

      def handle_event("delete-unit:" <> id_str, _, socket) do
        id = String.to_integer(id_str)

        src = %Sorcery.Src{
          deletes: [unit: id]
        }

        #SorceryStorage.push_src!(src)
        src_push!(src)

        {:noreply, socket}
      end


    end
  end

end
