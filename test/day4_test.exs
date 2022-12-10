defmodule Day4Test do
  use ExUnit.Case

  test "part one" do
    assert 509 =
             load_input()
             |> Day4.part_one()
  end

  test "part two" do
    assert 870 =
             load_input()
             |> Day4.part_two()
  end

  defp load_input do
    "test/fixtures/day4"
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
