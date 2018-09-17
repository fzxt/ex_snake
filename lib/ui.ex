defmodule ExSnake.UI do
  use GenServer

  alias ExSnake.UI.Formatter, as: Formatter

  @refresh_interval 100

  def start_link do
    GenServer.start_link(__MODULE__, %ExSnake.State{}, name: :ui)
  end

  ## Server callbacks

  def init(state) do
    state
    |> Formatter.draw_game()
    |> IO.write()

    schedule_next_tick()

    {:ok, state}
  end

  def handle_info({:direction, direction}, state) do
    {:noreply, %ExSnake.State{state | direction: direction}}
  end

  def handle_info(:tick, %ExSnake.State{alive?: false} = state) do
    state
    |> Formatter.undraw_snake_and_food()
    |> IO.write()

    state = %ExSnake.State{}

    state
    |> Formatter.draw_snake_and_food()
    |> IO.write()

    schedule_next_tick()
    {:noreply, state}
  end

  def handle_info(:tick, %ExSnake.State{alive?: true} = state) do
    state
    |> Formatter.undraw_snake_tail()
    |> IO.write()

    state =
      state
      |> ExSnake.Game.move_snake()
      |> ExSnake.Game.move_food()

    state
    |> Formatter.draw_snake_and_food()
    |> IO.write()

    schedule_next_tick()
    {:noreply, state}
  end

  ## Private

  defp schedule_next_tick() do
    Process.send_after(self(), :tick, @refresh_interval)
  end
end
