defmodule Day5 do
  @starting_queues %{
    1 => ~w(G J Z),
    2 => ~w(C V F W P R L Q),
    3 => ~w(R G L C M P F),
    4 => ~w(M H P W B F L),
    5 => ~w(Q V S F C G),
    6 => ~w(L T Q M Z J H W),
    7 => ~w(V B S F H),
    8 => ~w(S Z J F),
    9 => ~w(T B H F P D C M)
  }

  def part_one(input) do
    final_queues =
      Enum.reduce(input, @starting_queues, fn move, queues ->
        process_move(move, queues, &move_between_queues/3)
      end)

    1..9
    |> Enum.map(&(Map.get(final_queues, &1) |> hd()))
    |> Enum.join()
  end

  def part_two(input) do
    final_queues =
      Enum.reduce(input, @starting_queues, fn move, queues ->
        process_move(move, queues, &move_between_stacks/3)
      end)

    1..9
    |> Enum.map(&(Map.get(final_queues, &1) |> hd()))
    |> Enum.join()
  end

  defp process_move(move, queues, mover) do
    ~r/\d+/
    |> Regex.scan(move)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
    |> move_items(queues, mover)
  end

  defp move_items([qty, from, to], queues, mover) do
    %{^from => from_queue, ^to => to_queue} = queues

    [new_from_queue, new_to_queue] = mover.(qty, from_queue, to_queue)

    %{queues | from => new_from_queue, to => new_to_queue}
  end

  defp move_between_queues(0, from, to), do: [from, to]
  defp move_between_queues(_qty, [], to), do: [[], to]

  defp move_between_queues(qty, [next | from], to) do
    move_between_queues(qty - 1, from, [next | to])
  end

  defp move_between_stacks(qty, from, to) do
    {h, from_queue} = Enum.split(from, qty)

    [from_queue, h ++ to]
  end
end
