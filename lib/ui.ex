defmodule ExSnake.UI do
  use GenServer

  alias ExSnake.Game, as: Game
  alias ExSnake.Formatter, as: Formatter

  @refresh_interval 100

  def start_link, do: GenServer.start_link(__MODULE__, %ExSnake.State{}, name: :ui)

  ## Server callbacks

  def init(state) do
    state
    |> Formatter.draw_game()

    schedule_next_tick()
    {:ok, state}
  end

  def handle_info({:direction, direction}, state) do
    {:noreply, %ExSnake.State{state | direction: direction}}
  end

  def handle_info(:tick, state) do
    state =
      state
      |> Formatter.undraw()
      |> Game.next_state()
      |> Formatter.draw_snake_and_food()

    schedule_next_tick()
    {:noreply, state}
  end

  ## Private

  defp schedule_next_tick, do: Process.send_after(self(), :tick, @refresh_interval)
end
