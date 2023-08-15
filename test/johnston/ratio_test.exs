defmodule Johnston.RatioTest do
  use ExUnit.Case, async: true

  alias Johnston.Ratio

  describe "new" do
    test "constructs a ratio from two integers" do
      assert Ratio.new(3, 2) == %Ratio{
               numerator: 3,
               denominator: 2
             }
    end

    test "reduces the fraction based on GCD" do
      assert Ratio.new(3, 6) == %Ratio{
               numerator: 1,
               denominator: 2
             }
    end
  end

  describe "normalize" do
    test "ensures a ratio is in the range [1, 2)" do
      assert Ratio.new(1, 2) |> Ratio.normalize() == Ratio.new(1, 1)

      assert Ratio.new(2, 1) |> Ratio.normalize() == Ratio.new(1, 1)

      assert Ratio.new(9, 4) |> Ratio.normalize() == Ratio.new(9, 8)
    end
  end

  describe "add" do
    test "adds two ratios" do
      r1 = Ratio.new(3, 2)
      r2 = Ratio.new(9, 8)

      assert Ratio.add(r1, r2) == Ratio.new(27, 16)
    end
  end

  describe "subtract" do
    test "subtracts one ratio from another" do
      r1 = Ratio.new(3, 2)
      r2 = Ratio.new(9, 8)

      assert Ratio.subtract(r1, r2) == Ratio.new(4, 3)
      assert Ratio.subtract(r2, r1) == Ratio.new(3, 4)
    end
  end

  describe "complement" do
    test "returns the ratio that, with the given ratio, completes the octave" do
      assert Ratio.complement(Ratio.new(3, 2)) == Ratio.new(4, 3)

      assert Ratio.complement(Ratio.new(9, 8)) == Ratio.new(16, 9)
    end
  end

  describe "power" do
    test "raises the ratio to the given power" do
      r1 = Ratio.new(3, 2)

      assert Ratio.power(r1, 0) == Ratio.new(1, 1)
      assert Ratio.power(r1, 1) == Ratio.new(3, 2)
      assert Ratio.power(r1, 2) == Ratio.new(9, 8)
      assert Ratio.power(r1, -2) == Ratio.new(16, 9)
    end
  end
end
