# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Dndgame.Repo.insert!(%Dndgame.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Dndgame.Repo
alias Dndgame.Users.User
alias Dndgame.Users
alias Dndgame.Characters.Character
alias Dndgame.Classes.Class
alias Dndgame.Classes
alias Dndgame.Attacks.Attack
alias Dndgame.Attacks
alias Dndgame.Weapons.Weapon
alias Dndgame.Weapons
alias Dndgame.Spells.Spell
alias Dndgame.Spells
alias Dndgame.Skills.Skill
alias Dndgame.Skills
alias Dndgame.Armors.Armor
alias Dndgame.Armors
alias Dndgame.Races.Race
alias Dndgame.Races
alias Dndgame.Users.User
alias Dndgame.Users
alias Dndgame.Monsters
alias Dndgame.Monsters.Monster

pwhash = Argon2.hash_pwd_salt("password")

# TODO: Find a way to use seperate files, instead of one big mess
##### RACES ######
dwarf_armrs = ["Light", "Medium"]
dwarf_wpns = ["Battleaxe", "Handaxe", "Light Hammer", "Warhammer"]
Repo.insert!(%Race{name: "Dwarf", con_bonus: 2, wis_bonus: 1, size: 0,
                armor_prof_array: dwarf_armrs, weapon_prof_array: dwarf_wpns})

elf_profs = ["Perception"]
elf_wpns = ["Longsword", "Shortsword", "Shortbow", "Longbow"]
Repo.insert!(%Race{name: "Elf", dex_bonus: 2, int_bonus: 1, size: 0,
                  prof_array: elf_profs, weapon_prof_array: elf_wpns})

gnome_saves = ["INT", "WIS", "CHA"]
Repo.insert!(%Race{name: "Gnome", int_bonus: 2, cha_bonus: 1, size: -1,
                save_array: gnome_saves})

Repo.insert!(%Race{name: "Human", str_bonus: 1, dex_bonus: 1, int_bonus: 1,
                  con_bonus: 1, wis_bonus: 1, cha_bonus: 1, size: 0})



###### SPELLS ######
Repo.insert!(%Spell{name: "Fire Bolt", dice: "1d10",
        level_req: 1, target: "enemy", type: "fire", mp_cost: 0})
Repo.insert!(%Spell{name: "Magic Missle", dice: "1d4", dice_bonus: 1,
        level_req: 1, target: "enemies", type: "force", mp_cost: 1})
# TODO: Make these "member" in the future and deal with it
Repo.insert!(%Spell{name: "Cure Wounds", dice: "1d8",
        level_req: 1, target: "self", type: "heal", mp_cost: 1})
Repo.insert!(%Spell{name: "Shield of Faith", dice: "2d1",
        level_req: 1, target: "self", type: "buff", buff_stat: "AC", mp_cost: 1})

###### SKILLS ######
Repo.insert!(%Skill{name: "Short Rest", level_req: 1, type: "rest",
              sp_cost: 0, target: "self", buff_stat: "MP", dice: "hit_die"})
Repo.insert!(%Skill{name: "Double Attack", level_req: 1, type: "damage",
              dice: "1d6", sp_cost: 1, target: "enemy"})
Repo.insert!(%Skill{name: "Rage", level_req: 1, type: "buff", sp_cost: 2,
              target: "self", buff_stat: "STR", dice: "4d1"})
Repo.insert!(%Skill{name: "Turn Undead", level_req: 1, type: "run_away",
              sp_cost: 1, target: "enemies", buff_stat: "WIS", dice: "save"})
Repo.insert!(%Skill{name: "Sneak Attack", level_req: 1, type: "damage",
              sp_cost: 2, target: "enemy", dice: "2d6"})
Repo.insert!(%Skill{name: "Hide", level_req: 1, type: "buff",
              sp_cost: 1, target: "self", buff_stat: "DEX", dice: "4d1"})

