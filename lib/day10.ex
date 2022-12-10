defmodule Day10 do
  def part_one(input) do
    input
    |> get_signal_strengths()
    |> Map.take([20, 60, 100, 140, 180, 220])
    |> Enum.reduce(0, fn {cycle, value}, strength -> cycle * value + strength end)
  end

  def part_two(input) do
    signal_strengths = get_signal_strengths(input)

    0..239
    |> Enum.reduce(%{signal_strengths: signal_strengths, pixels: []}, &draw_pixel/2)
    |> Map.get(:pixels)
    |> Enum.reverse()
    |> Enum.chunk_every(40)
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.join("\n")
  end

  defp get_signal_strengths(input) do
    input
    |> Enum.reduce([], &process_instructions/2)
    |> calculate_register([1])
    |> Enum.with_index(1)
    |> Enum.into(%{}, fn {element, index} -> {index, element} end)
  end

  defp process_instructions("noop", queue), do: queue ++ [0]
  defp process_instructions("addx " <> count, queue), do: queue ++ [0, String.to_integer(count)]

  defp calculate_register([], register), do: Enum.reverse(register)
  defp calculate_register([head | tail], [register_head | _] = register) do
    calculate_register(tail, [head + register_head | register])
  end

  defp draw_pixel(cycle, %{signal_strengths: signal_strengths, pixels: pixels} = state) do
    sprite_pos =
      signal_strengths
      |> Map.get(cycle + 1)
      |> rem(40)

    pixel_value =
      cycle
      |> rem(40)
      |> Kernel.-(sprite_pos)
      |> abs()
      |> case do
        0 -> "#"
        1 -> "#"
        _ -> "."
      end

    %{state | pixels: [pixel_value | pixels]}
  end
end
