defmodule Day2 do
  def part_one(input) do
    Enum.reduce(input, 0, &calculate_score/2)
  end

  def part_two(input) do
    Enum.reduce(input, 0, &calculate_move/2)
  end

  @loss_score 0
  @draw_score 3
  @win_score 6
  @rock_score 1
  @paper_score 2
  @scissors_score 3

  # Losses
  defp calculate_score("B X", score), do: @rock_score + @loss_score + score
  defp calculate_score("C Y", score), do: @paper_score + @loss_score + score
  defp calculate_score("A Z", score), do: @scissors_score + @loss_score + score
  # Ties
  defp calculate_score("A X", score), do: @rock_score + @draw_score + score
  defp calculate_score("B Y", score), do: @paper_score + @draw_score + score
  defp calculate_score("C Z", score), do: @scissors_score + @draw_score + score
  # Wins
  defp calculate_score("C X", score), do: @rock_score + @win_score + score
  defp calculate_score("A Y", score), do: @paper_score + @win_score + score
  defp calculate_score("B Z", score), do: @scissors_score + @win_score + score

  # Losses
  defp calculate_move("A X", score), do: @scissors_score + @loss_score + score
  defp calculate_move("B X", score), do: @rock_score + @loss_score + score
  defp calculate_move("C X", score), do: @paper_score + @loss_score + score
  # Ties
  defp calculate_move("A Y", score), do: @rock_score + @draw_score + score
  defp calculate_move("B Y", score), do: @paper_score + @draw_score + score
  defp calculate_move("C Y", score), do: @scissors_score + @draw_score + score
  # Wins
  defp calculate_move("A Z", score), do: @paper_score + @win_score + score
  defp calculate_move("B Z", score), do: @scissors_score + @win_score + score
  defp calculate_move("C Z", score), do: @rock_score + @win_score + score
end
