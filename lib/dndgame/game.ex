defmodule Dndgame.Game do
  @starting_x 44
  @starting_y 64
  @boss_x 40
  @boss_y 40
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
        updated_char = Map.put(character, :deathSavefailures, character.deathSaveFailures + 2)
      roll == 20 ->
        updated_char = Map.put(character, :deathSaves, character.deathSaves + 2)
      roll >= 10 ->
        updated_char = Map.put(character, :deathSaves, character.deathSaves + 1)
      roll < 10 ->
        updated_char = Map.put(character, :deathSaveFailures, character.deathSaveFailures + 1)
    end
    # replace the updated character into the battle party
    # might need to put this in each arm of the cond for it to actually return properly
    Map.put(game, :battleParty, List.replace_at(game.battleParty, characterIndex, updated_char))
  end

  def get_character(game) do
    # get character from game state and spell name
    # use a cond to go through and call a specific function for every skill we use
    turn = game.orderIndex
    turnList = game.orderArray
    characterName = List.at(turnList, turn)
    
    # get character by looping through battleParty
    Enum.each game.battleParty, fn char ->
      if char.name == characterName do
        character = char
      end
    end

    character
  end
  

  # use a specific skill on a certain enemy
  def use_skill(game, skillName, targetId) do
    character = get_character(game)

    # cond of all skills, goes to a function that deals with the logic of that skill
    cond do
      skillName == "Short Rest" ->
        short_rest(game, character, targetId)
      skillName == "Double Attack" ->
        double_attack(game, character, targetId)
      skillName == "Rage" ->
        rage(game, character, targetId)
      skillName == "Turn Undead" ->
        turn_undead(game, character, targetId)
      skillName == "Sneak Attack" ->
        sneak_attack(game, character, targetId)
      skillName == "Hide" ->
        hide(game, character, targetId)
    end
  end

  # use a specific skill on an enemy
  def use_spell(game, spellName, targetId) do
    # same as use skill but for spells
    character = get_character(game)

    cond do
      spellName == "Fire Bolt" ->
        fire_bolt(game, character, targetId)
      spellName == "Magic Missle" ->
        magic_missle(game, character, targetId)
      spellName == "Cure Wounds" ->
        cure_wounds(game, character, targetId)
      spellName == "Shield of Faith" ->
        shield_of_faith(game, character, targetId)
    end
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


  # SPELL FUNCTIONS

  

end
