defmodule Day3Test do
  use ExUnit.Case

  test "part one" do
    assert 8039 =
             load_input()
             |> Day3.part_one()
  end

  test "part two" do
    assert 2510 =
             load_input()
             |> Day3.part_two()
  end

  defp load_input do
    "test/fixtures/day3"
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
