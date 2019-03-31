defmodule Dndgame.GameServer do

  def reg(name) do
    {:via, Registry, {Dndgame.GameReg, name}}
  end

  def start(name) do
    game = Dndgame.BackupAgent.get(name) || Dndgame.Game.new()
    IO.inspect(name)
    IO.inspect("genserver name above")
    GenServer.start_link(__Module__, game, name: reg(name))
  end

  def init(init_arg)  do
    {:ok, init_arg}
  end

  def start_game(name) do
    GenServer.call(reg(name), {:start_game, name})
    
  end

end
