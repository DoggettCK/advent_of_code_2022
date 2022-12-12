defmodule Day11Test do
  use ExUnit.Case

  test "part one" do
    assert 316_888 =
             load_input()
             |> Day11.part_one()
  end

  test "part two" do
    assert 35_270_398_814 =
             load_input()
             |> Day11.part_two()
  end

  defp load_input do
    "test/fixtures/day11"
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