###### CLASSES #######
barbarian_profs = ["Athletics", "Intimidation"]
barbarian_saves = ["STR", "CON"]
barbarian_wpns = ["Simple", "Martial"]
barbarian_armor = ["Light", "Medium", "Heavy"]
Repo.insert!(%Class{name: "Barbarian", hit_die: 12, ability_modifier: "STR", prof_array: barbarian_profs,
                    save_array: barbarian_saves, weapon_prof_array: barbarian_wpns,
                    armor_prof_array: barbarian_armor})
Repo.insert!(%Classes.Skills{class: Classes.get_class_by_name("Barbarian"),
                              skill: Skills.get_skill_by_name("Double Attack")})
Repo.insert!(%Classes.Skills{class: Classes.get_class_by_name("Barbarian"),
                              skill: Skills.get_skill_by_name("Rage")})

rogue_profs = ["Acrobatics", "Perception", "Stealth", "Sleight of Hand"]
rogue_saves = ["DEX", "INT"]
rogue_wpns = ["Simple", "Hand Crossbow", "Longsword", "Rapier", "Shortsword"]
rogue_armor = ["Light"]
Repo.insert!(%Class{name: "Rogue", hit_die: 8, ability_modifier: "DEX", prof_array: rogue_profs,
                    save_array: rogue_saves, weapon_prof_array: rogue_wpns,
                    armor_prof_array: rogue_armor})
Repo.insert!(%Classes.Skills{class: Classes.get_class_by_name("Rogue"),
                            skill: Skills.get_skill_by_name("Hide")})
Repo.insert!(%Classes.Skills{class: Classes.get_class_by_name("Rogue"),
                            skill: Skills.get_skill_by_name("Sneak Attack")})

wizard_profs = ["Medicine", "Arcana"]
wizard_saves = ["INT", "WIS"]
wizard_wpns = ["Dagger", "Quarterstaff", "Darts", "Sling"]
wizard_armor = ["Mage Armor"]
Repo.insert!(%Class{name: "Wizard", hit_die: 6, ability_modifier: "INT", prof_array: wizard_profs,
                    save_array: wizard_saves, weapon_prof_array: wizard_wpns,
                    armor_prof_array: wizard_armor})
Repo.insert!(%Classes.Skills{class: Classes.get_class_by_name("Wizard"),
                              skill: Skills.get_skill_by_name("Short Rest")})
Repo.insert!(%Classes.Spells{class: Classes.get_class_by_name("Wizard"),
                              spell: Spells.get_spell_by_name("Magic Missle")})
Repo.insert!(%Classes.Spells{class: Classes.get_class_by_name("Wizard"),
                              spell: Spells.get_spell_by_name("Fire Bolt")})

cleric_profs = ["Medicine", "Persuasion"]
cleric_saves = ["WIS", "CHA"]
cleric_wpns = ["Simple"]
cleric_armor = ["Light", "Medium"]
Repo.insert!(%Class{name: "Cleric", hit_die: 8, ability_modifier: "WIS", prof_array: cleric_profs,
                    save_array: cleric_saves, weapon_prof_array: cleric_wpns,
                    armor_prof_array: cleric_armor})
Repo.insert!(%Classes.Skills{class: Classes.get_class_by_name("Cleric"),
                              skill: Skills.get_skill_by_name("Turn Undead")})
Repo.insert!(%Classes.Spells{class: Classes.get_class_by_name("Cleric"),
                              spell: Spells.get_spell_by_name("Cure Wounds")})
Repo.insert!(%Classes.Spells{class: Classes.get_class_by_name("Cleric"),
                              spell: Spells.get_spell_by_name("Shield of Faith")})

###### ARMORS ######
Repo.insert!(%Armor{name: "Mage Armor", base: 13, armor_category: "Special"})
Repo.insert!(%Armor{name: "Leather", base: 11, armor_category: "Light"})
Repo.insert!(%Armor{name: "Studded Leather", base: 12, armor_category: "Light"})
Repo.insert!(%Armor{name: "Plate", base: 18, armor_category: "Heavy",
            max_dex_bonus: 0, stealth_disadvantage: true, str_minimum: 15})
