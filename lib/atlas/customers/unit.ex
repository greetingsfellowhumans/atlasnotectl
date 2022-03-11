defmodule Atlas.Customers.Unit do
  use Ecto.Schema
  import Ecto.Changeset

  schema "unit" do
    field :location_number, :integer
    field :unit_number, :string

  end

  def create_changeset(unit, attrs) do
    unit
    |> cast(attrs, [:unit_number, :location_number])
    |> validate_required([:location_number, :unit_number])
  end

  def sorcery_update(unit, attrs) do
    unit
    |> cast(attrs, [:unit_number, :location_number])
    |> validate_required([:location_number, :unit_number])
  end
  def sorcery_insert(unit, attrs) do
    unit
    |> cast(attrs, [:unit_number, :location_number])
    |> validate_required([:location_number, :unit_number])
  end

end

