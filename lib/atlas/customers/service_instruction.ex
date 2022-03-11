defmodule Atlas.Customers.ServiceInstruction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "service_instruction" do
    field :call_id, :integer
    field :type, :string
    field :description, :string

  end

  @callable [:call_id, :type, :description]
  @required [:call_id, :type]

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

