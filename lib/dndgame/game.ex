defmodule Dndgame.Game do
  @starting_x 44
  @starting_y 64
  @boss_x 40
  @boss_y 40

  def new_world(worldName) do
    weatherInfo = getWeatherInfo(worldName)
    |> Map.put_new(:playerPosns, [])
    |> Map.put_new(:playerCount, 0)
  end

  def getWeatherInfo(worldName) do
    cond do
      worldName == "death-valley" ->
        IO.inspect("FEEL THE BURNING OF THE DEATH VALLEY, PLEASE NOTICE")
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
      true -> # boston
        IO.inspect("IN BOSTON?")
        Darkskyx.current(42.361145, -71.057083)
        |> Map.put_new(:timezone, -4)
    end
  end

  def new(party_id_1, party_id_2, party_id_3) do
    %{
        # TODO: Fill it with this:
        playerPosn: %{
          x: @starting_x,
          y: @starting_y,
          direction: 0 # 0 up, 1 right, 2 down, 3 left
        },
        characterPosns: [], # TODO filled with posns from other characters
        characterIndex: 0,
        battleParty: [],
        staticParty: [], # TODO: fill this
        monsters: [], # fills up when character encounters monsters
        boss: %{
          x: @boss_x,
          y: @boss_y,
        },
        # We'll have to grab this from the server state

        orderArray: [], # fills up with strings of whose turn it is
        orderIndex: 0, # who's turn it is

        isLevelUp: [0,0,0], # flag to show a level screen or not
        isBossDead: "", # name of person who killed boss
        isGameOver: false, # flag to show a gameover screen

        currentMenu: "main", # main, skill, spell, monsterSelect, deathSaves
        menuIndex: 0,
        battleAction: "",
    }
  end

  def client_view(game) do
    # TODO: fix this up in the future
    game
  end

  # takes in something like "1d6" and gives the random die roll
  def roll_dice(dieString) do
    dieString = String.downcase(dieString)
    [numOfDice, numOfSides] = String.split(dieString, "d")
    {numOfDice, _} = Integer.parse(numOfDice)
    {numOfSides, _} = Integer.parse(numOfSides)
    maxRoll = numOfDice * numOfSides
    Enum.random(numOfDice..maxRoll)
  end


  def walk(game, direction) do
    # 0 = up, 1 = right, 2 = down, 3 = left
    # TODO: add square check function

    player_posn = game.playerPosn
    player_x = game.playerPosn.x
    player_y = game.playerPosn.y

    cond do
      direction == 0 ->
        #check if the above square is walkable
        if is_walkable?(player_x, player_y - 1) do
          # update y in the posn and update the posn in game
          Map.put(game, :playerPosn, Map.put(player_posn, :y, player_y - 1))
        end
      direction == 1 ->
        #check if the right square is walkable
        if is_walkable?(player_x + 1, player_y) do
          # update y in the posn and update the posn in game
          Map.put(game, :playerPosn, Map.put(player_posn, :x, player_x + 1))
        end
      direction == 2 ->
        #check if the down square is walkable
        if is_walkable?(player_x, player_y + 1) do
          # update y in the posn and update the posn in game
          Map.put(game, :playerPosn, Map.put(player_posn, :y, player_y + 1))
        end
      direction == 3 ->
        #check if the right square is walkable
        if is_walkable?(player_x - 1, player_y) do
          # update y in the posn and update the posn in game
          Map.put(game, :playerPosn, Map.put(player_posn, :x, player_x - 1))
        end
    end
  end

  def is_walkable?(x, y) do
    true
  end

  def run(game) do
    # TODO: add rolling to decide on running
    game
    |> Map.put(:battle_party, [])
    |> Map.put(:monsters, [])
  end

  # blank for now, will: clear battleParty, monsters, update xp,
  def end_battle(game) do
    # TODO get this workoing
  end

  # roll a death save for character
  def death_save(game, characterIndex) do
    # get the character
    character = List.at(game.battleParty, characterIndex)
    # roll the d20 for save failure
    roll = roll_dice("1d20")
    # if greater than 10, update save rolls, if < then update failures
    updated_char = %{}
    cond do
      roll == 1 ->
        updated_char = Map.put(character, :deathSaves, character.deathSaveFailures + 2)
      roll == 20 ->
        updated_char = Map.put(character, :deathSaves, character.deathSaves + 2)
      roll >= 10 ->
        updated_char = Map.put(character, :deathSaves, character.deathSaves + 1)
      roll < 10 ->
        updated_char = Map.put(character, :deathSaves, character.deathSaveFailures + 1)
    end
    # replace the updated character into the battle party
    Map.put(game, :battleParty, List.replace_at(game.battleParty, characterIndex, updated_char))
  end

  # use a specific skill on a certain enemy
  def use_skill(game, skillName, enemyId) do
    # get character from game state and spell name
    # use a cond to go through and call a specific function for every skill we use
  end

  # use a specific skill on an enemy
  def use_spell(game, spellName, enemyId) do
    # same as use skill but for spells
  end

  # use base attack on a certain enemy
  def attack(game, enemyId) do
    # get current character from array and index
    # get attack of character and apply it to the enemy
    # return game
  end

  def enemy_attack do
    # get current enemy
  end

end
