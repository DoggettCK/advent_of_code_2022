defmodule Day15Test do
  use ExUnit.Case

  @tag :skip
  test "part one" do
    assert 795 =
             load_input()
             |> Day15.part_one()
  end

  @tag :skip
  test "part two" do
    assert 30214 =
             load_input()
             |> Day15.part_two()
  end

  defp load_input do
    "test/fixtures/day15"
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
