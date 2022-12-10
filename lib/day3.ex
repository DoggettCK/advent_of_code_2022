defmodule Day3 do
  def part_one(input) do
    Enum.reduce(input, 0, &score_string/2)
  end

  def part_two(input) do
    input
    |> Enum.chunk_every(3)
    |> Enum.reduce(0, &score_group/2)
  end

  @alphabet "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
            |> String.graphemes()

  @letter_scores @alphabet
                 |> Enum.with_index(1)
                 |> Enum.into(%{})

  @full_mapset @alphabet |> MapSet.new()

  defp score_string(s, total) do
    s
    |> String.length()
    |> then(&String.split_at(s, div(&1, 2)))
    |> find_duplicate_letter()
    |> then(&Map.get(@letter_scores, &1))
    |> Kernel.+(total)
  end

  defp score_group(strings, total) do
    strings
    |> Enum.reduce(@full_mapset, fn str, mapset ->
      str
      |> string_to_mapset()
      |> MapSet.intersection(mapset)
    end)
    |> mapset_head()
    |> then(&Map.get(@letter_scores, &1))
    |> Kernel.+(total)
  end

  defp string_to_mapset(s) do
    s
    |> String.graphemes()
    |> MapSet.new()
  end

  defp mapset_head(ms) do
    ms
    |> MapSet.to_list()
    |> hd()
  end

  defp find_duplicate_letter({s1, s2}) do
    ms1 = string_to_mapset(s1)
    ms2 = string_to_mapset(s2)

    ms1
    |> MapSet.intersection(ms2)
    |> mapset_head()
  end
end
