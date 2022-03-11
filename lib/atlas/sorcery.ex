defmodule Atlas.SorceryStorage do
  alias Atlas.Accounts.{User, Tech}
  alias Atlas.Customers.{Location, Unit, ServiceCall, ServiceInstruction, TechNote}

  @tables %{
    user: %{schema: User},
    tech: %{schema: Tech, index: [:user_id]},
    unit: %{schema: Unit, index: [:location_number]},
    location: %{schema: Location, index: [:location_number]},
    service_call: %{schema: ServiceCall, index: [:location_number]},
    service_instruction: %{schema: ServiceInstruction, index: [:call_id]},
    tech_note: %{schema: TechNote, index: [:call_id, :tech_id]},
  }

  use Sorcery.Storage.GenserverAdapter, %{
    presence: AtlasWeb.Presence,
    repo: Atlas.Repo,
    ecto: Ecto,
    tables: @tables,
  }

  

  #use Sorcery.Storage, [
  #  adapter: Sorcery.Storage.Adapters.GenserverAdapter,
  #  tables: %{
  #    tech: %{attributes: [:name, :user_id], schema: User, index: [:user_id]},
  #    location: %{attributes: [:name, :location_number], schema: Location, index: [:location_number]},
  #  },
  #]


end
