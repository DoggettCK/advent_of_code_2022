defmodule Day13Test do
  use ExUnit.Case

  test "part one" do
    assert 5506 =
             load_input()
             |> Day13.part_one()
  end

  test "part two" do
    assert 21756 =
             load_input()
             |> Day13.part_two()
  end

  defp load_input do
    "test/fixtures/day13"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line |> Code.eval_string() |> elem(0)
    end)
  end
end
