defmodule Day1 do
  def part_one(input) do
    input
    |> process_input(0, 0, %{})
    |> Enum.max_by(fn {_, v} -> v end)
  end

  def part_two(input) do
    input
    |> process_input(0, 0, %{})
    |> Enum.sort_by(fn {_, v} -> -v end)
    |> Enum.take(3)
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.sum()
  end

  defp process_input([], _current_elf, _current_weight, elves), do: elves

  defp process_input(["" | rest], current_elf, current_weight, elves) do
    elves
    |> Map.put(current_elf, current_weight)
    |> then(&process_input(rest, current_elf + 1, 0, &1))
  end

  defp process_input([weight | rest], current_elf, current_weight, elves) do
    weight
    |> String.to_integer()
    |> Kernel.+(current_weight)
    |> then(&process_input(rest, current_elf, &1, elves))
  end
end
