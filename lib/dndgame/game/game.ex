defmodule Dndgame.Game do
  alias Dndgame.Characters
  alias Dndgame.Game.World
  require Protocol

  @boss_x 40
  @boss_y 40
  @max_steps_for_encounter 30
  @d20 "1d20"
  @duskTime ~T[18:00:00.0]
  @dawnTime ~T[06:00:00.0]
  @nightHotTemp 80
  @nightColdTemp 20
  @dayHotTemp 90
  @dayColdTemp 30

  def new_game(world) do
    # You're a new character, so this should be fine
    worldIndex = world.playerCount - 1
    %{
        playerIndex: worldIndex,
        windSpeed: Map.get(world, "windSpeed"), # in MPH
        temperature: Map.get(world, "apparentTemperature"), # in F
        visibility: Map.get(world, "visibility"),
        timezone: world.timezone, # the difference from UTC, Boston = -4

        battleParty: [],
        staticParty: [], # Will be added onto later
        monsters: [], # fills up when character encounters monsters
        boss: %{
          x: @boss_x,
          y: @boss_y,
        },

        orderArray: [], # fills up with strings of whose turn it is
        orderIndex: 0, # who's turn it is

        isLevelUp: [0,0,0], # flag to show a level screen or not
        isBossDead: "", # name of person who killed boss
        isGameOver: false, # flag to show a gameover screen

        currentMenu: "main", # main, skill, spell, monsterSelect, deathSaves
        battleAction: "",
        steps: 0,
    }
  end

  def create_party(game, party_id_1, party_id_2, party_id_3) do
    characterListItem1 = create_character_list_item(party_id_1)
    characterListItem2 = create_character_list_item(party_id_2)
    characterListItem3 = create_character_list_item(party_id_3)
    newParty = characterListItem1 ++ characterListItem2 ++ characterListItem3
    game
    |> Map.put(:staticParty, newParty)
  end

  # NOTE: Returns a list of 1 character
  def create_character_list_item(party_id) do
    if party_id == "" do
      []
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
      [character]
    end
  end

  def update_game_world(game, world) do
    game
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

      isLevelUp: game.isLevelUp, # flag to show a level screen or not
      isBossDead: game.isBossDead, # name of person who killed boss
      isGameOver: game.isGameOver, # flag to show a gameover screen

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
    if game.monsters == [] do
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
          game
          |> update_player_posn(playerX, playerY - 1, direction)
          |> Map.put(:steps, game.steps + 1)
          |> random_encounter
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
          # TODO make this better in the future
          monster = Dndgame.Monsters.get_monster_by_name("Fire Goblin")
          game
          |> Map.put(:monsters, [monster])
        game.temperature < @dayColdTemp ->
          monster = Dndgame.Monsters.get_monster_by_name("Ice Goblin")
          game
          |> Map.put(:monsters, [monster])
        true ->
          monster = Dndgame.Monsters.get_monster_by_name("Goblin")
          game
          |> Map.put(:monsters, [monster])
      end
    else
      cond do
        game.temperature > @nightHotTemp ->
          # TODO make this better in the future
          monster = Dndgame.Monsters.get_monster_by_name("Fire Zombie")
          game
          |> Map.put(:monsters, [monster])
        game.temperature < @nightColdTemp ->
          monster = Dndgame.Monsters.get_monster_by_name("Ice Zombie")
          game
          |> Map.put(:monsters, [monster])
        true ->
          monster = Dndgame.Monsters.get_monster_by_name("Zombie")
          game
          |> Map.put(:monsters, [monster])
      end
    end
  end

  def start_battle(game) do
    battleParty = game.staticParty
    game
    |> add_environment_monsters
    |> add_order_array
    |> Map.put(:battleParty, battleParty)
    |> Map.put(:currentMenu, "main")
    |> Map.put(:battleAction, "")
    |> Map.put(:steps, 0)
  end

  def add_order_array(game) do
    characterRolls = Enum.map(Enum.with_index(game.staticParty), fn {char, index} ->
      %{name: "character#{index}", init: roll_dice(@d20) + Dndgame.Characters.get_initiative(char)} end)

    monsterRolls = Enum.map(Enum.with_index(game.monsters), fn {monster, index} ->
      %{name: "monster#{index}", init: roll_dice(@d20) + Dndgame.Characters.get_initiative(monster)} end)

    allRolls = characterRolls ++ monsterRolls

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

  # Run from a battle
  def run(game) do
    # TODO: add rolling to decide on running
    # dexterity check for each player & monster, compare largest of each
    game
    |> Map.put(:battle_party, [])
    |> Map.put(:monsters, [])
  end

  # blank for now, will: clear battleParty, monsters, update xp,
  def end_battle(game) do
    # TODO get this workoing
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

  def get_character_battle(game) do
    # get character from game state and spell name
    # use a cond to go through and call a specific function for every skill we use
    charString = Enum.at(game.orderArray, game.orderIndex)
    charIndex = String.replace(charString, ~r/[^\d]/, "")
    Enum.at(game.battleParty, charIndex)
  end

  def get_character_static(game) do
    # get character from game state and spell name
    # use a cond to go through and call a specific function for every skill we use
    charString = Enum.at(game.orderArray, game.orderIndex)
    charIndex = String.replace(charString, ~r/[^\d]/, "")
    Enum.at(game.staticParty, charIndex)
  end

  # get the index of the character whose turn it is
  def get_character_index(game) do
    charString = Enum.at(game.orderArray, game.orderIndex)
    characterIndex = String.replace(charString, ~r/[^\d]/, "")
  end

  # updates the given newChar into the battleParty for the game
  def update_battle_party(game, newChar) do
    idx = get_character_index(game)
    # replace the character in the battle party and update the game
    newBattleParty = List.replace_at(game.battleParty, idx, newChar)

    game
    |> Map.replace(:battleParty, newBattleParty)
  end

  # use a specific skill on a certain enemy
  def use_skill(game, skillId, targetId) do
    character = get_character_battle(game)
    skillName = Enum.at(character.skills, skillId)

    # cond of all skills, goes to a function that deals with the logic of that skill
    cond do
      skillName == "Short Rest" ->
        short_rest(game)
      skillName == "Double Attack" ->
        double_attack(game, targetId)
      skillName == "Rage" ->
        rage(game)
      skillName == "Turn Undead" ->
        turn_undead(game, targetId)
      skillName == "Sneak Attack" ->
        sneak_attack(game, targetId)
      skillName == "Hide" ->
        hide(game)
    end
  end

  # use a specific skill on an enemy
  def use_spell(game, spellId, targetId) do
    # same as use skill but for spells
    character = get_character_battle(game)
    spellName = Enum.at(character.spells, spellId)

    cond do
      spellName == "Fire Bolt" ->
        fire_bolt(game, targetId)
      spellName == "Magic Missle" ->
        magic_missle(game)
      spellName == "Cure Wounds" ->
        cure_wounds(game, targetId)
      spellName == "Shield of Faith" ->
        shield_of_faith(game, targetId)
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
    character = get_character_battle(game)
    enemy = Enum.at(game.monsters, enemyId)

    # get the attack of this character
    attack = character.weapon.attack
    # attack: 1d20 + stat mod (str, dex, etc) + prof bonus(based on level) + attack bonus
    attackRoll = roll_dice("1d20") + get_character_stat_mod(character)
    + Dndgame.Characters.get_prof_bonus(character) + attack.attack_bonus
    # if it is a hit
    if attackRoll > enemy.ac do
      # calculate damage
      damage = roll_dice(attack.damage_dice) + get_character_stat_mod(character) + attack.damage_bonus
      # take damage out of enemy hp
      hitEnemy = Map.replace(enemy, :hp, enemy.hp - damage)
      # replace less hp monster and update battleAction in game
      game
      |> Map.replace(:monsters, List.replace_at(game.monsters, enemyId, hitEnemy))
      |> Map.replace(:battleAction, "#{character.name} did #{damage} damage
      to #{enemy.name} with #{attack.name}")
    else
      game
      |> Map.replace(:battleAction, "#{character.name} tried to attack
      #{enemy.name} with #{attack.name}, but it missed")
    end
  end

  def enemy_attack(game, characterId) do
    # get current enemy
    enemyString = Enum.at(game.orderArray, game.orderIndex)
    enemyIndex = String.replace(enemyString, ~r/[^\d]/, "")
    enemy = Enum.at(game.monsters, enemyIndex)

    # get the target character of the attack
    targetCharacter = Enum.at(game.battleParty, characterId)
    # get the list of this enemy's available attacks
    attackList = enemy.attacks
    # pick a random attack to use this turn, based off length of attackList
    attack = List.at(attackList, :rand.uniform(length(attackList)) - 1)
    attackRoll = roll_dice("1d20") + attack.attack_bonus

    # if it is indeed a hit based off the attackRoll
    if attackRoll > targetCharacter.ac do
      # calculate damage with a damage_dice roll and damage_bonus
      damage = roll_dice(attack.damage_dice) + attack.damage_bonus
      # update character's hp by subtracting damage
      hitCharacter = Map.replace(targetCharacter, :hp, targetCharacter.hp - damage)
      # replace the character in the game and update the battle action
      game
      |> update_battle_party(hitCharacter)
      |> Map.replace(:battleAction, "#{enemy.name} did #{damage} damage to
                                   #{targetCharacter.name} with #{attack.name}")
    else
      # the roll wasn't higher than ac so attack missed, just update battleAction
      game
      |> Map.replace(:battleAction, "#{enemy.name} missed attack on #{targetCharacter.name}")
    end
  end

  ##### SKILL FUNCTIONS #####

  def short_rest(game) do
    # goes on self
    # refills mana to full for now

    # get the static_mp of the character to know what value to refill
    character = get_character_battle(game)
    static_char = get_character_static(game)
    static_mp = Dndgame.Characters.get_mp(static_char)
    # update the character to have full mana again
    updated_char = Map.replace(character, :mp, static_mp)
    # update the battle party in the game and the battleAction text
    game
    |> update_battle_party(updated_char)
    |> Map.put(:battleAction, "#{updated_char.name} restored to #{static_mp} mana with Short Rest.")
  end

  def double_attack(game, targetId) do
    # simply do 2 attacks
    # get the character whose turn it is
    character = get_character_battle(game)
    enemy = Enum.at(game.monsters, targetId)
    doubleAttack = Dndgame.Skills.get_skill_by_name("Double Attack")
    # get the attack of this character
    attack = character.weapon.attack
    # attack: 1d20 + stat mod (str, dex, etc) + prof bonus(based on level) + attack bonus
    attackRoll1 = roll_dice("1d20") + get_character_stat_mod(character)
    + Dndgame.Characters.get_prof_bonus(character) + attack.attack_bonus
    attackRoll2 = roll_dice("1d20") + get_character_stat_mod(character)
    + Dndgame.Characters.get_prof_bonus(character) + attack.attack_bonus
    # update the characters sp to reflect the cost of Double Attack
    newChar = Map.replace(character, :sp, character.sp - doubleAttack.sp_cost)

    cond do
      # if both rolls are hits
      attackRoll1 > enemy.ac && attackRoll2 > enemy.ac ->
        # calculate damage
        damage = roll_dice(attack.damage_dice) + get_character_stat_mod(character) + attack.damage_bonus
        fullDamage = damage + damage
        # take damage out of enemy hp
        hitEnemy = Map.replace(enemy, :hp, enemy.hp - damage)
        # replace less hp monster and update battleAction in game
        game
        |> update_battle_party(newChar)
        |> Map.replace(:monsters, List.replace_at(game.monsters, targetId, hitEnemy))
        |> Map.replace(:battleAction, "#{character.name} did #{fullDamage} damage
        to #{enemy.name} using Double Attack with #{attack.name}")

      # if only one of the rolls hit
      attackRoll1 > enemy.ac && attackRoll2 <= enemy.ac or attackRoll1 <= enemy.ac && attackRoll2 > enemy.ac ->
        damage = roll_dice(attack.damage_dice) + get_character_stat_mod(character) + attack.damage_bonus
        # take damage out of enemy hp
        hitEnemy = Map.replace(enemy, :hp, enemy.hp - damage)
        # replace less hp monster and update battleAction in game
        game
        |> update_battle_party(newChar)
        |> Map.replace(:monsters, List.replace_at(game.monsters, targetId, hitEnemy))
        |> Map.replace(:battleAction, "#{character.name} did #{damage} damage
        to #{enemy.name} with one hit using Double Attack with #{attack.name}")

      attackRoll1 <= enemy.ac && attackRoll2 <= enemy.ac ->
        game
        |> update_battle_party(newChar)
        |> Map.replace(:battleAction, "#{character.name} tried to Double Attack
                              #{enemy.name} with #{attack.name}, but it missed")
    end
  end

  def rage(game) do
    # increase "dice" to character's strength
    # if str is greater than 30, set str to 30

    # get character and skill
    char = get_character_battle(game)
    skillRage = Dndgame.skills.get_skill_by_name("Rage")

    # calculate the buff and whether to set to max of 30 or not
    buff = roll_dice(skillRage.dice)
    totalStr = Enum.min([30, char.str + buff])

    # update the characters str and sp to reflect move
    newChar = char
    |> Map.replace(:str, totalStr)
    |> Map.replace(:sp, char.sp - skillRage.sp_cost)

    game
    |> update_battle_party(newChar)
    |> Map.replace(:battleAction, "#{char.name} used Rage to increase Strength by #{buff}")
  end

  def turn_undead(game, targetId) do
    # check if the monster is undead
    # if it is
      # check if there is more than 1 monster
      # if there's more than 1
        # remove that monster
      # if last monster
        # bring health to 0
        # our backend logic should make it so now you add exp, YOU WON
    # if not
      # do nothing

      enemy = Enum.at(game.monsters, targetId)
      type = enemy.type
      char = get_character_static(game)
      skill = DndGame.Skills.get_skill_by_name("Turn Undead")
      # update character by subtracting the sp cost of the move
      newChar = Map.replace(char, :sp, char.sp - skill.sp_cost)

      charString = Enum.at(game.orderArray, game.orderIndex)
      charIndex = String.replace(charString, ~r/[^\d]/, "")

      newBattleArray = List.replace_at(game.battleParty, charIndex, newChar)

      if type == "undead" do
        # if there is more than one monster in the battle array
        if length(game.monsters) > 1 do
          # remove the undead creature
          newMonsters = List.delete_at(game.monsters, targetId)
          # replace the array and update the battleAction text
          game
          |> Map.replace(:monsters, newMonsters)
          |> Map.replace(:battleParty, newBattleArray)
          |> Map.replace(:battleAction,
                              "#{char.name} used Turn Undead on #{enemy.name}")
        else
          # if there is only 1 monster that is this undead, just kill it for xp
          deadEnemy = Map.replace(enemy, :hp, 0)
          # replace the monster in the array and update battleAction text
          game
          |> Map.replace(:monsters, List.replace_at(game.monsters, 0, deadEnemy))
          |> Map.replace(:battleParty, newBattleArray)
          |> Map.replace(:battleAction,
                              "#{char.name} used Turn Undead on #{enemy.name}")
        end
      else
        # if the selected creature is not undead, do nothing but remove sp
        game
        |> Map.replace(:battleParty, newBattleArray)
        |> Map.replace(:battleAction,
              "#{char.name} attempted to use Turn Undead on the non-undead #{enemy.name}")
      end
  end

  def sneak_attack(game, targetId) do
    # HARDEST ONE TO DO

    # do a stealth check
      # roll a d20, add dexterity modifier, and then add proficiency bonus IF
      # you have the "stealth" proficiency
      # Compare that roll to the monster's Perception check (d20 + wis modifier)

    # if succeed stealth check
      # do TWO attack rolls, and pick the largest value (called "advantage")
      # do weapon_damage + dex modifier + 1d6 * ceil(level / 2)

    # if fail,
      # (just a normal attack function)
      # do normal attack
      # do weapon_damage + dex modifier

    # make sure our battle message shows whether or not the monster sees you
    # (stealth pass or fail message)

    char = get_character_battle(game)
    monster = Enum.at(game.monsters, targetId)
    skillStealth = Dndgame.Skills.get_skill_by_name("Sneak Attack")
    check = roll_dice(@d20) + get_character_stat_mod(char) + Dndgame.Characters.get_prof_bonus(char)
    monsterCheck = roll_dice(@d20) + Dndgame.Characters.get_stat_modifier(monster.wis)

    attack = char.weapon.attack

    if check > monsterCheck do
      # attack: 1d20 + stat mod (str, dex, etc) + prof bonus(based on level) + attack bonus
      attackRoll1 = roll_dice("1d20") + get_character_stat_mod(char)
      + Dndgame.Characters.get_prof_bonus(char) + attack.attack_bonus
      attackRoll2 = roll_dice("1d20") + get_character_stat_mod(char)
      + Dndgame.Characters.get_prof_bonus(char) + attack.attack_bonus

      highRoll = Enum.max([attackRoll1, attackRoll2])

      if highRoll > monster.ac do
        damage = roll_dice(attack.damage_dice) + get_character_stat_mod(char) + (roll_dice("1d6") * ceil(char.level / 2))
        hitMonster = Map.replace(monster, :hp, monster.hp - damage)
        newMonsters = List.replace_at(game.monsters, targetId, hitMonster)

        newChar = Map.replace(char, :sp, char.sp - skillStealth.sp_cost)

        game
        |> update_battle_party(newChar)
        |> Map.replace(:monsters, newMonsters)
        |> Map.replace(:battleAction, "#{char.name} successfully Sneak Attacked #{monster.name} for #{damage} damage")
      else
        newChar = Map.replace(char, :sp, char.sp - skillStealth.sp_cost)

        game
        |> update_battle_party(newChar)
        |> Map.replace(:battleAction, "#{char.name} missed Sneak Attack on #{monster.name}")
      end
    else
      attackRoll = roll_dice("1d20") + get_character_stat_mod(char)
      + Dndgame.Characters.get_prof_bonus(char) + attack.attack_bonus

      if attackRoll > monster.ac do
        damage = roll_dice(attack.damage_dice) + get_character_stat_mod(char)

        hitMonster = Map.replace(monster, :hp, monster.hp - damage)
        newMonsters = List.replace_at(game.monsters, targetId, hitMonster)

        newChar = Map.replace(char, :sp, char.sp - skillStealth.sp_cost)

        game
        |> update_battle_party(newChar)
        |> Map.replace(:monsters, newMonsters)
        |> Map.replace(:battleAction, "#{char.name} was caught by #{monster.name} but hit for #{damage} damage")
      else
        newChar = Map.replace(char, :sp, char.sp - skillStealth.sp_cost)

        game
        |> update_battle_party(newChar)
        |> Map.replace(:battleAction, "#{char.name} missed Sneak Attack on #{monster.name}")
      end
    end
  end

  def hide(game) do
    # do a stealth check
      # roll a d20, add dexterity modifier, and then add proficiency bonus IF
      # you have the "stealth" proficiency
      # Compare that roll to ALL monsters' Perception check (d20 + wis modifier)
      # basically, grab the highest wisdom check from monsters

    # if succeed
      # ac + 1
      # dex + 3

    # if fail
      # nothing, show you were caught with message

    # get character
    char = get_character_battle(game)
    skillHide = Dndgame.Skills.get_skill_by_name("Hide")
    # stealth check
    check = roll_dice(@d20) + get_character_stat_mod(char) + Dndgame.Characters.get_prof_bonus(char)
    monsterCheck = Enum.max(Enum.map(game.monsters, fn x ->
    roll_dice(@d20) + Dndgame.Characters.get_stat_modifier(x.wis) end))

    if check > monsterCheck do
      newChar = char
      |> Map.replace(:ac, char.ac + 1)
      |> Map.replace(:dex, char.dex + 3)
      |> Map.replace(:sp, char.sp - skillHide.sp_cost)

      game
      |> update_battle_party(newChar)
      |> Map.replace(:battleAction, "#{char.name} used Hide to increase ac by 1 and dex by 3")
    else
      newChar = char
      |> Map.replace(:sp, char.sp - skillHide.sp_cost)

      game
      |> update_battle_party(newChar)
      |> Map.replace(:battleAction, "#{char.name} was caught trying to hide, and did not receive any buffs")
    end
  end

  ##### SPELL FUNCTIONS #####
  def fire_bolt(game, targetId) do
    character = get_character_battle(game)
    spell = Dndgame.Spells.get_spell_by_name("Fire Bolt")

    # double damage for ice type
    damage = roll_dice(spell.dice)


    enemy = List.at(game.monsters, targetId)

    if enemy.element == "ice" do
      # double damage for ice enemies
      newHP = enemy.hp - damage - damage
      new_enemy = Map.put(enemy, :hp, newHP)

      game
      |> Map.put(:monsters, List.replace_at(game.monsters, targetId, new_enemy)
      |> Map.put(:battleAction, "#{character.name} did #{damage + damage} damage to
                                    #{enemy.name} with Fire Bolt"))
    else
      newHP = enemy.hp - damage
      new_enemy = Map.put(enemy, :hp, newHP)

      game
      |> Map.put(:monsters, List.replace_at(game.monsters, targetId, new_enemy)
      |> Map.put(:battleAction, "#{character.name} did #{damage} damage to
                                    #{enemy.name} with Fire Bolt"))
    end
  end

  def magic_missle(game) do
    # 1d4 + 1 force damage to all enemies
    # USE THE SPELL'S HIT DIE AND DAMAGE BONUS

    # get the character whose turn it is and the spell
    char = get_character_battle(game)
    magicMissle = Dndgame.Spells.get_spell_by_name("Magic Missle")

    # roll a 1d4 for damage and add the spells dice BONUS
    damage = roll_dice(magicMissle.dice) + magicMissle.dice_bonus

    # deal that damage to all enemies
    numEnemies = length(game.monsters)

    # update all monsters health to reflect damage
    hitMonsters = Enum.map(game.monsters, fn monster ->
                             Map.replace(monster, :hp, monster.hp - damage) end)

    game
    |> Map.replace(:monsters, hitMonsters)
    |> Map.replace(:battleAction, "#{char.name} used Magic Missle and dealt
    #{damage} damage to all enemies")
  end

  def cure_wounds(game, targetId) do
    # add hp to the chosen character 1d8 + your spellcasting ability modifier.

    # the only person that does this is cleric, so look at character.class.ability_modifier
    # and then get the modifier from that stat with get_stat_modifier(stat)
    # example: ability_modifier: "CHA", cha: 12, roll: 5
    # OUTPUT: 5 + 1 to chosen character

    # get the character and the spell
    char = get_character_battle(game)
    targetChar = Enum.at(game.battleParty, targetId)
    staticChar = Enum.at(game.staticParty, targetId)
    staticHP = staticChar.hp
    cureWounds = Dndgame.Spells.get_spell_by_name("Cure Wounds")
    # get the stat modifier for the character
    statMod = get_character_stat_mod(char.class.ability_modifier)
    # calculate the hp buff given via dice roll + stat modifier
    buff = roll_dice(cureWounds.dice) + statMod
    # update the target characters hp
    newHP = Enum.min([staticChar.hp, targetChar.hp + buff])
    newTargetChar = Map.replace(targetChar, :hp, newHP)
    # replace the character in the battle party and update the game
    newBattleParty = List.replace_at(game.battleParty, targetId, newTargetChar)
    # update the character using the move with less mp
    newChar = Map.replace(char, :mp, char.mp - cureWounds.mp_cost)

    # give the game the new healed character, then the char with less mp
    game
    |> Map.replace(:battleParty, newBattleParty)
    |> update_battle_party(newChar)
    |> Map.replace(:battleAction, "#{char.name} restored #{buff} hp with Cure Wounds")
  end

  def shield_of_faith(game, targetId) do
    # roll the "die" to add to the ac of the target
    # make sure that the ac is increased in the battle party
    thisChar = get_character_battle(game)
    targetChar = Enum.at(game.battleParty, targetId)
    spellShield = Dndgame.Spells.get_spell_by_name("Shield of Faith")
    # get the increase in AC by rolling the spell's dice
    increase = roll_dice(spellShield.dice)

    # get haracter's index and replace the updated character into battleParty
    charIndex = get_character_index(game)
    newTargetChar = Map.replace(targetChar, :ac, targetChar.ac + increase)
    newBattleParty = List.replace_at(game.battleParty, targetId, newTargetChar)

    # update this characters mp to reflect cost
    newThisChar = Map.replace(thisChar, :mp, thisChar.mp - spellShield.mp_cost)

    game
    |> Map.replace(:battleParty, newBattleParty)
    |> update_battle_party(newThisChar)
    |> Map.replace(:battleAction, "#{thisChar.name} increased the ac of
    #{targetChar.name} by #{increase} with Shield of Faith")
  end
end
