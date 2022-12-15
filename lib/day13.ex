defmodule Day13 do
  def part_one(input) do
    input
    |> Stream.chunk_every(2)
    |> Stream.map(fn [left, right] -> compare(left, right) end)
    |> Stream.with_index(1)
    |> Enum.group_by(fn {k, _} -> k end, fn {_, v} -> v end)
    |> Map.get(true)
    |> Enum.sum()
  end

  @divider_packet_one [[2]]
  @divider_packet_two [[6]]

  def part_two(input) do
    [@divider_packet_one, @divider_packet_two | input]
    |> Enum.sort(&compare/2)
    |> Enum.with_index(1)
    |> Enum.filter(fn
      {@divider_packet_one, _} -> true
      {@divider_packet_two, _} -> true
      _ -> false
    end)
    |> Enum.map(fn {_, i} -> i end)
    |> Enum.product()
  end

  defp compare(left, right) do
    compare_order(left, right) != :wrong_order
  end

  defp compare_order(left, right) do
    case {left, right} do
      {a, b} when is_integer(a) and is_integer(b) ->
        compare_ints(a, b)

      {a, b} when is_list(a) and is_list(b) ->
        compare_lists(a, b)

      {a, b} when is_integer(a) and is_list(b) ->
        compare_order([a], b)

      {a, b} when is_list(a) and is_integer(b) ->
        compare_order(a, [b])
    end
  end

  defp compare_ints(left, right) when left < right, do: :in_order
  defp compare_ints(left, right) when left > right, do: :wrong_order
  defp compare_ints(left, left), do: :unknown

  defp compare_lists([], []), do: :unknown
  defp compare_lists([], _right), do: :in_order
  defp compare_lists(_left, []), do: :wrong_order

  defp compare_lists([left | tail_left], [right | tail_right]) do
    case compare_order(left, right) do
      :unknown ->
        compare_lists(tail_left, tail_right)

      order ->
        order
    end
  end
end
