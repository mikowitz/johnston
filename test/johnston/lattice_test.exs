defmodule Johnston.LatticeTest do
  use ExUnit.Case, async: true

  alias Johnston.{Lattice, Ratio}

  describe "one dimensional infinite lattice" do
    test "all found ratios are in [1, 2)" do
      lattice = Lattice.new([Ratio.new(3, 2)])

      assert Lattice.at(lattice, [0]) == Ratio.new(1, 1)
      assert Lattice.at(lattice, [1]) == Ratio.new(3, 2)
      assert Lattice.at(lattice, [-1]) == Ratio.new(4, 3)
      assert Lattice.at(lattice, [2]) == Ratio.new(9, 8)
      assert Lattice.at(lattice, [-3]) == Ratio.new(32, 27)
    end

    test "ignores higher dimensions" do
      lattice = Lattice.new([Ratio.new(3, 2)])

      assert Lattice.at(lattice, [1, 2, 3]) == Ratio.new(3, 2)
    end
  end

  describe "one dimensional bounded lattice" do
    test "bounds are [0, n)" do
      lattice = Lattice.new([Ratio.new(3, 2)], [2])

      assert Lattice.at(lattice, [0]) == Ratio.new(1, 1)
      assert Lattice.at(lattice, [1]) == Ratio.new(3, 2)
      assert Lattice.at(lattice, [2]) == Ratio.new(1, 1)
      assert Lattice.at(lattice, [3]) == Ratio.new(3, 2)
    end

    test "can have negative bounds" do
      lattice = Lattice.new([Ratio.new(3, 2)], [-2])

      assert Lattice.at(lattice, [0]) == Ratio.new(1, 1)
      assert Lattice.at(lattice, [1]) == Ratio.new(4, 3)
      assert Lattice.at(lattice, [2]) == Ratio.new(1, 1)
      assert Lattice.at(lattice, [3]) == Ratio.new(4, 3)
    end
  end

  describe "one dimensional non-0 bounded lattice" do
    test "bounds are [a, b]" do
      lattice = Lattice.new([Ratio.new(3, 2)], [{-1, 1}])

      assert Lattice.at(lattice, [0]) == Ratio.new(1, 1)
      assert Lattice.at(lattice, [1]) == Ratio.new(3, 2)
      assert Lattice.at(lattice, [2]) == Ratio.new(4, 3)
      assert Lattice.at(lattice, [3]) == Ratio.new(1, 1)
    end
  end

  describe "two dimensional infinite lattice" do
    lattice =
      Lattice.new([
        Ratio.new(3, 2),
        Ratio.new(5, 4)
      ])

    assert Lattice.at(lattice, [0]) == Ratio.new(1, 1)
    assert Lattice.at(lattice, [1]) == Ratio.new(3, 2)
    assert Lattice.at(lattice, [0, 1]) == Ratio.new(5, 4)
    assert Lattice.at(lattice, [1, 1]) == Ratio.new(15, 8)
    assert Lattice.at(lattice, [1, -1]) == Ratio.new(6, 5)
  end

  describe "two dimensional bounded lattice" do
    lattice =
      Lattice.new(
        [
          Ratio.new(3, 2),
          Ratio.new(5, 4)
        ],
        [{-1, 2}, 3]
      )

    assert Lattice.at(lattice, [2, 2]) == Ratio.new(225, 128)
    assert Lattice.at(lattice, [3, 2]) == Ratio.new(25, 24)
    assert Lattice.at(lattice, [2, 3]) == Ratio.new(9, 8)
  end
end
