defmodule Dndgame.Game.World do
  @startingX 33
  @startingY 54
  @startingDirection "down"
  @worldLogicOffsetX 5
  @worldLogicOffsetY 6
  @gameMap Dndgame.Game.GameMap.get_map()

  def new_world(worldName) do
    Dndgame.GameServer.start_link(worldName)
    Dndgame.GameServer.start_world_updater(worldName)
    world = call_weather_api(worldName)
    |> Map.put_new(:playerPosns, [])
  end

  def call_weather_api(worldName) do
    IO.inspect("WEATHER API CALL")
    IO.inspect(worldName)
    cond do
      worldName == "boston" ->
        Darkskyx.current(42.361145, -71.057083)
        |> Map.put_new(:timezone, -4)
      worldName == "death-valley" ->
        Darkskyx.current(36.4622, -116.867)
        |> Map.put_new(:timezone, -7)
      worldName == "greenland" ->
        Darkskyx.current(69.869007, -41.954900)
        |> Map.put_new(:timezone, -2)
      worldName == "sydney" ->
        Darkskyx.current(-33.865143, 151.209900)
        |> Map.put_new(:timezone, +11)
      worldName == "dallol" ->
        Darkskyx.current(14.236499054, 40.289665508)
        |> Map.put_new(:timezone, +3)
      worldName == "everest" ->
        Darkskyx.current(27.986065, 86.922623)
        |> Map.put_new(:timezone, +5)
      true ->
        %{error: "World not found"}
    end
  end

  def is_walkable?(x, y) do
    Enum.at(Enum.at(@gameMap, y - @worldLogicOffsetY), x - @worldLogicOffsetX) == 1
  end

  def join_world(world, playerName) do
    nameList = Enum.map(world.playerPosns, fn playerPosn -> playerPosn.name end)
    if Enum.member?(nameList, playerName) do
      world
    else
      newPlayer = init_new_player(playerName)
      world
      |> Map.put(:playerPosns, world.playerPosns ++ [newPlayer])
    end
  end

  def init_new_player(playerName) do
    %{
      name: playerName,
      x: @startingX,
      y: @startingY,
      direction: @startingDirection,
    }
  end
end
