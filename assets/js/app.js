// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html";
import jQuery from 'jquery';
window.jQuery = window.$ = jQuery;
import "bootstrap";
import _ from "lodash";

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

$(function () {
  $('#race_select').click((ev) => {
    $.ajax({
      method: "GET",
      url: "/ajax/v1/races/" + $('#race_select').val(),
      dataType: "json",
      success: (resp) => {
        update_armors();
        $('#HELLFIRE').text(show_race(resp.data));
      },
      error: (resp) => {
        console.log(resp)
      }
    });
  });
  $('#class_select').click((ev) => {
    $.ajax({
      method: "GET",
      url: "/ajax/v1/classes/" + $('#class_select').val(),
      dataType: "json",
      success: (resp) => {
        update_armors();
        console.log(resp);
        $('#HELLFIRE').text(show_class(resp.data));
      },
      error: (resp) => {
        console.log(resp)
      }
    });
  })
});

// TODO, fix this to get the rid parameters into
function update_armors() {
  let race_id = $('#race_select').val()
  let class_id = $('#class_select').val()
  let url = "/ajax/v1/select_armors/?race_id=" + race_id +"&class_id=" + class_id
  $.ajax({
    method: "GET",
    url: url,
    dataType: "json",
    success: (resp) => {
      $('#armor_select').empty()
      let armor_list = resp.data;
      $.each(armor_list, function (index, armor) {
        $('#armor_select').append($('<option/>', {
          value: armor.id,
          text: armor.name
        }));
      });
    },
    error: (resp) => {
      console.log(resp)
    }
  });
}

// TODO: Bach, you'll probably want to mess with this and IDs to make it look just
//right
function show_race(race) {
  let name = race.name;
  let desc = race.desc === "" ? "" : "\nDesc: " + race.desc;
  let str_bonus = race.str_bonus === 0 ? "" : "\nSTR Bonus: " + race.str_bonus;
  let dex_bonus = race.dex_bonus === 0 ? "" : "\nDEX Bonus: " + race.dex_bonus;
  let int_bonus = race.int_bonus === 0 ? "" : "\nINT Bonus: " + race.int_bonus;
  let con_bonus = race.con_bonus === 0 ? "" : "\nCON Bonus: " + race.con_bonus;
  let wis_bonus = race.wis_bonus === 0 ? "" : "\nWIS Bonus: " + race.wis_bonus;
  let cha_bonus = race.cha_bonus === 0 ? "" : "\nCHA Bonus: " + race.cha_bonus;
  let size = "\n" + race.size
  let saves = race.save_array === [] ? "" : "\nSaves: " + race.save_array;
  let profs = race.prof_array === [] ? "" : "\nProfs: " + race.prof_array;
  let weapon_profs = race.weapon_prof_array === [] ? "" : "\nWeapons: " + race.weapon_prof_array;
  let armor_profs = race.armor_prof_array === [] ? "" : "\nArmors: " + race.armor_prof_array
  return name
    + desc
    + str_bonus
    + int_bonus
    + dex_bonus
    + con_bonus
    + wis_bonus
    + cha_bonus
    + size
    + saves
    + profs
    + weapon_profs
    + armor_profs;
}

function show_class(dnd_class) {
  let name = dnd_class.name;
  let desc = dnd_class.desc === "" ? "" : "\nDesc: " + dnd_class.desc;
  let ability_modifier = "\nAbility Modifier: " + dnd_class.ability_modifier;
  let hit_die = "\nHit Die: 1d" + dnd_class.hit_die
  let saves = dnd_class.save_array === [] ? "" : "\nSaves: " + dnd_class.save_array;
  let profs = dnd_class.prof_array === [] ? "" : "\nProfs: " + dnd_class.prof_array;
  let weapon_profs = dnd_class.weapon_prof_array === [] ? "" : "\nWeapons: " + dnd_class.weapon_prof_array;
  let armor_profs = dnd_class.armor_prof_array === [] ? "" : "\nArmors: " + dnd_class.armor_prof_array
  return name
    + desc
    + ability_modifier
    + hit_die
    + saves
    + profs
    + weapon_profs
    + armor_profs;
}
