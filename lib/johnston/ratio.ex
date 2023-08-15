defmodule Johnston.Ratio do
  defstruct [:numerator, :denominator]

  def new(numerator, denominator) do
    with {n, d} <- reduce(numerator, denominator) do
      %__MODULE__{
        numerator: n,
        denominator: d
      }
    end
  end

  def add(%__MODULE__{numerator: a, denominator: b}, %__MODULE__{numerator: c, denominator: d}) do
    new(a * c, b * d)
  end

  def subtract(%__MODULE__{numerator: a, denominator: b}, %__MODULE__{
        numerator: c,
        denominator: d
      }) do
    new(a * d, b * c)
  end

  def complement(%__MODULE__{} = r) do
    normalize(subtract(new(2, 1), r))
  end

  def power(%__MODULE__{}, 0), do: new(1, 1)

  def power(%__MODULE__{} = r, e) when e < 0 do
    power(complement(r), -e)
  end

  def power(%__MODULE__{numerator: n, denominator: d}, e) do
    new(round(:math.pow(n, e)), round(:math.pow(d, e)))
    |> normalize()
  end

  def normalize(%__MODULE__{numerator: n, denominator: d} = ratio) do
    cond do
      n / d < 1 -> normalize(new(n * 2, d))
      n / d >= 2 -> normalize(new(n, d * 2))
      true -> ratio
    end
  end

  defp reduce(a, b) do
    with g <- Integer.gcd(a, b) do
      {round(a / g), round(b / g)}
    end
  end
end