Repo.insert!(%Armor{name: "Chain Mail", base: 16, armor_category: "Heavy",
            max_dex_bonus: 0, stealth_disadvantage: true, str_minimum: 13})
Repo.insert!(%Armor{name: "Ring Mail", base: 14, armor_category: "Heavy",
            max_dex_bonus: 0, stealth_disadvantage: true})
Repo.insert!(%Armor{name: "Half Plate", base: 15, armor_category: "Medium",
            max_dex_bonus: 2, stealth_disadvantage: true})
Repo.insert!(%Armor{name: "Breastplate", base: 14, armor_category: "Medium",
            max_dex_bonus: 2})

###### ATTACKS ######
Repo.insert!(%Attack{name: "Stab", damage_dice: "1d4", target: "enemy",
                      type: "pierce"})
Repo.insert!(%Attack{name: "Pierce", damage_dice: "1d6", target: "enemy",
                      type: "pierce"})
Repo.insert!(%Attack{name: "Perforate", damage_dice: "1d8", target: "enemy",
                      type: "pierce"})
Repo.insert!(%Attack{name: "Impale", damage_dice: "1d10", target: "enemy",
                      type: "pierce"})

Repo.insert!(%Attack{name: "Slice", damage_dice: "1d4", target: "enemy",
                      type: "slash"})
Repo.insert!(%Attack{name: "Slash", damage_dice: "1d6", target: "enemy",
                      type: "slash"})
Repo.insert!(%Attack{name: "Chop", damage_dice: "1d6", target: "enemy",
                      type: "slash"})
Repo.insert!(%Attack{name: "Cleave", damage_dice: "1d8", target: "enemy",
                      type: "slash"})
Repo.insert!(%Attack{name: "Lunge", damage_dice: "1d10", target: "enemy",
                      type: "slash"})

Repo.insert!(%Attack{name: "Strike", damage_dice: "1d4", target: "enemy",
                      type: "bludgeon"})
Repo.insert!(%Attack{name: "Smash", damage_dice: "1d6", target: "enemy",
                      type: "bludgeon"})
Repo.insert!(%Attack{name: "Crush", damage_dice: "1d8", target: "enemy",
                      type: "bludgeon"})
Repo.insert!(%Attack{name: "Wreck", damage_dice: "1d10", target: "enemy",
                      type: "bludgeon"})

Repo.insert!(%Attack{name: "Fling", damage_dice: "1d4", target: "enemy",
                      type: "bludgeon"})
Repo.insert!(%Attack{name: "Dart", damage_dice: "1d4", target: "enemy",
                      type: "pierce"})
Repo.insert!(%Attack{name: "Shoot", damage_dice: "1d6", target: "enemy",
                      type: "pierce"})
Repo.insert!(%Attack{name: "Loose", damage_dice: "1d8", target: "enemy",
                      type: "pierce"})

###### WEAPONS ######
Repo.insert!(%Weapon{name: "Dagger", weapon_category: "Simple",
                    attack: Attacks.get_attack_by_name("Stab")})
Repo.insert!(%Weapon{name: "Battleaxe", weapon_category: "Martial",
                    attack: Attacks.get_attack_by_name("Cleave")})
Repo.insert!(%Weapon{name: "Halberd", weapon_category: "Martial",
                    attack: Attacks.get_attack_by_name("Lunge")})
Repo.insert!(%Weapon{name: "Handaxe", weapon_category: "Simple",
                    attack: Attacks.get_attack_by_name("Chop")})
Repo.insert!(%Weapon{name: "Quarterstaff", weapon_category: "Simple",
                    attack: Attacks.get_attack_by_name("Smash")})
Repo.insert!(%Weapon{name: "Light Hammer", weapon_category: "Simple",
                    attack: Attacks.get_attack_by_name("Strike")})
Repo.insert!(%Weapon{name: "Warhammer", weapon_category: "Martial",
                    attack: Attacks.get_attack_by_name("Crush")})
Repo.insert!(%Weapon{name: "Longsword", weapon_category: "Martial",
                    attack: Attacks.get_attack_by_name("Cleave")})
