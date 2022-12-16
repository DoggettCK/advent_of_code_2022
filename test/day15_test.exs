defmodule Day15Test do
  use ExUnit.Case

  test "part one example" do
    assert 26 =
             "day15"
             |> load_input()
             |> Day15.part_one(10)
  end

  test "part one real" do
    assert 5_607_466 =
             "day15_real"
             |> load_input()
             |> Day15.part_one(2_000_000)
  end

  @tag :skip
  test "part two example" do
    assert 30214 =
             "day15"
             |> load_input()
             |> Day15.part_two()
  end

  @tag :skip
  test "part two real" do
    assert 30214 =
             "day15_real"
             |> load_input()
             |> Day15.part_two()
  end

  defp load_input(fixture) do
    "test/fixtures/#{fixture}"
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
