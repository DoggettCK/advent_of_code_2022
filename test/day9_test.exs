defmodule Day9Test do
  use ExUnit.Case

  test "part one" do
    assert 6175 =
             load_input()
             |> Day9.part_one()
  end

  test "part two" do
    assert 2578 =
             load_input()
             |> Day9.part_two()
  end

  defp load_input do
    "test/fixtures/day9"
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
