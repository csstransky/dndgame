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

import socket from "./socket";
console.log(socket)
import dndgame_init from "./dndgame";

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

$(function () {
<<<<<<< HEAD
  let gameCanvas = document.getElementById('dndgame');
  if (gameCanvas) {
    let channel = socket.channel("games:" + window.gameName,
      {user: window.playerName,
        partyId1: window.partyId1,
        partyId2: window.partyId2,
        partyId3: window.partyId3});
    dndgame_init(gameCanvas, channel);
  }

  $('.world-location').click((ev) => {
    console.log(ev.target)
    $('#world_name').val(ev.target.id)
  })
=======
  let game = document.getElementById('dndgame');
  console.log("getting element")
  if (game) {
    let channel = socket.channel("games:" + "test", {user: "tuck"});
    dndgame_init(game, channel);
  }

>>>>>>> canvas

  $('#roll').click((ev) => {
    update_stats();
  });

  $('#race_select').click((ev) => {
    $.ajax({
      method: "GET",
      url: "/ajax/v1/races/" + $('#race_select').val(),
      dataType: "json",
      success: (resp) => {
        update_armors();
        update_weapons();
        update_stats();
        $('#HELLFIRE').empty()
        $('#HELLFIRE').append(show_race(resp.data));
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
        update_weapons();
        update_stats();
        $('#HELLFIRE').empty()
        $('#HELLFIRE').append(show_class(resp.data));
      },
      error: (resp) => {
        console.log(resp)
      }
    });
  });

  $('#armor_select').click((ev) => {
    $.ajax({
      method: "GET",
      url: "/ajax/v1/armors/" + $('#armor_select').val(),
      dataType: "json",
      success: (resp) => {
        update_stats();
        $('#HELLFIRE').empty()
        $('#HELLFIRE').append(show_armor(resp.data));
      },
      error: (resp) => {
        console.log(resp)
      }
    });
  });

  $('#weapon_select').click((ev) => {
    $.ajax({
      method: "GET",
      url: "/ajax/v1/weapons/" + $('#weapon_select').val(),
      dataType: "json",
      success: (resp) => {
        update_stats();
        $('#HELLFIRE').empty()
        $('#HELLFIRE').append(show_weapon(resp.data));
      },
      error: (resp) => {
        console.log(resp)
      }
    });
  });
});

function update_stats() {
  let race_id = $('#race_select').val()
  let class_id = $('#class_select').val()
  let armor_id = $('#armor_select').val()
  let weapon_id = $('#weapon_select').val()
  let dex = $('#dex').val()
  let con = $('#con').val()
  let url = "/ajax/v1/stats/?race_id=" + race_id
    + "&class_id=" + class_id
    + "&dex=" + dex
    + "&con=" + con
    + "&armor_id=" + armor_id
    + "&weapon_id=" + weapon_id;
  $.ajax({
    method: "GET",
    url: url,
    dataType: "json",
    success: (resp) => {
      $('#hp').text(resp.data.hp)
      $('#mp').text(resp.data.mp)
      $('#sp').text(resp.data.sp)
      $('#ac').text(resp.data.ac)
      $('#initiative').text(resp.data.initiative)
    },
    error: (resp) => {
      console.log(resp)
    }
  });
}

