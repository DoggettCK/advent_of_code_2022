defmodule Day10Test do
  use ExUnit.Case

  test "part one" do
    assert 13920 =
      load_input()
      |> Day10.part_one()
  end

  test "part two" do
    assert """
####..##..#....#..#.###..#....####...##.
#....#..#.#....#..#.#..#.#....#.......#.
###..#....#....####.###..#....###.....#.
#....#.##.#....#..#.#..#.#....#.......#.
#....#..#.#....#..#.#..#.#....#....#..#.
####..###.####.#..#.###..####.#.....##..
    """ |> String.trim() ==
      load_input()
      |> Day10.part_two()
  end

  defp load_input do
    "test/fixtures/day10"
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
