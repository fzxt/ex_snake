defmodule ExSnake.Game do
  @moduledoc """
  Game (controller) process. Coordinates the Formatter (draws the game)
  and Core (for computing the next state) modules. Also handles updating
  state with direction from ExSnake.IO.Input.
  """
  use GenServer

  alias ExSnake.Core, as: Core
  alias ExSnake.IO.Formatter, as: Formatter

  @refresh_interval 100

  def start_link, do: GenServer.start_link(__MODULE__, %ExSnake.State{}, name: :game)

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
      |> Core.next_state()
      |> Formatter.draw_snake_and_food()

    schedule_next_tick()
    {:noreply, state}
  end

  ## Private

  defp schedule_next_tick, do: Process.send_after(self(), :tick, @refresh_interval)
end
