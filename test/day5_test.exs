defmodule Day5Test do
  use ExUnit.Case

  test "part one" do
    assert "WSFTMRHPP" =
             load_input()
             |> Day5.part_one()
  end

  test "part two" do
    assert "GSLCMFBRP" =
             load_input()
             |> Day5.part_two()
  end

  defp load_input do
    "test/fixtures/day5"
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
