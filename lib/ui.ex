defmodule ExSnake.UI do
  use GenServer

  @refresh_interval 500

  def start_link do
    GenServer.start_link(__MODULE__, %ExSnake.State{}, name: :window)
  end

  ## Server callbacks

  def init(state) do
    [
      IO.ANSI.clear(),
      IO.ANSI.home(),
      ExSnake.UI.Formatter.draw_walls(state),
      ExSnake.UI.Formatter.draw_snake(state),
      ExSnake.UI.Formatter.draw_food(state),
      ExSnake.UI.Formatter.reset_cursor()
    ]
    |> IO.write()

    schedule_next_tick()

    {:ok, state}
  end

  def undraw_snake_tail(state) do
    state
    |> ExSnake.UI.Formatter.undraw_snake_tail()
    |> IO.write()
  end

  def handle_info(:tick, state) do
    # need to undraw the previous snakes tail
    undraw_snake_tail(state)

    # compute the next state
    state =
      state
      |> ExSnake.Game.move_snake()
      |> ExSnake.Game.move_food()

    # output
    [
      ExSnake.UI.Formatter.draw_snake(state),
      ExSnake.UI.Formatter.draw_food(state),
      ExSnake.UI.Formatter.reset_cursor()
    ]
    |> IO.write()

    schedule_next_tick()
    {:noreply, state}
  end

  ## Private

  defp schedule_next_tick() do
    Process.send_after(self(), :tick, @refresh_interval)
  end
end
