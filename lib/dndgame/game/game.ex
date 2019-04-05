defmodule Dndgame.Game do
  alias Dndgame.Characters
  require Protocol

  @starting_x 44
  @starting_y 64
  @boss_x 40
  @boss_y 40

  def new_game(world) do
    # You're a new character, so this should be fine
    worldIndex = world.playerCount - 1
    %{
        characterIndex: worldIndex,
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
    |> Map.put(:characterPosns, world.playerPosns)
    |> Map.put(:windSpeed, Map.get(world, "windSpeed"))
    |> Map.put(:temperature, Map.get(world, "apparentTemperature"))
    |> Map.put(:timezone, world.timezone)
  end

  def client_view(game) do
    gameView = %{
      characterPosns: game.characterPosns,
      characterIndex: game.characterIndex,
      weather: %{
        wind: game.windSpeed, # in MPH
        temperature: game.temperature, # in F
        visibility: game.visibility,
      },

      windSpeed: game.windSpeed,
      temperature: game.temperature,
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

      mainMenuOptions: [],
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
      Map.put(gameView, :party, battleParty)
    end
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


  # use a specific skill on a certain enemy
  def use_skill(game, skillId, targetId) do
    character = get_character_battle(game)
    skillName = Enum.at(character.skills, skillId)

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
  def use_spell(game, spellId, targetId) do
    # same as use skill but for spells
    character = get_character_battle(game)
    spellName = Enum.at(character.spells, spellId)

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


  # SKILL FUNCTIONS

  def short_rest(game, character, targetId) do
    # goes on self
    # refills mana to full for now



    # get the static_mp of the character to know what value to refill
    static_char = get_character_static(game)
    static_mp = Dndgame.Characters.get_mp(static_char)

    # update the character to have full mana again
    updated_char = Map.replace(character, :mp, static_mp)

    # variable to update the character in the list
    updated_party = List.replace_at(game.battleParty, targetId, updated_char)

    # loop through the list, replace the matching character with the updated character
    #Enum.each updatedParty, fn char ->
    #  if char.name == updated_char.name do
    #    char = updated_char
    #  end
    #end

    # update the battle party in the game and the battleAction text
    game
    |> Map.put(:battleParty, updated_party)
    |> Map.put(:battleAction, "#{updated_char.name} restored to #{static_mp} mana with Short Rest.")

  end

  def double_attack(game, character, targetId) do
    # simply do 2 attacks
  end

  def rage(game, character, targetId) do
    # increase "dice" to character's strength
    # if str is greater than 30, set str to 30
  end

  def turn_undead(game, character, targetId) do
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

  end

  def sneak_attack(game, character, targetId) do
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
  end

  def hide(game, character, targetId) do
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
  end

  # SPELL FUNCTIONS

  def fire_bolt(game, character, targetId) do
    # double damage for ice type
    damage = roll_dice("1d10")

    enemy = List.at(game.monsters, targetId)
    newHP = enemy.hp - damage
    new_enemy = Map.put(enemy, :hp, newHP)

    game
    |> Map.put(:monsters, List.replace_at(game.monsters, targetId, new_enemy)
    |> Map.put(:battleAction, "#{character} did #{damage} damage to #{enemy.monster_name} number #{targetId}"))
  end

  def magic_missle(game, character, targetId) do
    # 1d4 + 1 force damage to all enemies
    # USE THE SPELL'S HIT DIE AND DAMAGE BONUS
  end

  def cure_wounds(game, character, targetId) do
   # add hp to the chosen character 1d8 + your spellcasting ability modifier.

   # the only person that does this is cleric, so look at character.class.ability_modifier
   # and then get the modifier from that stat with get_stat_modifier(stat)
   # example: ability_modifier: "CHA", cha: 12, roll: 5
   # OUTPUT: 5 + 1 to chosen character
  end


  def shield_of_faith(game, character, targetId) do
    # roll the "die" to add to the ac of the target
    # make sure that the ac is increased in the battle party
  end
end
