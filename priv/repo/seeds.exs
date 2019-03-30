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

pwhash = Argon2.hash_pwd_salt("password")

# TODO: Find a way to use seperate files, instead of one big mess
##### RACES ######
dwarf_armrs = ["Light", "Medium"]
dwarf_wpns = ["Battleaxe", "Handaxe", "Light Hammer", "Warhammer"]
Repo.insert!(%Race{name: "Dwarf", con_bonus: 2, wis_bonus: 1, size: "medium",
                armor_prof_array: dwarf_armrs, weapon_prof_array: dwarf_wpns})

elf_profs = ["Perception"]
elf_wpns = ["Longsword", "Shortsword", "Shortbow", "Longbow"]
Repo.insert!(%Race{name: "Elf", dex_bonus: 2, int_bonus: 1, size: "medium",
                  prof_array: elf_profs, weapon_prof_array: elf_wpns})
###### SPELLS ######
Repo.insert!(%Spell{name: "Magic Missle", dice: "1d4", dice_bonus: 1,
        level_req: 1, target: "enemies", type: "force"})

###### SKILLS ######
Repo.insert!(%Skill{name: "Short Rest", level_req: 0, type: "rest",
              sp_cost: 0, target: "self"})
Repo.insert!(%Skill{name: "Double Attack", level_req: 1, type: "damage",
              dice: "1d6", sp_cost: 1, target: "enemy"})

###### CLASSES #######
barbarian_profs = ["Athletics", "Intimidation"]
barbarian_saves = ["STR", "CON"]
barbarian_wpns = ["Simple", "Martial"]
barbarian_armor = ["Light", "Medium"]
Repo.insert!(%Class{name: "Barbarian", hit_die: 12, ability_modifier: "STR", prof_array: barbarian_profs,
                    save_array: barbarian_saves, weapon_prof_array: barbarian_wpns,
                    armor_prof_array: barbarian_armor})
Repo.insert!(%Classes.Skills{class: Classes.get_class_by_name("Barbarian"),
                              skill: Skills.get_skill_by_name("Double Attack")})

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

###### ARMORS ######
Repo.insert!(%Armor{name: "Mage Armor", base: 13, armor_category: "Special"})
Repo.insert!(%Armor{name: "Leather", base: 11, armor_category: "Light"})
Repo.insert!(%Armor{name: "Plate", base: 18, armor_category: "Heavy",
            max_dex_bonus: 0, stealth_disadvantage: true, str_minimum: 15})

###### ATTACKS ######
Repo.insert!(%Attack{name: "Pierce", damage_dice: "1d4", target: "enemy",
                      type: "normal"})
Repo.insert!(%Attack{name: "Cleave", damage_dice: "1d8", target: "enemy",
                      type: "normal"})

###### WEAPONS ######
Repo.insert!(%Weapon{name: "Dagger", weapon_category: "Simple",
                    attack: Attacks.get_attack_by_name("Pierce")})
Repo.insert!(%Weapon{name: "Battleaxe", weapon_category: "Martial",
                    attack: Attacks.get_attack_by_name("Cleave")})

###### USERS ######
Repo.insert!(%User{email: "Cristian", admin: true, password_hash: pwhash})

###### CHARACTERS ######
Repo.insert!(%Character{name: "Chuck", str: 10, dex: 10, int: 10, con: 10,
                wis: 10, cha: 13, weapon: Weapons.get_weapon_by_name("Dagger"),
                armor: Armors.get_armor_by_name("Mage Armor"),
                class: Classes.get_class_by_name("Wizard"),
                race: Races.get_race_by_name("Elf"),
                user: Users.get_user_by_email("Cristian")})
                elf_profs = ["Perception"]
                elf_wpns = ["Longsword", "Shortsword", "Shortbow", "Longbow"]
