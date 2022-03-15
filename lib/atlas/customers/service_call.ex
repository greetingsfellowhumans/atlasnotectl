defmodule Atlas.Customers.ServiceCall do
  use Ecto.Schema
  import Ecto.Changeset

  schema "service_call" do
    field :location_number, :integer
    field :start_date, :naive_datetime
    field :end_date, :naive_datetime

    field :note, :boolean, default: true
    field :refusal, :boolean, default: false

    field :num_roaches_reported, :boolean, default: false
    field :num_roaches_seen, :boolean, default: false
    field :num_mice_seen, :boolean, default: false
    field :num_mice_reported, :boolean, default: false
    field :num_ants_seen, :boolean, default: false
    field :num_ants_reported, :boolean, default: false
    field :sanitation, :boolean, default: false
    field :feeding, :boolean, default: false
    field :trap_locations, :boolean, default: false
  end

  @callable [:start_date, :end_date, :location_number, :note, :num_roaches_reported, :num_roaches_seen, :num_mice_seen, :num_mice_reported, :num_ants_seen, :num_ants_reported, :sanitation, :feeding, :trap_locations, :refusal]

  def create_changeset(unit, attrs) do
    unit
    |> cast(attrs, @callable)
    |> validate_required(@callable)
  end

  def sorcery_update(unit, attrs) do
    unit
    |> cast(attrs, @callable)
    |> validate_required(@callable)
  end
  def sorcery_insert(unit, attrs) do
    IO.inspect(attrs, label: "CHANGESET ATTRS")
    unit
    |> cast(attrs, @callable)
    |> validate_required(@callable)
  end

end

