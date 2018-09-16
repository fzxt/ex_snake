defmodule ExSnake.UI.State do
  defstruct snake: [%{x: 10, y: 10}], direction: :right, food: %{x: 14, y: 10}
end
