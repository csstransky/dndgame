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
alias Dndgame.Attacks.Attack
alias Dndgame.Attacks
alias Dndgame.Weapons.Weapon
alias Dndgame.Weapons


Repo.insert!(%Attack{name: "Slash", damage_dice: "1d6", damage_bonus: 0,
                    attack_bonus: 0, target: "enemy", type: "normal"})
Repo.insert!(%Weapon{name: "Short Sword", weapon_category: "simple",
                    attack: Attacks.get_attack_by_name("Slash")})
