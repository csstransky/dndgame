defmodule Dndgame.GameServer do

  def reg(name) do
    {:via, Registry, {Dndgame.GameReg, name}}
  end

  def start(name) do
    spec = Dndgame.child_spec(name)
    Dndgame.GameSup.start_child(spec)
  end

  # This function is added simply to make the compiler happy, because it
  # appearently really needs a "child_spec" function
  def child_spec(name) do
    spec = %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [name]},
      restart: :permanent,
      type: :worker,
    }
  end

  # Another mandatory function for the compiler
  def init(init_arg) do
    {:ok, init_arg}
  end

  def start_link(name) do
    game = Dndgame.BackupAgent.get(name) || Dndgame.Game.new()
    IO.inspect(name)
    IO.inspect("genserver name above")
    GenServer.start_link(__MODULE__, game, name: reg(name))
  end

  def start_game(name) do
    GenServer.call(reg(name), {:start_game, name})

  end

end
