defmodule Day2Test do
  use ExUnit.Case

  test "part one" do
    assert 14375 =
             load_input()
             |> Day2.part_one()
  end

  test "part two" do
    assert 10274 =
             load_input()
             |> Day2.part_two()
  end

  defp load_input do
    "test/fixtures/day2"
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
