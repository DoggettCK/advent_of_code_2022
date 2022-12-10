defmodule Day9 do
  @starting_state %{
    knots: [],
    tail_visited: %{}
  }

  def part_one(input) do
    simulate_rope(input, 2)
  end

  def part_two(input) do
    simulate_rope(input, 10)
  end

  defp simulate_rope(input, rope_length) do
    state = %{@starting_state | knots: List.duplicate({0, 0}, rope_length)}

    input
    |> Enum.map(&parse_instruction/1)
    |> Enum.reduce(state, &process_instruction/2)
    # |> cleanup_visited()
    |> Map.get(:tail_visited)
    |> map_size()
  end

  defp parse_instruction(<<direction::binary-size(1), " ", count::binary()>>) do
    {direction, String.to_integer(count)}
  end

  defp process_instruction({direction, steps}, state) do
    process_move(state, direction, steps)
  end

  defp process_move(state, _direction, 0), do: state

  defp process_move(state, direction, steps) do
    %{
      knots: knots,
      tail_visited: tail_visited
    } = state

    [head_pos | tail] = knots

    {new_knots, new_tail_visited} =
      head_pos
      |> step_in_direction(direction)
      |> then(&move_tail(tail, tail_visited, [&1]))

    %{state | knots: new_knots, tail_visited: new_tail_visited}
    |> process_move(direction, steps - 1)
  end

  defp move_tail([], tail_visited, [tail | _] = stack) do
    {Enum.reverse(stack), Map.put(tail_visited, tail, true)}
  end

  defp move_tail([next | knots], tail_visited, [prev | _] = stack) do
    prev
    |> catch_up_tail(next)
    |> then(&move_tail(knots, tail_visited, [&1 | stack]))
  end

  defp step_in_direction({x, y}, "U"), do: {x, y + 1}
  defp step_in_direction({x, y}, "D"), do: {x, y - 1}
  defp step_in_direction({x, y}, "L"), do: {x - 1, y}
  defp step_in_direction({x, y}, "R"), do: {x + 1, y}

  defp catch_up_tail({hx, hy}, {tx, ty}) do
    cond do
      {tx, ty} == {hx + 0, hy + 2} -> {hx, hy + 1}
      {tx, ty} == {hx + 1, hy + 2} -> {hx, hy + 1}
      {tx, ty} == {hx + 1, hy - 2} -> {hx, hy - 1}
      {tx, ty} == {hx + 2, hy + 0} -> {hx + 1, hy}
      {tx, ty} == {hx + 2, hy + 1} -> {hx + 1, hy}
      {tx, ty} == {hx + 2, hy + 2} -> {hx + 1, hy + 1}
      {tx, ty} == {hx + 2, hy - 1} -> {hx + 1, hy}
      {tx, ty} == {hx + 2, hy - 2} -> {hx + 1, hy - 1}
      {tx, ty} == {hx - 0, hy - 2} -> {hx, hy - 1}
      {tx, ty} == {hx - 1, hy + 2} -> {hx, hy + 1}
      {tx, ty} == {hx - 1, hy - 2} -> {hx, hy - 1}
      {tx, ty} == {hx - 2, hy + 1} -> {hx - 1, hy}
      {tx, ty} == {hx - 2, hy + 2} -> {hx - 1, hy + 1}
      {tx, ty} == {hx - 2, hy - 0} -> {hx - 1, hy}
      {tx, ty} == {hx - 2, hy - 1} -> {hx - 1, hy}
      {tx, ty} == {hx - 2, hy - 2} -> {hx - 1, hy - 1}
      true -> {tx, ty}
    end
  end
end