Repo.insert!(%Weapon{name: "Shortsword", weapon_category: "Martial",
                    attack: Attacks.get_attack_by_name("Pierce")})
Repo.insert!(%Weapon{name: "Rapier", weapon_category: "Martial",
                    attack: Attacks.get_attack_by_name("Perforate")})
Repo.insert!(%Weapon{name: "Shortbow", weapon_category: "Simple", #1d6
                    attack: Attacks.get_attack_by_name("Shoot")})
Repo.insert!(%Weapon{name: "Darts", weapon_category: "Simple",
                    attack: Attacks.get_attack_by_name("Dart")})
Repo.insert!(%Weapon{name: "Sling", weapon_category: "Simple",
                    attack: Attacks.get_attack_by_name("Fling")})
Repo.insert!(%Weapon{name: "Longbow", weapon_category: "Martial", # 1d8
                    attack: Attacks.get_attack_by_name("Loose")})
Repo.insert!(%Weapon{name: "Hand Crossbow", weapon_category: "Martial",
                    attack: Attacks.get_attack_by_name("Shoot")})


###### USERS ######
Repo.insert!(%User{email: "Cristian", admin: true, password_hash: pwhash})

###### Debug Weapon ######
Repo.insert!(%Attack{name: "Obliterate", damage_dice: "2d10", damage_bonus: 99,
                    attack_bonus: 99, target: "enemy", type: "pierce"})
Repo.insert!(%Weapon{name: "God Killer", weapon_category: "Heavenly",
                    attack: Attacks.get_attack_by_name("Obliterate")})
###### CHARACTERS ######
Repo.insert!(%Character{name: "Chuck", str: 10, dex: 20, int: 10, con: 20,
                wis: 10, cha: 13, weapon: Weapons.get_weapon_by_name("God Killer"),
                armor: Armors.get_armor_by_name("Mage Armor"),
                class: Classes.get_class_by_name("Wizard"),
                race: Races.get_race_by_name("Elf"),
                user: Users.get_user_by_email("Cristian")})

###### MONSTER ATTACKS ######
Repo.insert!(%Attack{name: "Swipe", damage_dice: "1d4", attack_bonus: 1,
                    damage_bonus: 1, target: "member", type: "slash"})
Repo.insert!(%Attack{name: "Headbutt", damage_dice: "1d4", attack_bonus: 1,
                    damage_bonus: 2, target: "member", type: "bludgeon"})
Repo.insert!(%Attack{name: "Fire Throw", damage_dice: "1d4", attack_bonus: 1,
                    damage_bonus: 1, target: "member", type: "fire"})
Repo.insert!(%Attack{name: "Ice Punch", damage_dice: "1d4", attack_bonus: 2,
                    damage_bonus: 2, target: "member", type: "ice"})
Repo.insert!(%Attack{name: "Bite", damage_dice: "1d4", attack_bonus: 1,
                    damage_bonus: 1, target: "member", type: "pierce"})
Repo.insert!(%Attack{name: "Lava Chomp", damage_dice: "1d4", attack_bonus: 2,
                    damage_bonus: 2, target: "member", type: "fire"})
Repo.insert!(%Attack{name: "Frostbite", damage_dice: "1d4", attack_bonus: 1,
                    damage_bonus: 1, target: "member", type: "ice"})
Repo.insert!(%Attack{name: "Dragon Claw", damage_dice: "2d4", attack_bonus: 7,
                    damage_bonus: 4, target: "member", type: "slash"})
Repo.insert!(%Attack{name: "Poison Breath", damage_dice: "3d8",
                    target: "party", type: "poison"})
Repo.insert!(%Attack{name: "Chomp", damage_dice: "2d10", damage_bonus: 4,
                    attack_bonus: 5, target: "member", type: "pierce"})


###### MONSTERS ######
Repo.insert!(%Monster{name: "Goblin", hp: 13, ac: 5,
                      type: "goblin", element: "normal", str: 8, dex: 14,
                      int: 10, con: 10, cha: 8, wis: 8})
