defmodule Day8 do
  def part_one(input) do
    grid = build_grid(input)

    visible_horizontally =
      grid
      |> get_visible(:rows)
      |> MapSet.new()

    visible_vertically =
      grid
      |> get_visible(:columns)
      |> MapSet.new()

    visible_horizontally
    |> MapSet.union(visible_vertically)
    |> MapSet.to_list()
    |> length()
  end

  def part_two(input) do
    n = length(input)

    views =
      for column <- 0..(n - 1), row <- 0..(n - 1) do
        {{column, row}, 1}
      end
      |> Enum.into(%{})

    grid = build_grid(input)

    for column <- 0..(n - 1), row <- 0..(n - 1) do
      {row_before, row_after, target} =
        grid
        |> Map.get(:rows)
        |> Enum.at(row)
        |> fracture(column)

      {column_before, column_after, ^target} =
        grid
        |> Map.get(:columns)
        |> Enum.at(column)
        |> fracture(row)

      [column, row, target, column_before, row_before, row_after, column_after]
    end
    |> Enum.reduce(views, &calculate_view/2)
    |> Enum.max_by(fn {_, v} -> v end)
    |> elem(1)
  end

  defp build_grid(input) do
    rows = input

    columns =
      input
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)

    %{
      count: length(rows),
      rows: rows,
      columns: columns,
      rows_reversed: rows |> Enum.map(&Enum.reverse/1),
      columns_reversed: columns |> Enum.map(&Enum.reverse/1)
    }
  end

  defp get_visible(grid, direction) do
    reversed = :"#{direction}_reversed"

    %{
      :count => count,
      ^direction => forward,
      ^reversed => reversed
    } = grid

    forward
    |> Enum.zip(reversed)
    |> Enum.map(fn {forward_list, reversed_list} ->
      count_visibility_each_way(forward_list, reversed_list, count)
    end)
    |> Enum.with_index(fn visible, index ->
      case direction do
        :rows ->
          Enum.map(visible, &{&1, index})

        :columns ->
          Enum.map(visible, &{index, &1})
      end
    end)
    |> List.flatten()
  end

  defp count_visibility_each_way(forward, reversed, count) do
    forward_visible =
      forward
      |> count_forward(0, -1, [])
      |> MapSet.new()

    backward_visible =
      reversed
      |> count_backward(count - 1, -1, [])
      |> MapSet.new()

    forward_visible
    |> MapSet.union(backward_visible)
    |> MapSet.to_list()
  end

  defp count_forward([], _index, _tallest, visible), do: visible

  defp count_forward([h | t], index, tallest, visible) when h > tallest do
    count_forward(t, index + 1, h, [index | visible])
  end

  defp count_forward([_ | t], index, tallest, visible) do
    count_forward(t, index + 1, tallest, visible)
  end

  defp count_backward([], _index, _tallest, visible), do: visible

  defp count_backward([h | t], index, tallest, visible) when h > tallest do
    count_backward(t, index - 1, h, [index | visible])
  end

  defp count_backward([_ | t], index, tallest, visible) do
    count_backward(t, index - 1, tallest, visible)
  end

  defp fracture(list, index) do
    {head, tail} = Enum.split(list, index + 1)

    [target | rest] = Enum.reverse(head)

    {rest, tail, target}
  end

  defp calculate_view(lists, views) do
    [column, row, target | rest] = lists

    rest
    |> Enum.map(&count_viewable(&1, target))
    |> Enum.product()
    |> then(&Map.put(views, {column, row}, &1))
  end

  defp count_viewable(list, target) do
    count_viewable(list, target, 0)
  end

  def count_viewable([], _target, count), do: count
  def count_viewable([h | _], target, count) when h >= target, do: count + 1

  def count_viewable([h | t], target, count) when h < target do
    count_viewable(t, target, count + 1)
  end

  def count_viewable(_, _target, count), do: count
end
