defmodule Day11 do
  def part_one(input) do
    input
    |> parse_monkeys()
    |> process_rounds(20, 3)
    |> top_n_inspected_product(2)
  end

  def part_two(input) do
    input
    |> parse_monkeys()
    |> process_rounds(10_000, 1)
    |> top_n_inspected_product(2)
  end

  defp process_rounds(monkeys, rounds, relief_factor) do
    monkey_count =
      monkeys
      |> Map.drop([:lcm])
      |> map_size()

    process_rounds(monkeys, rounds, relief_factor, 0, monkey_count)
  end

  defp process_rounds(monkeys, 0, _, _, _), do: monkeys

  defp process_rounds(monkeys, round, relief_factor, monkey_count, monkey_count) do
    process_rounds(monkeys, round - 1, relief_factor, 0, monkey_count)
  end

  defp process_rounds(monkeys, round, relief_factor, current_monkey, monkey_count) do
    monkeys
    |> process_monkey(current_monkey, relief_factor)
    |> process_rounds(round, relief_factor, current_monkey + 1, monkey_count)
  end

  defp process_monkey(monkeys, id, relief_factor) do
    %{
      items: items,
      operation: operation,
      test_fun: test_fun
    } = Map.get(monkeys, id)

    %{lcm: lcm} = monkeys

    item_count = :queue.len(items)

    fn item, acc ->
      new_worry_level =
        item
        |> operation.()
        |> rem(lcm)
        |> div(relief_factor)

      throw_to_monkey =
        new_worry_level
        |> test_fun.()

      acc
      |> update_in([throw_to_monkey, :items], &:queue.in(new_worry_level, &1))
    end
    |> :queue.fold(monkeys, items)
    |> put_in([id, :items], :queue.new())
    |> update_in([id, :inspected], &(&1 + item_count))
  end

  defp parse_monkeys(input) do
    monkeys =
      input
      |> Enum.chunk_every(6)
      |> Enum.map(&parse_monkey/1)

    lcm =
      monkeys
      |> Enum.map(fn {_, v} -> Map.get(v, :divisor) end)
      |> Enum.product()

    monkeys
    |> Enum.into(%{}, fn {k, v} -> {k, Map.drop(v, [:divisor])} end)
    |> Map.put(:lcm, lcm)
  end

  defp parse_monkey(instructions) do
    [id, items, operation | test_lines] = instructions
    [divisor_line | _] = test_lines

    [id] = get_integers(id)

    items =
      items
      |> get_integers()
      |> :queue.from_list()

    operation = build_operation(operation)
    test_fun = build_test(test_lines)
    [divisor | _] = get_integers(divisor_line)

    {id,
     %{items: items, operation: operation, test_fun: test_fun, inspected: 0, divisor: divisor}}
  end

  defp get_integers(str) do
    ~r/\d+/
    |> Regex.scan(str)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
  end

  defp build_operation(operation) do
    "Operation: new = old " <> code_str = String.trim(operation)

    build_operation_func(code_str)
  end

  defp build_operation_func("* old") do
    fn old -> old * old end
  end

  defp build_operation_func("* " <> mult_str) do
    {i_val, _} = Integer.parse(mult_str)

    fn old -> old * i_val end
  end

  defp build_operation_func("+ " <> add_str) do
    {i_val, _} = Integer.parse(add_str)

    fn old -> old + i_val end
  end

  defp build_test(test_lines) do
    [a, b, c] =
      test_lines
      |> Enum.join()
      |> get_integers()

    fn item -> if rem(item, a) == 0, do: b, else: c end
  end

  defp top_n_inspected_product(monkeys, count) do
    monkeys
    |> Map.drop([:lcm])
    |> Enum.sort_by(fn {_, monkey} -> monkey.inspected end, :desc)
    |> Enum.take(count)
    |> Enum.map(fn {_, monkey} -> monkey.inspected end)
    |> Enum.product()
  end
end