// TODO, fix this to get the rid parameters into
function update_armors() {
  let race_id = $('#race_select').val()
  let class_id = $('#class_select').val()
  let strength = $('#str').val()
  let url = "/ajax/v1/select_armors/?race_id="
    + race_id +"&class_id=" + class_id + "&str=" + strength;
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

function update_weapons() {
  let race_id = $('#race_select').val()
  let class_id = $('#class_select').val()
  let url = "/ajax/v1/select_weapons/?race_id=" + race_id +"&class_id=" + class_id
  $.ajax({
    method: "GET",
    url: url,
    dataType: "json",
    success: (resp) => {
      $('#weapon_select').empty()
      let weapon_list = resp.data;
      $.each(weapon_list, function (index, weapon) {
        $('#weapon_select').append($('<option/>', {
          value: weapon.id,
          text: weapon.name
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
  let name = "<h2><u>" + race.name + "</u></h2>";
  let desc = race.desc === "" ? "" : "<b>Desc:</b> " + race.desc;
  let str_bonus = race.str_bonus === 0 ? "" : "<b>STR Bonus:</b> " + race.str_bonus + "</br>";
  let dex_bonus = race.dex_bonus === 0 ? "" : "<b>DEX Bonus:</b> " + race.dex_bonus + "</br>";
  let int_bonus = race.int_bonus === 0 ? "" : "<b>INT Bonus:</b> " + race.int_bonus + "</br>";
  let con_bonus = race.con_bonus === 0 ? "" : "<b>CON Bonus:</b> " + race.con_bonus + "</br>";
  let wis_bonus = race.wis_bonus === 0 ? "" : "<b>WIS Bonus:</b> " + race.wis_bonus + "</br>";
  let cha_bonus = race.cha_bonus === 0 ? "" : "<b>CHA Bonus:</b> " + race.cha_bonus + "</br>";
  let size = race.size === 0 ? "<b>Size:</b> Medium<br/>" : "<b>Size:</b> Small<br/>"
  let saves = race.save_array.length === 0 ? "" : "<b>Saves:</b> " + show_list(race.save_array) + "<br/>";
  let profs = race.prof_array.length === 0 ? "" : "<b>Profs:</b> " + show_list(race.prof_array) + "<br/>";
  let weapon_profs = race.weapon_prof_array.length === 0? "" : "<b>Weapons:</b> " + show_list(race.weapon_prof_array) + "<br/>";
  let armor_profs = race.armor_prof_array.length === 0 ? "" : "<b>Armors:</b> " + show_list(race.armor_prof_array) + "<br/>";
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
  let name = "<h2><u>" + dnd_class.name + "</u></h2>";
  let desc = dnd_class.desc === "" ? "" : "<b>Desc:</b> " + dnd_class.desc + "<br/>";
  let ability_modifier = "<b>Ability Modifier:</b> " + dnd_class.ability_modifier + "<br/>";
  let hit_die = "<b>Hit Die:</b> 1d" + dnd_class.hit_die + "<br/>";
  let saves = dnd_class.save_array.length === 0 ? "" : "<b>Saves:</b> " + show_list(dnd_class.save_array) + "<br/>";
  let profs = dnd_class.prof_array.length === 0 ? "" : "<b>Profs:</b> " + show_list(dnd_class.prof_array) + "<br/>";
  let weapon_profs = dnd_class.weapon_prof_array.length === 0 ? "" : "<b>Weapons:</b> " + show_list(dnd_class.weapon_prof_array) + "<br/>";
  let armor_profs = dnd_class.armor_prof_array.length === 0 ? "" : "<b>Armors:</b> " + show_list(dnd_class.armor_prof_array) + "<br/>";
  let skills = dnd_class.skills.length === 0 ? "" : "<b>Skills:</b> " + show_abilities(dnd_class.skills) + "<br/>";
  let spells = dnd_class.spells.length === 0 ? "" : "<b>Spells:</b> " + show_abilities(dnd_class.spells) + "<br/>";
  return name
    + desc
    + ability_modifier
    + hit_die
    + saves
    + profs
    + weapon_profs
    + armor_profs
    + skills
    + spells;
}

function show_weapon(weapon) {
  let name = "<h2><u>" + weapon.name + "</u></h2>";
  let desc = weapon.desc === "" ? "" : "<b>Desc:</b> " + weapon.desc + "<br/>";
  let category = "<b>Category:</b> " + weapon.weapon_category + "<br/>";
  let dmg_die = "<b>Damage Dice:</b> " + weapon.attack.damage_dice + "<br/>";
  let dmg_type = "<b>Damage Type:</b> " + weapon.attack.type + "<br/>";
  return name
    + desc
    + category
    + dmg_die
    + dmg_type;
}

function show_armor(armor) {
  console.log(armor)
  let name = "<h2><u>" + armor.name + "</u></h2>";
  let desc = armor.desc === "" ? "" : "<b>Desc:</b> " + armor.desc + "<br/>";
  let category = "<b>Category:</b> " + armor.armor_category + "<br/>";
  let base = "<b>Base AC:</b> " + armor.base + "<br/>";
  let dex_bonus = armor.max_dex_bonus > 90 ? "<b>Max DEX Bonus:</b> No Limit<br/>" : "<b>Max DEX Bonus:</b> " + armor.max_dex_bonus + "<br/>"
  let stealth_disadvantage = armor.stealth_disadvantage ? "<b>Stealth Disadvantage:</b> Yes<br/>" : "<b>Stealth Disadvantage:</b> No<br/>"
  let str_min = armor.str_minimum ? "<b>STR Minimum:</b> " + armor.str_minimum + "<br/>" : ""
  return name
    + desc
    + category
    + base
    + dex_bonus
    + stealth_disadvantage;
}

function show_list(string_array) {
  let list = "";
  for (var ii in string_array) {
    list += "<br/>+ " + string_array[ii];
  }
  return list;
}

function show_abilities(ability_array) {
  let ability_names = ability_array.map(ability => ability.name);
  return show_list(ability_names);
}
