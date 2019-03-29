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

Repo.insert!(%Attack{name: "Pierce", damage_dice: "1d4", damage_bonus: 0,
                    attack_bonus: 0, target: "enemy", type: "normal"})
Repo.insert!(%Weapon{name: "Dagger", weapon_category: "simple",
                    attack: Attacks.get_attack_by_name("Pierce")})
Repo.insert!(%Spell{name: "Magic Missle", dice: "1d4", dice_bonus: 1,
        level_req: 1, target: "enemies", type: "force"})
Repo.insert!(%Skill{name: "Short Rest", level_req: 0, type: "rest",
              sp_cost: 0, target: "self"})
wizard_profs = ["Medicine", "Arcana"]
wizard_saves = ["INT", "WIS"]
wizard_wpns = ["Dagger", "Quarterstaff", "Darts", "Sling"]
wizard_armor = ["Mage Armor"]
Repo.insert!(%Class{name: "Wizard", hit_die: 6, prof_array: wizard_profs,
                    save_array: wizard_saves, weapon_prof_array: wizard_wpns,
                    armor_prof_array: wizard_armor}, ability_modifier: "INT")
Repo.insert!(%Classes.Skills{class: Classes.get_class_by_name("Wizard"),
                              skill: Skills.get_skill_by_name("Short Rest")})
Repo.insert!(%Classes.Spells{class: Classes.get_class_by_name("Wizard"),
                              spell: Spells.get_spell_by_name("Magic Missle")})
Repo.insert!(%Armor{name: "Mage Armor", base: 13, dex_bonus: true,
                    armor_category: "Special"})
elf_profs = ["Perception"]
elf_wpns = ["Longsword", "Shortsword", "Shortbow", "Longbow"]
Repo.insert!(%Race{name: "Elf", dex_bonus: 2, int_bonus: 1, size: "medium",
                  prof_array: elf_profs, weapon_prof_array: elf_wpns})

Repo.insert!(%User{email: "Cristian", admin: true, password_hash: pwhash})
Repo.insert!(%Character{name: "Chuck", str: 10, dex: 10, int: 10, con: 10,
                wis: 10, cha: 13, weapon: Weapons.get_weapon_by_name("Dagger"),
                armor: Armors.get_armor_by_name("Mage Armor"),
                class: Classes.get_class_by_name("Wizard"),
                race: Races.get_race_by_name("Elf"),
                user: Users.get_user_by_email("Cristian")})
