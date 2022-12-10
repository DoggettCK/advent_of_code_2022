defmodule Day7Test do
  use ExUnit.Case

  test "part one" do
    assert 1_141_028 =
             load_input()
             |> Day7.part_one()
  end

  test "part two" do
    assert 8_278_005 =
             load_input()
             |> Day7.part_two()
  end

  defp load_input do
    "test/fixtures/day7"
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
