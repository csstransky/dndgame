defmodule Dndgame.GameServer do
  use GenServer

  alias Dndgame.BackupAgent

  def reg(name) do
    {:via, Registry, {Dndgame.GameReg, name}}
  end

  def start(name) do
    IO.inspect("LOOK HERE FOR THE CHILDREN")
    IO.inspect(name)
    spec = child_spec(name)
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
    #game = Dndgame.BackupAgent.get(name) || Dndgame.Game.World.new_world(name)
    IO.inspect(name)
    IO.inspect("genserver name above")
    GenServer.start_link(__MODULE__, "lol", name: reg(name))
  end

  def start_game(name) do
    GenServer.call(reg(name), {:start_game, name})
  end

  def handle_info(:update_worlds, worldName) do
    world = BackupAgent.get(worldName)
    newWorld = Dndgame.Game.World.call_weather_api(worldName)
    newWorld = Map.put_new(newWorld, :playerPosns, world.playerPosns)
    BackupAgent.put(worldName, newWorld)
    IO.inspect("COME AND GET IT")
    Endpoint.broadcast!("games:#{worldName}", "update_players", %{"world" => newWorld, "playerUpdaterName" => "THE_ALMIGHTY_SERVER"})
    Process.send_after(self(), :update_worlds, 5000)
    {:noreply, worldName}
  end

  def handle_call({:start_world_updater, worldName}, _from, _game) do
    world = BackupAgent.get(worldName)
    newWorld = Dndgame.Game.World.call_weather_api(worldName)
    newWorld = Map.put_new(newWorld, :playerPosns, world.playerPosns)
    BackupAgent.put(worldName, newWorld)
    IO.inspect("START HE BAD BOI")
    Endpoint.broadcast!("games:#{worldName}", "update_players", %{"world" => newWorld, "playerUpdaterName" => "THE_ALMIGHTY_SERVER"})
    Process.send_after(self(), :update_worlds, 5000)
    {:reply, worldName, world}
  end

  def start_world_updater(worldName) do
    IO.inspect("CALLING BOSTON")
    GenServer.call(reg(worldName), {:start_world_updater, worldName})
  end
end
