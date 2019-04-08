defmodule Dndgame.Game.Spells do
  import Dndgame.Game
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
