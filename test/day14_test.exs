defmodule Day14Test do
  use ExUnit.Case

  test "part one" do
    assert 795 =
             load_input()
             |> Day14.part_one()
  end

  test "part two" do
    assert 30214 =
             load_input()
             |> Day14.part_two()
  end

  defp load_input do
    "test/fixtures/day14"
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