Repo.insert!(%Monsters.Attacks{monster: Monsters.get_monster_by_name("Goblin"),
                                attack: Attacks.get_attack_by_name("Swipe")})
Repo.insert!(%Monsters.Attacks{monster: Monsters.get_monster_by_name("Goblin"),
                                attack: Attacks.get_attack_by_name("Headbutt")})
Repo.insert!(%Monster{name: "Ice Goblin", hp: 13, ac: 6,
                      type: "goblin", element: "ice", str: 8, dex: 14, int: 10,
                      con: 10, cha: 8, wis: 8})
Repo.insert!(%Monsters.Attacks{monster: Monsters.get_monster_by_name("Ice Goblin"),
                                attack: Attacks.get_attack_by_name("Swipe")})
Repo.insert!(%Monsters.Attacks{monster: Monsters.get_monster_by_name("Ice Goblin"),
                                attack: Attacks.get_attack_by_name("Ice Punch")})
Repo.insert!(%Monster{name: "Fire Goblin", hp: 13, ac: 7,
                      type: "goblin", element: "fire", str: 8, dex: 14, int: 10,
                      con: 10, cha: 8, wis: 8})
Repo.insert!(%Monsters.Attacks{monster: Monsters.get_monster_by_name("Fire Goblin"),
                                attack: Attacks.get_attack_by_name("Swipe")})
Repo.insert!(%Monsters.Attacks{monster: Monsters.get_monster_by_name("Fire Goblin"),
                                attack: Attacks.get_attack_by_name("Fire Throw")})

Repo.insert!(%Monster{name: "Zombie", hp: 25, ac: 4,
                      type: "undead", element: "normal", str: 13, dex: 6,
                      int: 3, con: 16, cha: 5, wis: 6})
Repo.insert!(%Monsters.Attacks{monster: Monsters.get_monster_by_name("Zombie"),
                                attack: Attacks.get_attack_by_name("Swipe")})
Repo.insert!(%Monsters.Attacks{monster: Monsters.get_monster_by_name("Zombie"),
                                attack: Attacks.get_attack_by_name("Bite")})
Repo.insert!(%Monster{name: "Ice Zombie", hp: 25, ac: 5,
                      type: "undead", element: "ice", str: 13, dex: 6,
                      int: 3, con: 16, cha: 5, wis: 6})
Repo.insert!(%Monsters.Attacks{monster: Monsters.get_monster_by_name("Ice Zombie"),
                                attack: Attacks.get_attack_by_name("Bite")})
Repo.insert!(%Monsters.Attacks{monster: Monsters.get_monster_by_name("Ice Zombie"),
                                attack: Attacks.get_attack_by_name("Frostbite")})
Repo.insert!(%Monster{name: "Fire Zombie", hp: 25, ac: 7,
                      type: "undead", element: "fire", str: 13, dex: 6,
                      int: 3, con: 16, cha: 5, wis: 6})
Repo.insert!(%Monsters.Attacks{monster: Monsters.get_monster_by_name("Fire Zombie"),
                                attack: Attacks.get_attack_by_name("Bite")})
Repo.insert!(%Monsters.Attacks{monster: Monsters.get_monster_by_name("Fire Zombie"),
                                attack: Attacks.get_attack_by_name("Lava Chomp")})
Repo.insert!(%Monster{name: "Young Green Dragon", hp: 136, ac: 15, type: "dragon",
                      element: "poison", size: 1, str: 19, dex: 12, con: 17,
                      int: 16, wis: 13, cha: 15, exp: 10000})
Repo.insert!(%Monsters.Attacks{monster: Monsters.get_monster_by_name("Young Green Dragon"),
                                attack: Attacks.get_attack_by_name("Dragon Claw")})
Repo.insert!(%Monsters.Attacks{monster: Monsters.get_monster_by_name("Young Green Dragon"),
                                attack: Attacks.get_attack_by_name("Chomp")})
Repo.insert!(%Monsters.Attacks{monster: Monsters.get_monster_by_name("Young Green Dragon"),
                                attack: Attacks.get_attack_by_name("Poison Breath")})
