defmodule ExSnake do
  @moduledoc """
  Entry point. Supervises Game and Input processes.
  """
  use Supervisor

  def start(_type, _args), do: start_link()
  def start_link, do: Supervisor.start_link(__MODULE__, [])

  def init([]) do
    children = [
      worker(ExSnake.Game, []),
      worker(ExSnake.IO.Input, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end

defmodule ExSnake.CLI do
  @moduledoc """
  escript entry point
  """
  def main(_args) do
    :erlang.hibernate(Kernel, :exit, [:killed])
  end
end
