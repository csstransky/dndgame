defmodule Dndgame.Game.Skills do
  import Dndgame.Game
  ##### SKILL FUNCTIONS #####

  def short_rest(game) do
    # goes on self
    # refills mana to full for now

    # get the static_mp of the character to know what value to refill
    charIndex = get_character_index(game)
    character = Enum.at(game.battleParty, charIndex)
    static_char = Enum.at(game.staticParty, charIndex)
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
    charIndex = get_character_index(game)
    character = Enum.at(game.battleParty, charIndex)
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
        |> Map.replace(:battleAction,
          "#{character.name} did #{fullDamage} damage to #{enemy.name} using Double Attack with #{character.weapon.name}!")

        # if only one of the rolls hit
        attackRoll1 > enemy.ac && attackRoll2 <= enemy.ac or attackRoll1 <= enemy.ac && attackRoll2 > enemy.ac ->
          damage = roll_dice(attack.damage_dice) + get_character_stat_mod(character) + attack.damage_bonus
          # take damage out of enemy hp
          hitEnemy = Map.replace(enemy, :hp, enemy.hp - damage)
          # replace less hp monster and update battleAction in game
          game
          |> update_battle_party(newChar)
          |> Map.replace(:monsters, List.replace_at(game.monsters, targetId, hitEnemy))
          |> Map.replace(:battleAction,
            "#{character.name} did #{damage} damage to #{enemy.name} with one hit using Double Attack with #{character.weapon.name}!")

          attackRoll1 <= enemy.ac && attackRoll2 <= enemy.ac ->
            game
            |> update_battle_party(newChar)
            |> Map.replace(:battleAction,
              "#{character.name} tried to Double Attack #{enemy.name} with #{character.weapon.name}, but it missed!")
          end
        end

  def rage(game) do
    # increase "dice" to character's strength
    # if str is greater than 30, set str to 30

    # get character and skill
    charIndex = get_character_index(game)
    char = Enum.at(game.battleParty, charIndex)
    skillRage = Dndgame.Skills.get_skill_by_name("Rage")

    # calculate the buff and whether to set to max of 30 or not
    buff = roll_dice(skillRage.dice)
    totalStr = Enum.min([30, char.str + buff])

    # update the characters str and sp to reflect move
    newChar = char
    |> Map.replace(:str, totalStr)
    |> Map.replace(:sp, char.sp - skillRage.sp_cost)

    game
    |> update_battle_party(newChar)
    |> Map.replace(:battleAction, "#{char.name} used Rage to increase STR by #{buff}!")
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
    charIndex = get_character_index(game)
    char = Enum.at(game.staticParty, charIndex)
    skill = Dndgame.Skills.get_skill_by_name("Turn Undead")
    # update character by subtracting the sp cost of the move
    newChar = Map.replace(char, :sp, char.sp - skill.sp_cost)

    if type == "undead" do
      # if there is more than one monster in the battle array
        # if there is only 1 monster that is this undead, just kill it for xp
        deadEnemy = Map.replace(enemy, :hp, 0)
        # replace the monster in the array and update battleAction text
        game
        |> Map.replace(:monsters, List.replace_at(game.monsters, targetId, deadEnemy))
        |> update_battle_party(newChar)
        |> remove_dead_monsters
        |> Map.replace(:battleAction,
          "#{char.name} used Turn Undead on #{enemy.name}!")

    else
      # if the selected creature is not undead, do nothing but remove sp
      game
      |> update_battle_party(newChar)
      |> remove_dead_monsters
      |> Map.replace(:battleAction,
        "#{char.name} attempted to use Turn Undead on the non-undead #{enemy.name}, and failed!")
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

    charIndex = get_character_index(game)
    char = Enum.at(game.battleParty, charIndex)
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
        |> Map.replace(:battleAction,
          "#{char.name} successfully Sneak Attacked #{monster.name} for #{damage} damage!")
      else
        newChar = Map.replace(char, :sp, char.sp - skillStealth.sp_cost)

        game
        |> update_battle_party(newChar)
        |> Map.replace(:battleAction,
          "#{char.name} failed to Sneak Attack the #{monster.name}.")
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
        |> Map.replace(:battleAction,
          "#{char.name} was caught by #{monster.name}, but hit for #{damage} damage!")
      else
        newChar = Map.replace(char, :sp, char.sp - skillStealth.sp_cost)

        game
        |> update_battle_party(newChar)
        |> Map.replace(:battleAction,
          "#{char.name} missed Sneak Attack on #{monster.name}.")
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
    charIndex = get_character_index(game)
    char = Enum.at(game.battleParty, charIndex)
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
        |> Map.replace(:battleAction,
          "#{char.name} used Hide to increase AC by 1 and DEX by 3!")
      else
        newChar = char
        |> Map.replace(:sp, char.sp - skillHide.sp_cost)

        game
        |> update_battle_party(newChar)
        |> Map.replace(:battleAction,
          "#{char.name} was caught trying to hide!")
      end
    end
end
