defmodule ExSnake.State do
  @moduledoc """
  Holds the state of the game and UI
  """
  defstruct snake: [%{x: 10, y: 10}],
            direction: :right,
            food: %{x: 14, y: 10},
            window: %{height: 30, width: 50},
            alive?: true
end
