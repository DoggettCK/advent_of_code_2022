defmodule Day8Test do
  use ExUnit.Case

  test "part one" do
    assert 1825 =
             load_input()
             |> Day8.part_one()
  end

  test "part two" do
    assert 235_200 =
             load_input()
             |> Day8.part_two()
  end

  defp load_input do
    "test/fixtures/day8"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn s ->
      s
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
