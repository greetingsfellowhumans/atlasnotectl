defmodule Interceptors.IncUnit do


  def inc_unit(%{args: %{unit_id: id}} = src) do
    update_in(src, [:unit, id, :unit_number], fn str ->
      String.to_integer(str) + 1 |> Integer.to_string()
    end)
  end


end
