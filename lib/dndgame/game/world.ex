defmodule Dndgame.Game.World do
  @startingX 49
  @startingY 50
  @startingDirection "down"
  @worldLogicOffsetX 15
  @worldLogicOffsetY 12
  @gameMap Dndgame.Game.GameMap.get_map()

  def new_world(worldName) do
    weatherInfo = call_weather_api(worldName)
    |> Map.put_new(:playerPosns, [])
    |> Map.put_new(:playerCount, 0)
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
    # need to offset x by 15, y 12
    offset_x = @worldLogicOffsetX
    offset_y = @worldLogicOffsetY
    Enum.at(Enum.at(@gameMap, offset_y), offset_x)
  end

  def join_world(world, playerName) do
    nameList = Enum.map(world.playerPosns, fn playerPosn -> playerPosn.name end)
    if Enum.member?(nameList, playerName) do
      world
    else
      newPlayer = init_new_player(playerName)
      world
      |> Map.put(:playerPosns, world.playerPosns ++ [newPlayer])
      |> Map.put(:playerCount, world.playerCount + 1)
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
