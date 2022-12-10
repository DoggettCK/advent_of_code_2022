defmodule Day4 do
  def part_one(input) do
    Enum.reduce(input, 0, &count_whole_overlaps/2)
  end

  def part_two(input) do
    Enum.reduce(input, 0, &count_overlaps/2)
  end

  defp count_overlaps(str, count) do
    ~r/\d+/
    |> Regex.scan(str)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
    |> overlaps?(count)
  end

  defp count_whole_overlaps(str, count) do
    ~r/\d+/
    |> Regex.scan(str)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
    |> overlaps_entirely?(count)
  end

  defp overlaps?([a, _, c, d], count) when a >= c and a <= d, do: count + 1
  defp overlaps?([_, b, c, d], count) when b >= c and b <= d, do: count + 1
  defp overlaps?([a, b, c, _], count) when c >= a and c <= b, do: count + 1
  defp overlaps?([a, b, _, d], count) when d >= a and d <= b, do: count + 1
  defp overlaps?(_, count), do: count

  defp overlaps_entirely?([a, b, c, d], count) when a <= c and b >= d, do: count + 1
  defp overlaps_entirely?([a, b, c, d], count) when c <= a and d >= b, do: count + 1
  defp overlaps_entirely?(_, count), do: count
end
