defmodule Johnston.Lattice do
  @moduledoc """
  Models an n-dimensional just intonation lattice.

  Each dimension can be bounded independently. Bounds can take three forms:

  1. `:inf` - infinite bounds; indexing into the lattice will return the ratio at the absolute value provided
  2. single integer - defines the size (starting from and including 0) of the dimension; a bound of `2` means that the unique indicies are [0, 1]. A bound of `-3` means that the unique indices are [0, -2, -1].
  3. a 2-tuple of integers - defines the boundaries (inclusive) of the dimension; a bound of `{-1, 2}` means the unique indices are [0, 1, 2, -1, 0, ...]

  """

  alias Johnston.Ratio

  defmodule Dimension do
    defstruct [:ratio, :bounds]
  end

  defstruct [:dimensions]

  def new(edge_ratios, bounds \\ []) do
    dimensions =
      edge_ratios
      |> Enum.map(&Ratio.normalize/1)
      |> Enum.zip(generate_bounds(bounds, length(edge_ratios)))
      |> Enum.map(fn {r, b} -> %Dimension{ratio: r, bounds: b} end)

    %__MODULE__{dimensions: dimensions}
  end

  def at(%__MODULE__{dimensions: dimensions}, coordinates) do
    Enum.zip(dimensions, coordinates)
    |> Enum.map(fn {%Dimension{ratio: ratio, bounds: bounds}, pow} ->
      e = determine_power(pow, bounds)
      Ratio.power(ratio, e)
    end)
    |> Enum.reduce(Ratio.new(1, 1), &Ratio.normalize(Ratio.add(&1, &2)))
  end

  defp determine_power(pow, :inf), do: pow

  defp determine_power(pow, bounds) when is_integer(bounds) do
    Integer.mod(pow, bounds)
  end

  defp determine_power(pow, {min, max}) do
    size = max - min + 1
    diff = abs(min)

    Integer.mod(pow + diff, size) - diff
  end

  defp generate_bounds(existing_bounds, total_length) do
    [bounds] =
      Stream.iterate(existing_bounds, &(&1 ++ [:inf]))
      |> Stream.drop(total_length)
      |> Enum.take(1)

    bounds
  end
end
