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


Repo.insert!(%Attack{name: "Slash", damage_dice: "1d6", damage_bonus: 0,
                    attack_bonus: 0, target: "enemy", type: "normal"})
Repo.insert!(%Weapon{name: "Short Sword", weapon_category: "simple",
                    attack: Attacks.get_attack_by_name("Slash")})
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
                    armor_prof_array: wizard_armor})
Repo.insert!(%Classes.Skills{class: Classes.get_class_by_name("Wizard"),
                              skill: Skills.get_skill_by_name("Short Rest")})
Repo.insert!(%Classes.Spells{class: Classes.get_class_by_name("Wizard"),
                              spell: Spells.get_spell_by_name("Magic Missle")})




barb_profs = []
barb_saves = []
