defmodule Day6Test do
  use ExUnit.Case

  test "part one" do
    assert 1651 =
             load_input()
             |> Day6.part_one()
  end

  test "part two" do
    assert 3837 =
             load_input()
             |> Day6.part_two()
  end

  defp load_input do
    "test/fixtures/day6"
    |> File.read!()
    |> String.split("", trim: true)
  end
end
