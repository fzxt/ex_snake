defmodule ExSnake.Formatter do
  @mid_bar "\u2500"
  @vert_line "\u2502"
  @top_left_corner "\u250c"
  @top_right_corner "\u2510"
  @bottom_left_corner "\u2514"
  @bottom_right_corner "\u2518"

  def draw_game(state) do
    [
      IO.ANSI.clear(),
      IO.ANSI.home(),
      walls(state),
      snake(state),
      food(state),
      IO.ANSI.home()
    ]
    |> IO.write()

    state
  end

  def draw_snake_and_food(state) do
    [snake(state), food(state), IO.ANSI.home()]
    |> IO.write()

    state
  end

  def undraw(%ExSnake.State{alive?: false} = state) do
    [undraw_snake(state), undraw_food(state)]
    |> IO.write()

    state
  end

  def undraw(%ExSnake.State{snake: snake} = state) do
    undraw_cell(Enum.at(snake, 0))
    |> IO.write()

    state
  end

  def vert_lines(height, width) do
    Enum.map(1..height, fn row ->
      Enum.map(1..width, fn col ->
        draw_vert_line(row, col, width)
      end)
    end)
  end

  ## Private

  defp walls(%ExSnake.State{window: window}) do
    [
      top_bar(window.width - 1),
      vert_lines(window.height - 1, window.width - 1),
      bottom_bar(window.width - 1)
    ]
  end

  defp snake(%ExSnake.State{snake: snake}) do
    Enum.map(snake, fn piece ->
      draw_piece(piece, 'x')
    end)
  end

  defp food(%ExSnake.State{food: pos}), do: draw_piece(pos, 'o')

  defp undraw_cell(coord), do: [move_cursor(coord.y, coord.x * 2), '  ']

  defp undraw_snake(%ExSnake.State{snake: snake}) do
    Enum.map(snake, fn piece ->
      undraw_cell(piece)
    end)
  end

  defp undraw_food(%ExSnake.State{food: food}), do: undraw_cell(food)

  defp draw_vert_line(_, 1, _), do: @vert_line
  defp draw_vert_line(_, col, width) when col == width, do: "    #{@vert_line}\n"
  defp draw_vert_line(_, _, _), do: '  '

  defp top_bar(width) do
    [@top_left_corner, String.duplicate("#{@mid_bar}#{@mid_bar}", width), @top_right_corner, "\n"]
  end

  defp bottom_bar(width) do
    [
      @bottom_left_corner,
      String.duplicate("#{@mid_bar}#{@mid_bar}", width),
      @bottom_right_corner,
      "\n"
    ]
  end

  defp move_cursor(row, col), do: IO.ANSI.format(["\e[#{trunc(row)};#{trunc(col)}f"])
  defp draw_piece(coord, symbol), do: [move_cursor(coord.y, coord.x * 2), " #{symbol} "]
end
