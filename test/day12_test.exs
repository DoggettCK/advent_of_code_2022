defmodule Day12Test do
  use ExUnit.Case

  test "part one" do
    assert 412 =
             load_input()
             |> Day12.part_one()
  end

  test "part two" do
    assert 402 =
             load_input()
             |> Day12.part_two()
  end

  defp load_input do
    "test/fixtures/day12"
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
