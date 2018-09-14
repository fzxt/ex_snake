defmodule ExSnake.Grid.Formatter do
    def draw_grid(rows, cols) do
        draw_borders(rows, trunc(cols / 2))
    end

    def draw_borders(height, width) do
        Enum.map(1..height, fn row->
            Enum.map(1..width, fn col->
                draw_border(row, col, height, width)
            end)
        end)
    end

    defp move_cursor(row, col), do: IO.ANSI.format ["\e[#{trunc(row)};#{trunc(col)}f"]
    # first row, any column
    defp draw_border(1, col, _, _),   do: draw_border_cell(1, col)
    # first column, any row
    defp draw_border(row, 1, _, _),   do: draw_border_cell(row, 1)
    # last row or last column
    defp draw_border(row, col, height, width) when row == height or col == width,  do: draw_border_cell(row, col)
    # everything else
    defp draw_border(_, _, _, _),     do: ''

    defp draw_border_cell(row, col) do
        [move_cursor(row, col * 2), ' - ']
    end
end

