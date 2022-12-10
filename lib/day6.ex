defmodule Day6 do
  def part_one(input) do
    {_, index} = find_unique_run(input, 4)
    index
  end

  def part_two(input) do
    {_, index} = find_unique_run(input, 14)
    index
  end

  defp find_unique_run(input, size) do
    input
    |> Stream.chunk_every(size, 1)
    |> Stream.map(&Enum.uniq(&1))
    |> Enum.with_index(size)
    |> Enum.find(fn {l, _} -> Enum.count(l) == size end)
  end
end
