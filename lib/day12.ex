defmodule Day12 do
  def part_one(input) do
    %{
      start_pos: start_pos,
      end_pos: end_pos,
      graph: graph
    } = build_graph(input)

    graph
    |> Map.keys()
    |> Map.new(&{&1, :infinity})
    |> Map.put(start_pos, 0)
    |> dijkstra(graph, end_pos)
  end

  def part_two(input) do
    %{
      start_pos: start_pos,
      end_pos: end_pos,
      graph: graph
    } = build_graph(input)

    graph
    |> Map.keys()
    |> Map.new(&{&1, :infinity})
    |> Map.put(start_pos, 0)
    |> then(fn distances ->
      graph
      |> Map.filter(fn {_, v} -> v == 0 end)
      |> Map.keys()
      |> Enum.reduce(distances, fn current, dists ->
        Map.put(dists, current, 0)
      end)
    end)
    |> dijkstra(graph, end_pos)
  end

  defp build_graph(input_lines) do
    input_lines
    |> Enum.with_index(fn line, row ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index(fn label, col ->
        {col, row, label}
      end)
    end)
    |> List.flatten()
    |> Enum.reduce(%{start_pos: {0, 0}, end_pos: {0, 0}, graph: %{}}, &populate_graph/2)
  end

  defp populate_graph({x, y, "S"}, map) do
    %{map | start_pos: {x, y}, graph: Map.put(map.graph, {x, y}, height("S"))}
  end

  defp populate_graph({x, y, "E"}, map) do
    %{map | end_pos: {x, y}, graph: Map.put(map.graph, {x, y}, height("E"))}
  end

  defp populate_graph({x, y, label}, map) do
    %{map | graph: Map.put(map.graph, {x, y}, height(label))}
  end

  defp height("S"), do: height("a")
  defp height("E"), do: height("z")
  defp height(<<c>>), do: c - ?a

  defp dijkstra(distances, graph, end_pos) do
    case Enum.min_by(distances, fn {_, v} -> v end) do
      {^end_pos, distance} ->
        distance

      {current, distance} ->
        current
        |> neighbors(graph)
        |> Enum.reduce(distances, fn pos, dists ->
          Map.replace_lazy(dists, pos, fn dist ->
            min(dist, distance + 1)
          end)
        end)
        |> Map.delete(current)
        |> dijkstra(graph, end_pos)
    end
  end

  defp neighbors({x, y}, graph) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1}
    ]
    |> Enum.filter(fn current ->
      graph[current] <= graph[{x, y}] + 1
    end)
  end
end
