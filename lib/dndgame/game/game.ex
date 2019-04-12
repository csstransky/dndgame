defmodule Dndgame.Game do
  alias Dndgame.Characters
  alias Dndgame.Game.World
  require Protocol

  @boss_x 29
  @boss_y 8
  @max_steps_for_encounter 35
  @d20 "1d20"
  @duskTime ~T[18:00:00.0]
  @dawnTime ~T[06:00:00.0]
  @nightHotTemp 80
  @nightColdTemp 20
  @dayHotTemp 90
  @dayColdTemp 30
  @bossTopLeftX 29
  @bossTopLeftY 8
  @bossName "Young Green Dragon"
  @expLossPercent 0.80 # the amount of exp you keep on loss, so you lose 20%

  def new_game(world) do
    # Still need to add playerIndex by joining the world
    %{
        battleParty: [],
        staticParty: [], # Will be added onto later
        monsters: [], # fills up when character encounters monsters
        boss: %{
          posns: [%{x: @bossTopLeftX, y: @bossTopLeftY},
                  %{x: @bossTopLeftX + 1, y: @bossTopLeftY},
                  %{x: @bossTopLeftX, y: @bossTopLeftY + 1},
                  %{x: @bossTopLeftX + 1, y: @bossTopLeftY + 1}],
          x: @bossTopLeftX,
          y: @bossTopLeftY,
        },

        orderArray: [], # fills up with strings of whose turn it is
        orderIndex: 0, # who's turn it is

        isBossDead: "", # name of person who killed boss
        battleOverArray: [],

        currentMenu: "main", # main, skill, spell, monsterSelect, deathSaves
        battleAction: "",
        steps: 0,
    }
  end

  def create_party(game, party_id_1, party_id_2, party_id_3) do
    characterListItem1 = create_character_list_item(party_id_1)
    characterListItem2 = create_character_list_item(party_id_2)
    characterListItem3 = create_character_list_item(party_id_3)
    newParty = [characterListItem1] ++ [characterListItem2] ++ [characterListItem3]
    |> Enum.filter(& !is_nil(&1))
    game
    |> Map.put(:staticParty, newParty)
  end

  def create_character_list_item(party_id) do
    if party_id == "" do
      nil
    else
      character = Dndgame.Characters.get_character!(party_id)
      character = character
      |> Map.put(:weapon, Dndgame.Weapons.get_weapon!(character.weapon_id))
      |> Map.put(:class, Dndgame.Classes.get_class!(character.class_id))
      |> Map.put(:hp, Characters.get_hp(character))
      |> Map.put(:ac, Characters.get_ac(character))
      |> Map.put(:mp, Characters.get_mp(character))
      |> Map.put(:sp, Characters.get_sp(character))
      |> Map.put(:level, Characters.get_level(character))
      |> Map.put(:initiative, Characters.get_initiative(character))
    end
  end

  def update_game_world(game, world, playerName) do
    playerIndex = Enum.find_index(world.playerPosns,
      fn playerPosn -> playerPosn.name == playerName end)
    IO.inspect("CHECK CORRECT INDEX")
    IO.inspect(playerName)
    IO.inspect(playerIndex)
    game
    |> Map.put(:playerIndex, playerIndex)
    |> Map.put(:playerPosns, world.playerPosns)
    |> Map.put(:windSpeed, Map.get(world, "windSpeed"))
    |> Map.put(:temperature, Map.get(world, "apparentTemperature"))
    |> Map.put(:visibility, Map.get(world, "visibility"))
    |> Map.put(:timezone, world.timezone)
  end

  def client_view(game) do
    gameView = %{
      playerPosns: game.playerPosns,
      playerIndex: game.playerIndex,
      weather: %{
        wind: game.windSpeed, # in MPH
        temperature: game.temperature, # in F
        visibility: game.visibility,
      },

      timezone: game.timezone,
      monsters: game.monsters, # fills up when character encounters monsters
      boss: %{
        x: game.boss.x,
        y: game.boss.y,
      },
      steps: game.steps,

      orderArray: game.orderArray, # fills up with strings of whose turn it is
      orderIndex: game.orderIndex, # who's turn it is

      battleOverArray: game.battleOverArray,
      isBossDead: game.isBossDead, # name of person who killed boss

      currentMenu: game.currentMenu, # main, skill, spell, monsterSelect, deathSaves
      battleAction: game.battleAction,

      mainMenuOptions: ["attack", "skills", "spells", "run"],
      mainMenuCurrentSelection: 0,
      subMenuOptions: [],
      subMenuCurrentSelection: 0,
      monsterCurrentSelection: 0,
      buildMenuPath: [],
      menuIndex: 0,
    }
    if game.monsters == [] && game.battleOverArray == [] do
      staticParty = Enum.map(game.staticParty, fn character -> character_view(character) end)
      Map.put(gameView, :party, staticParty)
    else
      battleParty = Enum.map(game.battleParty, fn character -> character_view(character) end)
      monsters = Enum.map(game.monsters, fn monster -> monster_view(monster) end)
      gameView
      |> Map.put(:party, battleParty)
      |> Map.put(:monsters, monsters)
    end
  end

  def monster_view(monster) do
    %{
      ac: monster.ac,
      desc: monster.desc,
      hp: monster.hp,
      name: monster.name,
      type: monster.type,
      element: monster.element,
      str: monster.str,
      dex: monster.dex,
      int: monster.int,
      con: monster.con,
      cha: monster.cha,
      wis: monster.wis,
      size: monster.size,
      attacks: Enum.map(monster.attacks, fn attack -> attack_view(attack) end),
    }
  end

  def attack_view(attack) do
    %{
      attackBonus: attack.attack_bonus,
      damageBonus: attack.damage_bonus,
      damageDice: attack.damage_dice,
      desc: attack.desc,
      name: attack.name,
      target: attack.target,
      type: attack.type,
    }
  end

  def character_view(character) do
    %{
      name: character.name,
      hp: character.hp,
      ac: character.ac,
      mp: character.mp,
      sp: character.sp,

      level: character.level,
      exp: character.exp,
      initiative: character.initiative,

      str: character.str,
      dex: character.dex,
      int: character.int,
      con: character.con,
      wis: character.wis,
      cha: character.cha,

      weapon: weapon_view(character.weapon),
      armor: armor_view(character.armor),
      class: class_view(character.class),
      race: race_view(character.race),
      spells: Enum.map(character.class.spells, fn spell -> spell_view(spell) end),
      skills: Enum.map(character.class.skills, fn skill -> skill_view(skill) end),
    }
  end

  def weapon_view(weapon) do
    %{
      name: weapon.name,
      desc: weapon.desc,
      category: weapon.weapon_category,
      attackName: weapon.attack.name,
      damageDie: weapon.attack.damage_dice,
      target: weapon.attack.target,
      type: weapon.attack.type,
    }
  end

  def armor_view(armor) do
    %{
      name: armor.name,
      desc: armor.desc,
      category: armor.armor_category,
      base: armor.base,
      stealthDisadvantage: armor.stealth_disadvantage,
      strMinimum: armor.str_minimum,
      maxDexBonus: armor.max_dex_bonus,
    }
  end

  def class_view(class) do
    %{
      name: class.name,
      desc: class.desc,
      abilityModifier: class.ability_modifier,
      hitDie: class.hit_die,
      saves: class.save_array,
      proficiencies: class.prof_array,
      weaponProficiencies: class.weapon_prof_array,
      armorProficiencies: class.armor_prof_array,
    }
  end

  def race_view(race) do
    %{
      name: race.name,
      desc: race.desc,
      size: race.size,
      strBonus: race.str_bonus,
      dexBonus: race.dex_bonus,
      intBonus: race.int_bonus,
      conBonus: race.con_bonus,
      wisBonus: race.wis_bonus,
      chaBonus: race.cha_bonus,
      saves: race.save_array,
      proficiencies: race.prof_array,
      weaponProficiencies: race.weapon_prof_array,
      armorProficiencies: race.armor_prof_array,
    }
  end

  def skill_view(skill) do
    %{
      name: skill.name,
      desc: skill.desc,
      spCost: skill.sp_cost,
      levelReq: skill.level_req,
      dice: skill.dice,
      diceBonus: skill.dice_bonus,
      buffState: skill.buff_stat,
      target: skill.target,
      type: skill.type,
    }
  end

  def spell_view(spell) do
    %{
      buffState: spell.buff_stat,
      name: spell.name,
      desc: spell.desc,
      dice: spell.dice,
      diceBonus: spell.dice_bonus,
      levelReq: spell.level_req,
      mpCost: spell.mp_cost,
      target: spell.target,
      type: spell.type,
    }
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

  # sets the players position to whatever is sent in the arguments
  def update_player_posn(game, x, y, direction) do
    newPosn = Enum.at(game.playerPosns, game.playerIndex)
    |> Map.put(:y, y)
    |> Map.put(:x, x)
    |> Map.put(:direction, direction)
    newPlayerPosns = List.replace_at(game.playerPosns, game.playerIndex, newPosn)
    game
    |> Map.put(:playerPosns, newPlayerPosns)
  end

  # Move the player in a specific direction if that is a valid option, otherwise
  # just return the current game state
  def walk(game, direction) do
    # 0 = up, 1 = right, 2 = down, 3 = left

    playerPosn = Enum.at(game.playerPosns, game.playerIndex)
    playerX = playerPosn.x
    playerY = playerPosn.y

    cond do
      direction == "up" ->
        #check if the above square is walkable
        if World.is_walkable?(playerX, playerY - 1) do
          # update y in the posn and the direction
          if check_boss_encounter(game, playerX, playerY - 1) do
            IO.puts("here")
            game
            |> update_player_posn(playerX, playerY - 1, direction)
            |> Map.put(:steps, game.steps + 1)
            |> boss_encounter
            |> Map.put(:battleOverArray, [])
          else
            game
            |> update_player_posn(playerX, playerY - 1, direction)
            |> Map.put(:steps, game.steps + 1)
            |> random_encounter
            |> Map.put(:battleOverArray, [])
          end
        else
          # just update the direction
          update_player_posn(game, playerX, playerY, direction)
        end
      direction == "right" ->
        #check if the right square is walkable
        if World.is_walkable?(playerX + 1, playerY) do
          # update y in the posn and update the posn in game
          game
          |> update_player_posn(playerX + 1, playerY, direction)
          |> Map.put(:steps, game.steps + 1)
          |> random_encounter
          |> Map.put(:battleOverArray, [])
        else
          update_player_posn(game, playerX, playerY, direction)
        end
      direction == "down" ->
        #check if the down square is walkable
        if World.is_walkable?(playerX, playerY + 1) do
          # update y in the posn and update the posn in game
          update_player_posn(game, playerX, playerY + 1, direction)
          |> Map.put(:steps, game.steps + 1)
          |> random_encounter
          |> Map.put(:battleOverArray, [])
        else
          update_player_posn(game, playerX, playerY, direction)
        end
      direction == "left" ->
        #check if the right square is walkable
        if World.is_walkable?(playerX - 1, playerY) do
          # update y in the posn and update the posn in game
          update_player_posn(game, playerX - 1, playerY, direction)
          |> Map.put(:steps, game.steps + 1)
          |> random_encounter
          |> Map.put(:battleOverArray, [])
        else
          update_player_posn(game, playerX, playerY, direction)
        end
      true ->
        %{
          error: "Could not find direction",
          direction: direction,
        }
    end
  end

  def add_environment_monsters(game) do
    currTime = Time.utc_now()
    worldTime = Time.add(currTime, game.timezone*60*60, :second)
    if @dawnTime < worldTime && worldTime < @duskTime do
      cond do
        game.temperature > @dayHotTemp ->
          monster = Dndgame.Monsters.get_monster_by_name("Fire Goblin")
          game
          |> add_random_monsters(monster)
        game.temperature < @dayColdTemp ->
          monster = Dndgame.Monsters.get_monster_by_name("Ice Goblin")
          game
          |> add_random_monsters(monster)
        true ->
          monster = Dndgame.Monsters.get_monster_by_name("Goblin")
          game
          |> add_random_monsters(monster)
      end
    else
      cond do
        game.temperature > @nightHotTemp ->
          monster = Dndgame.Monsters.get_monster_by_name("Fire Zombie")
          game
          |> add_random_monsters(monster)
        game.temperature < @nightColdTemp ->
          monster = Dndgame.Monsters.get_monster_by_name("Ice Zombie")
          game
          |> add_random_monsters(monster)
        true ->
          monster = Dndgame.Monsters.get_monster_by_name("Zombie")
          game
          |> add_random_monsters(monster)
      end
    end
  end

  def add_random_monsters(game, monster) do
    monsterList = List.duplicate(monster, :rand.uniform(3))
    game
    |> Map.put(:monsters, monsterList)
  end

  def start_battle(game) do
    game
    |> add_environment_monsters
    |> add_order_array
    |> Map.put(:battleParty, game.staticParty)
    |> Map.put(:currentMenu, "main")
    |> set_monster_encounter_battle_action()
    |> Map.put(:steps, 0)
  end

  def set_monster_encounter_battle_action(game) do
    cond do

      length(game.monsters) > 1 ->
        Map.put(game, :battleAction, "A group of monsters has appeared!")
      Enum.at(game.monsters, 0).name == @bossName ->
        Map.put(game, :battleAction, "You have challenged the " <> @bossName <> "!")
      true ->
        Map.put(game, :battleAction, "A monster has appeared!")
    end
  end

  def add_order_array(game) do
    # map the characters in the party to a list of maps of names and rolls
    characterRolls = Enum.map(Enum.with_index(game.staticParty), fn {char, index} ->
      %{name: "character#{index}", init: roll_dice(@d20) + Dndgame.Characters.get_initiative(char)} end)

    # map the monsters in the array to monster# and rolls
    monsterRolls = Enum.map(Enum.with_index(game.monsters), fn {monster, index} ->
      %{name: "monster#{index}", init: roll_dice(@d20) + Dndgame.Characters.get_initiative(monster)} end)

    # combine the 2 lists of maps
    allRolls = characterRolls ++ monsterRolls

    # sort using the initiative so that the highest comes first
    sortedOrderArray = Enum.sort(allRolls, fn (x, y) -> x.init > y.init end)
    |> Enum.map(fn roll -> roll.name end)
    game
    |> Map.put(:orderArray, sortedOrderArray)
    |> Map.put(:orderIndex, 0)

  end

  def random_encounter(game) do
    encounterRoll = roll_dice(@d20)
    IO.inspect("CHECKING ENCOUTNER")
    IO.inspect(encounterRoll)
    IO.inspect(game.steps)
    if encounterRoll + game.steps >= @max_steps_for_encounter do
      game
      |> start_battle
    else
      IO.inspect("NO ENOUCNTER")
      game
    end
  end

  def boss_encounter(game) do
  IO.inspect(Dndgame.Monsters.get_monster_by_name(@bossName))
     battleArray = game.staticParty

    game
    |> Map.put(:monsters, [Dndgame.Monsters.get_monster_by_name(@bossName)])
    |> add_order_array
    |> Map.put(:battleParty, battleArray)
    |> Map.put(:currentMenu, "main")
    |> Map.put(:steps, 0)
    |> set_monster_encounter_battle_action()
  end

  def check_boss_encounter(game, x, y) do
    IO.puts("in check boss encounter")
    bossPosns = game.boss.posns
    IO.inspect(bossPosns)
    IO.puts(x)
    IO.puts(y)
    Enum.member?(bossPosns, %{x: x, y: y})
  end

  def remove_dead_monsters(game) do
    # map monsters, if 0 health map to xp, if > 0 map to 0 xp
    # foldr the list of xp into one xp to add to all  Characters
    # remove all monsters with below 0 health , update everything and return

    # make a map of xp gained from any dead monsters
    xpMap = Enum.map(game.monsters, fn monster ->
      if monster.hp <= 0 do
        monster.exp
      else
        0
      end
    end)
    IO.inspect(xpMap)

    monsterLength = length(game.monsters)
    removeList = Enum.map(game.monsters, fn monster ->
      if monster.hp <= 0 do
        monsterLength = monsterLength - 1
        "monster#{monsterLength}"
      else
        ""
      end
    end)

    newOrderArray = Enum.filter(game.orderArray, fn orderString ->
      !(Enum.member?(removeList, orderString)) end)
    # fold the list into 1 total number of xp to gain
    totalXP = List.foldr(xpMap, 0, fn x, acc -> x + acc end)
    # update the characters with their xp
    updatedCharacters = Enum.map(game.staticParty, fn char ->
                                  Map.put(char, :exp, char.exp + totalXP) end)
    # filter any dead monsters out of the list
    removedDeadMonsters = Enum.filter(game.monsters, fn mon -> mon.hp > 0 end)
    if length(removedDeadMonsters) <= 0 do
      game
      |> Map.put(:staticParty, updatedCharacters)
      |> Map.put(:monsters, removedDeadMonsters)
      |> Map.put(:battleAction, "")
      |> set_battle_win_string
      |> update_database_character_exp("win")
    else
      game
      |> Map.put(:monsters, removedDeadMonsters)
      |> Map.put(:staticParty, updatedCharacters)
      |> Map.put(:orderArray, newOrderArray)
    end
  end

  def set_battle_win_string(game) do
    expArray = Enum.map(Enum.with_index(game.staticParty),
      fn {character, index} ->
        originalExp = Enum.at(game.battleParty, index).exp
        newExp = character.exp
        expGain = newExp - originalExp

        currLevel = character.level
        newLevel = Dndgame.Characters.get_level(character)
        if currLevel < newLevel do
          "#{character.name} has gained #{expGain} experience, and increased to level #{newLevel}!"
        else
          "#{character.name} has gained #{expGain} experience!"
        end
      end)
    battleOverArray = ["You have won!"] ++ expArray
    game
    |> Map.put(:battleOverArray, battleOverArray)
    |> Map.put(:monster, [])
  end

  def check_battle_lost(game) do
    if Enum.all?(game.battleParty, fn char -> char.hp <= 0 end) do
      expArray = Enum.map(game.staticParty,
        fn character ->
          originalExp = character.exp
          newExp = ceil(character.exp * @expLossPercent)
          expLoss = originalExp - newExp

          currLevel = character.level
          newLevel = Dndgame.Characters.get_level(character)
          if currLevel > newLevel do
            "#{character.name} has lost #{expLoss} experience, and decreased to level #{newLevel}..."
          else
            "#{character.name} has lost #{expLoss} experience."
          end
        end)
      battleOverArray = ["You have lost..."] ++ expArray
      game
      |> Map.put(:battleOverArray, battleOverArray)
      |> Map.put(:monsters, [])
      |> Map.put(:battleAction, "")
      |> update_database_character_exp("lose")
    else
      game
    end
  end

  def update_database_character_exp(game, gameConditionString) do
    cond do
      gameConditionString == "win" ->
        Enum.map(game.staticParty, fn character ->
          Dndgame.Characters.get_character(character.id)
          |> Ecto.Changeset.change(%{exp: character.exp})
          |> Dndgame.Repo.update()

          currLevel = character.level
          newLevel = Dndgame.Characters.get_level(character)
          if currLevel < newLevel do
            create_character_list_item(character.id)
          else
            character
          end
        end)
        game
      gameConditionString == "lose" || gameConditionString == "loss" ->
        Enum.map(game.staticParty, fn character ->
          # You will lose 20% of your exp if all your members die
          Dndgame.Characters.get_character(character.id)
          |> Ecto.Changeset.change(%{exp: ceil(character.exp * @expLossPercent)})
          |> Dndgame.Repo.update()

          currLevel = character.level
          newLevel = Dndgame.Characters.get_level(character)
          if currLevel > newLevel do
            create_character_list_item(character.id)
          else
            character = Map.put(character, :exp, ceil(character.exp * @expLossPercent))
          end
        end)
        game
      true ->
        "Did not recognize your gameConditionString string: " <> gameConditionString
    end
  end

  # Run from a battle
  def run(game) do
    # dexterity check for each player & monster, compare largest of each
    maxPartyDexRoll = Enum.max(Enum.map(game.battleParty,
      fn char -> roll_dice(@d20) + Dndgame.Characters.get_stat_modifier(char.dex) end))
    maxMonstersDexRoll = Enum.max(Enum.map(game.monsters,
      fn monster -> roll_dice(@d20) + Dndgame.Characters.get_stat_modifier(monster.dex) end))
    if maxPartyDexRoll >= maxMonstersDexRoll do
      game
      |> Map.put(:battle_party, [])
      |> Map.put(:monsters, [])
      |> Map.put(:battleOverArray, ["You successfully ran away!"])
      |> Map.put(:battleAction, "")
    else
      game
      |> Map.put(:battleAction, "You tried to run away, but failed!")
      |> incrementOrderIndex
    end
  end

  # blank for now, will: clear battleParty, monsters, update xp,
  def end_battle(game) do
    Enum.each(game.staticParty, fn char ->
      dbchar = Dndgame.Characters.get_character_by_name(char.name)
      attrs = %{exp: char.exp}
      Dndgame.Characters.update_character(dbchar, attrs)
    end)
  end

  # roll a death save for character
  def death_save(game) do
    # get the character
    character = List.at(game.battleParty, game.playerIndex)
    # roll the d20 for save failure
    roll = roll_dice("1d20")
    # if greater than 10, update save rolls, if < then update failures
    cond do
      roll == 1 ->
        updated_char = Map.put(character, :deathSavefailures, character.deathSaveFailures + 2)
        update_battle_party(game, updated_char)
      roll == 20 ->
        updated_char = Map.put(character, :deathSaves, character.deathSaves + 2)
        update_battle_party(game, updated_char)
      roll >= 10 ->
        updated_char = Map.put(character, :deathSaves, character.deathSaves + 1)
        update_battle_party(game, updated_char)
      roll < 10 ->
        updated_char = Map.put(character, :deathSaveFailures, character.deathSaveFailures + 1)
        update_battle_party(game, updated_char)
    end
  end

  # get the index of the character whose turn it is
  def get_character_index(game) do
    charString = Enum.at(game.orderArray, game.orderIndex)
    charIndexString = String.replace(charString, ~r/[^\d]/, "")
    {charIndex, _} = Integer.parse(charIndexString)
    charIndex
  end

  # updates the given newChar into the battleParty for the game
  def update_battle_party(game, newChar) do
    idx = get_character_index(game)
    # replace the character in the battle party and update the game
    newBattleParty = List.replace_at(game.battleParty, idx, newChar)

    game
    |> Map.put(:battleParty, newBattleParty)
  end

  # use a specific skill on a certain enemy
  def use_skill(game, skillId, targetId) do
    charIndex = get_character_index(game)
    character = Enum.at(game.battleParty, charIndex)
    skillName = Enum.at(character.class.skills, skillId)
    skill = Enum.at(character.class.skills, skillId)
    target = get_ability_target(game, skill, targetId)

    if target do
      if character.sp <= 0 do
        game
        |> Map.put(:currentMenu, "main")
      else
        game
        |> use_specific_skill(skill.name, targetId)
        |> remove_dead_monsters
        |> incrementOrderIndex
        |> Map.put(:currentMenu, "main")
      end
    else
      game
    end
  end

    def use_specific_skill(game, skillName, targetId) do
      # cond of all skills, goes to a function that deals with the logic of that skill
      cond do
        skillName == "Short Rest" ->
          Dndgame.Game.Skills.short_rest(game)
        skillName == "Double Attack" ->
          Dndgame.Game.Skills.double_attack(game, targetId)
        skillName == "Rage" ->
          Dndgame.Game.Skills.rage(game)
        skillName == "Turn Undead" ->
          Dndgame.Game.Skills.turn_undead(game, targetId)
        skillName == "Sneak Attack" ->
          Dndgame.Game.Skills.sneak_attack(game, targetId)
        skillName == "Hide" ->
          Dndgame.Game.Skills.hide(game)
      end
    end

  # use a specific skill on an enemy
  def use_spell(game, spellId, targetId) do
    # same as use skill but for spells
    charIndex = get_character_index(game)
    character = Enum.at(game.battleParty, charIndex)
    spell = Enum.at(character.class.spells, spellId)
    target = get_ability_target(game, spell, targetId)

    if target do
      if character.mp <= 0 do
        game
        |> Map.put(:currentMenu, "main")
      else
        game
        |> use_specific_spell(spell.name, targetId)
        |> remove_dead_monsters
        |> incrementOrderIndex
        |> Map.put(:currentMenu, "main")
      end
    else
      game
    end

  end

  def use_specific_spell(game, spellName, targetId) do
      cond do
        spellName == "Fire Bolt" ->
          Dndgame.Game.Spells.fire_bolt(game, targetId)
        spellName == "Ray of Frost" ->
          Dndgame.Game.Spells.ray_of_frost(game, targetId)
        spellName == "Magic Missle" ->
          Dndgame.Game.Spells.magic_missle(game)
        spellName == "Cure Wounds" ->
          Dndgame.Game.Spells.cure_wounds(game, targetId)
        spellName == "Shield of Faith" ->
          Dndgame.Game.Spells.shield_of_faith(game, targetId)
      end
  end

  def get_character_stat_mod(character) do
    # get the type of modifier for the characters class
    statString = character.class.ability_modifier

    # cond to then output the characters number for that state
    cond do
      statString == "STR" ->
        Dndgame.Characters.get_stat_modifier(character.str)
      statString == "DEX" ->
        Dndgame.Characters.get_stat_modifier(character.dex)
      statString == "INT" ->
        Dndgame.Characters.get_stat_modifier(character.int)
      statString == "CON" ->
        Dndgame.Characters.get_stat_modifier(character.con)
      statString == "CHA" ->
        Dndgame.Characters.get_stat_modifier(character.cha)
      statString == "WIS" ->
        Dndgame.Characters.get_stat_modifier(character.wis)
    end
  end

  # use base attack on a certain enemy
  def attack(game, enemyId) do
    # get current character from array and index
    # get attack of character and apply it to the enemy
    # return game

    # get the character whose turn it is
    charIndex = get_character_index(game)
    character = Enum.at(game.battleParty, charIndex)
    enemy = Enum.at(game.monsters, enemyId)
    if enemy do

      # get the attack of this character
      attack = character.weapon.attack
      # attack: 1d20 + stat mod (str, dex, etc) + prof bonus(based on level) + attack bonus
      attackRoll = roll_dice("1d20") + get_character_stat_mod(character)
        + Dndgame.Characters.get_prof_bonus(character) + attack.attack_bonus
      attackMessage = "#{character.name} used #{attack.name} on #{enemy.name} with #{character.weapon.name}"
      # if it is a hit
      if attackRoll > enemy.ac do
        # calculate damage
        damage = roll_dice(attack.damage_dice) + get_character_stat_mod(character) + attack.damage_bonus
        # take damage out of enemy hp
        hitEnemy = Map.put(enemy, :hp, enemy.hp - damage)
        # replace less hp monster and update battleAction in game
        game
        |> Map.put(:monsters, List.replace_at(game.monsters, enemyId, hitEnemy))
        |> Map.put(:currentMenu, "main")
        |> Map.put(:battleAction, attackMessage <> ", and did #{damage} damage!")
        |> remove_dead_monsters
        |> incrementOrderIndex
      else
        game
        |> Map.put(:currentMenu, "main")
        |> Map.put(:battleAction, attackMessage <> ", but it missed!")
        |> remove_dead_monsters
        |> incrementOrderIndex
      end
    else
      game
    end
  end

  def select_alive_character(game) do
    aliveList = Enum.filter(game.battleParty, fn char -> char.hp > 0 end)
    liveLength = length(aliveList)
    charSelect = Enum.at(aliveList, :rand.uniform(liveLength) - 1)
  end

  def update_battleparty_by_name(game, character) do
    newParty = Enum.map(game.battleParty, fn char ->
      if char.name == character.name do
        character
      else
        char
      end end)

    game
    |> Map.put(:battleParty, newParty)
  end

  def enemy_attack(game, characterId) do
    # get current enemy
    enemyIndex = get_character_index(game)
    enemy = Enum.at(game.monsters, enemyIndex)
    if enemy do
      # TODO fix this tomorrow cristian
      characterId = Enum.random(0..length(game.battleParty)-1)
      # get the target character of the attack
