defmodule Day15 do
  def part_one(input, row) do
    input
    |> build_map()
    |> build_row_intervals(row)
    |> merge_intervals()
    |> Enum.reduce(0, fn [s, e], acc -> acc + e - s end)
  end

  def part_two(_input) do
  end

  defp build_map(input) do
    Enum.reduce(input, %{nearest_beacons: %{}}, &parse_sensor_and_beacon/2)
  end

  defp parse_sensor_and_beacon(line, sensor_map) do
    [sx, sy, bx, by] =
      ~r/\-?\d+/
      |> Regex.scan(line)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)

    sensor_map
    |> Map.put({sx, sy}, "S")
    |> Map.put({bx, by}, "B")
    |> put_in([:nearest_beacons, {sx, sy}], {bx, by})
  end

  defp manhattan_row_interval({sx, sy} = sensor, beacon, row) do
    distance = manhattan_distance(sensor, beacon)

    cond do
      row in (sy - distance)..(sy + distance) ->
        # from sx-dist to sx, find first within manhattan distance (dx), return [dx, (sx-dx)+sx]
        interval_start =
          (sx - distance)..sx
          |> Enum.find(fn x -> manhattan_distance(sensor, {x, row}) <= distance end)

        [interval_start, 2 * sx - interval_start]

      true ->
        []
    end
  end

  defp manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  defp build_row_intervals(map, row) do
    map
    |> get_in([:nearest_beacons])
    |> Enum.map(fn {sensor, beacon} -> manhattan_row_interval(sensor, beacon, row) end)
    |> Enum.reject(&Enum.empty?/1)
    |> Enum.sort()
  end

  defp merge_intervals(list_of_intervals) do
    # Precondition: list_of_intervals is sorted and empty lists removed
    case merge_intervals(list_of_intervals, []) do
      ^list_of_intervals ->
        list_of_intervals

      possible_remaining_overlaps ->
        merge_intervals(possible_remaining_overlaps)
    end
  end

  defp merge_intervals([], merged_intervals), do: Enum.sort(merged_intervals)

  defp merge_intervals([i1, i2 | list_intervals], merged_intervals) do
    case overlap(i1, i2) do
      [^i1, ^i2] ->
        merge_intervals([i2 | list_intervals], [i1 | merged_intervals])

      [single] ->
        merge_intervals([single | list_intervals], merged_intervals)
    end
  end

  defp merge_intervals([single_interval], merged_intervals) do
    merge_intervals([], [single_interval | merged_intervals])
  end

  defp overlap([s1, e1], [s2, e2]) do
    # Precondition: s1 <= s2
    cond do
      s2 > e1 ->
        [[s1, e1], [s2, e2]]

      e2 > e1 ->
        [[s1, e2]]

      true ->
        [[s1, e1]]
    end
  end
end
