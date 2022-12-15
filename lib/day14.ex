defmodule Day14 do
  def part_one(input) do
    input
    |> Enum.reduce(%{}, &populate_map/2)
    |> simulate_sand()
  end

  def part_two(input) do
    map =
      input
      |> Enum.reduce(%{}, &populate_map/2)

    map
    |> get_floor()
    |> then(&simulate_sand(map, &1))
  end

  defp populate_map(points, acc) do
    points
    |> String.split(" -> ")
    |> Enum.map(fn pair ->
      pair
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(acc, &add_rocks/2)
  end

  defp add_rocks([[xs, ys], [xs, ye]], acc) do
    Enum.reduce(ys..ye, acc, fn y, map ->
      Map.put(map, {xs, y}, "#")
    end)
  end

  defp add_rocks([[xs, ys], [xe, ys]], acc) do
    Enum.reduce(xs..xe, acc, fn x, map ->
      Map.put(map, {x, ys}, "#")
    end)
  end

  defp add_sand(map, pos, _floor) when is_map_key(map, pos), do: {:blocked, map}

  defp add_sand(map, {x, y} = pos, floor) do
    [
      {x, y + 1},
      {x - 1, y + 1},
      {x + 1, y + 1}
    ]
    |> Enum.reject(&Map.has_key?(map, &1))
    |> case do
      [{_x, ^floor} | _] ->
        {:placed, Map.put(map, pos, "o")}

      [{_x, y} | _] when y > 1000 ->
        {:abyss, map}

      [] ->
        {:placed, Map.put(map, pos, "o")}

      [next_pos | _] ->
        add_sand(map, next_pos, floor)
    end
  end

  defp simulate_sand(map, floor \\ nil), do: simulate_sand(map, {500, 0}, 0, floor)

  defp simulate_sand(map, spawn_pos, count, floor) do
    case add_sand(map, spawn_pos, floor) do
      {:placed, map} ->
        simulate_sand(map, spawn_pos, count + 1, floor)

      _ ->
        count
    end
  end

  defp get_floor(map) do
    map
    |> Enum.max_by(fn {{_, y}, _} -> y end)
    |> elem(0)
    |> elem(1)
    |> Kernel.+(2)
  end
end
