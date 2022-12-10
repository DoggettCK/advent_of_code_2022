defmodule Day7 do
  def part_one(input) do
    input
    |> build_file_system(%{}, [])
    |> disk_usage()
  end

  def part_two(input) do
    input
    |> build_file_system(%{}, [])
    |> smallest_dir_to_remove(70_000_000, 30_000_000)
  end

  defp build_file_system([], dir_tree, _current_path) do
    dir_tree
  end

  defp build_file_system(["$ ls" | rest], dir_tree, current_path) do
    build_file_system(rest, dir_tree, current_path)
  end

  defp build_file_system(["$ cd /" | rest], dir_tree, current_path) do
    build_file_system(rest, dir_tree, ["/" | current_path])
  end

  defp build_file_system(["$ cd .." | rest], dir_tree, [_current_dir | parent]) do
    build_file_system(rest, dir_tree, parent)
  end

  defp build_file_system(["$ cd " <> dir | rest], dir_tree, current_path) do
    build_file_system(rest, dir_tree, [dir | current_path])
  end

  defp build_file_system(["dir " <> _dir | rest], dir_tree, current_path) do
    build_file_system(rest, dir_tree, current_path)
  end

  defp build_file_system([command | rest], dir_tree, current_path) do
    [size, filename] = String.split(command, " ")

    int_size = String.to_integer(size)

    [filename | current_path]
    |> Enum.reverse()
    |> Enum.map(&Access.key(&1, %{}))
    |> then(&put_in(dir_tree, &1, int_size))
    |> then(&build_file_system(rest, &1, current_path))
  end

  defp disk_usage(file_system) do
    file_system
    |> get_directory_sizes()
    |> Enum.filter(fn {_, v} -> v <= 100_000 end)
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.sum()
  end

  defp get_directory_sizes(file_system) do
    file_system
    |> Enum.reduce(%{current_path: ["/"], sizes: %{}}, &calculate_directory_size/2)
    |> Map.get(:sizes)
  end

  defp calculate_directory_size({_, child}, acc) when is_number(child) do
    sizes =
      acc.current_path
      |> Enum.reduce(acc.sizes, fn path, sizes ->
        Map.update(sizes, path, child, &(&1 + child))
      end)

    %{acc | sizes: sizes}
  end

  defp calculate_directory_size({dir, child}, %{current_path: current_path} = acc)
       when is_map(child) do
    [parent | _] = current_path

    child
    |> Enum.reduce(
      %{acc | current_path: [Path.join(parent, dir) | current_path]},
      &calculate_directory_size/2
    )
    |> Map.put(:current_path, current_path)
  end

  defp smallest_dir_to_remove(file_system, max_disk_space, disk_space_needed) do
    dir_sizes = get_directory_sizes(file_system)
    root_size = Map.get(dir_sizes, "/")

    space_available = max_disk_space - root_size
    space_needed = disk_space_needed - space_available

    dir_sizes
    |> Enum.filter(fn {_, v} -> v >= space_needed end)
    |> Enum.min_by(fn {_, v} -> v end)
    |> elem(1)
  end
end
