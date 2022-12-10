defmodule Day1Test do
  use ExUnit.Case

  test "part one" do
    assert {150, 69912} =
             load_input()
             |> Day1.part_one()
  end

  test "part two" do
    assert 208_180 =
             load_input()
             |> Day1.part_two()
  end

  defp load_input do
    "test/fixtures/day1"
    |> File.read!()
    |> String.split("\n")
  end
end