#character = Enum.at(game.battleParty, characterId)
      targetCharacter = select_alive_character(game) #(game.battleParty, character.hp, characterId)
      # get the list of this enemy's available attacks
      attackList = enemy.attacks
      # pick a random attack to use this turn, based off length of attackList
      attack = Enum.at(attackList, :rand.uniform(length(attackList)) - 1)
      attackRoll = roll_dice("1d20") + attack.attack_bonus

      enemyAttackMessage = "#{enemy.name} used #{attack.name} on #{targetCharacter.name}"

      # if it is indeed a hit based off the attackRoll
      if attackRoll > targetCharacter.ac do
        # calculate damage with a damage_dice roll and damage_bonus
        damage = roll_dice(attack.damage_dice) + attack.damage_bonus
        # update character's hp by subtracting damage
        hitCharacter = Map.put(targetCharacter, :hp, targetCharacter.hp - damage)
        # replace the character in the game and update the battle action
        game
        |> Map.put(:currentMenu, "main")
        |> Map.put(:battleAction, enemyAttackMessage <> ", and did #{damage} damage!")
        |> update_battleparty_by_name(hitCharacter)
        |> remove_dead_monsters
        |> check_battle_lost
        |> incrementOrderIndex
      else
        # the roll wasn't higher than ac so attack missed, just update battleAction
        game
        |> Map.put(:currentMenu, "main")
        |> Map.put(:battleAction, enemyAttackMessage <> ", but missed!")
        |> remove_dead_monsters
        |> incrementOrderIndex
        |> check_battle_lost

      end
    else
      game
    end
  end

  def checkOrderIndex(game) do
    orderstring = Enum.at(game.orderArray, game.orderIndex)

    if orderstring =~ "character" do
      charIndex = game
      |> get_character_index

      char = Enum.at(game.battleParty, charIndex)

      if char.hp <= 0 do
        incrementOrderIndex(game)
      else
        game
      end
    else
      game
    end
  end

  def incrementOrderIndex(game) do
    newOrderIndex = game.orderIndex + 1
    # reached the end of the index, reset
    if newOrderIndex >= length(game.orderArray) do
      game
      |> Map.put(:orderIndex, 0)
      |> checkOrderIndex
    else
      game
      |> Map.put(:orderIndex, newOrderIndex)
      |> checkOrderIndex
    end
  end

  def get_ability_target(game, ability, targetId) do
    if ability.target == "self"
    || ability.target == "member"
    || ability.target == "party" do
      Enum.at(game.battleParty, targetId)
    else
      Enum.at(game.monsters, targetId)
    end
  end
end
