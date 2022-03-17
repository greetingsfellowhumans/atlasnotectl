defmodule Atlas.Customers.TechNote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tech_note" do
    field :call_id, :integer
    field :tech_id, :integer
    field :unit_id, :integer
    field :note,    :string, default: nil
    field :complete, :boolean, default: false

    field :num_roaches_seen,     :string, default: "0"
    field :num_roaches_reported, :string, default: "0"
    field :num_mice_seen,        :string, default: "0"
    field :num_mice_reported,    :string, default: "0"
    field :num_ants_seen,        :string, default: "0"
    field :num_ants_reported,    :string, default: "0"
    field :num_flies_seen,       :string, default: "0"
    field :num_flies_reported,   :string, default: "0"
    field :sanitation,           :string, default: "ok"
    field :clutter,              :string, default: ""
    field :trap_locations,       :string, default: nil
    field :feeding,              :string, default: "none"
    field :refusal,              :boolean, default: false

    timestamps()
  end

  @callable [:call_id, :tech_id, :unit_id, :note, :num_roaches_seen, :num_roaches_reported, :num_mice_seen, :num_mice_reported, :num_ants_seen, :num_ants_reported, :sanitation, :trap_locations, :feeding, :refusal, :complete, :num_flies_seen, :num_flies_reported, :clutter]
  @required [:call_id, :tech_id]

  def create_changeset(unit, attrs) do
    unit
    |> cast(attrs, @callable)
    |> validate_required(@required)
  end

  def sorcery_update(unit, attrs) do
    unit
    |> cast(attrs, @callable)
    |> validate_required(@required)
  end
  def sorcery_insert(unit, attrs) do
    unit
    |> cast(attrs, @callable)
    |> validate_required(@required)
  end

end

