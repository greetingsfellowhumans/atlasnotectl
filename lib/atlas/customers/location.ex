defmodule Atlas.Customers.Location do
  use Ecto.Schema
  import Ecto.Changeset

  schema "location" do
    field :location_number, :integer
    field :name, :string

  end

  def create_changeset(location, attrs) do
    location
    |> cast(attrs, [:name, :location_number])
    |> validate_required([:location_number, :name])
  end

  def number_changeset(location, attrs) do
    location
    |> cast(attrs, [:location_number])
    |> validate_required([:location_number])
  end

  
  def sorcery_insert(location, attrs) do
    location
    |> cast(attrs, [:name, :location_number])
    |> validate_required([:location_number, :name])
  end
  
  def sorcery_update(location, attrs) do
    location
    |> cast(attrs, [:name, :location_number])
    |> validate_required([:location_number, :name])
  end
  
end
