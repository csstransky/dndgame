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
  // IMPORTANT TODO: I am a bunch of example code, you can use
  // me as a template, but make sure to delete me in the future
  $('#time-start-button').click((ev) => {
    var current_date =  new Date(Date.now());
    $('#time-start-text').text(current_date);
  });

  $('#race_select').click((ev) => {
    $.ajax({
      method: "GET",
      url: "/ajax/v1/races/" + $('#race_select').val(),
      dataType: "json",
      success: (resp) => {
        update_armors();
        console.log(resp);
        $('#HELLFIRE').text(show_race(resp.data));
      },
      error: (resp) => {
        console.log(resp)
      }
    });
  })

  $('#time-delete-button').click((ev) => {
    let time_block_id = $(ev.target).data('time-block-id')
    let time_block_path_delete = $(ev.target).data('delete-path');

    let text = JSON.stringify({
      id: time_block_id,
    });

    $.ajax(time_block_path_delete, {
      method: "post",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: text,
      success: (resp) => {
        console.log(resp);
        location.reload();
      },
      error: (resp) => {
        console.log(resp)
      }
    });
  });

  $('.time-update-button').click((ev) => {
    let task_id = $(ev.target).data('task-id');
    let time_block_id = $(ev.target).data('time-block-id')
    let row = $(ev.target).closest(".time-block-edit");
    let time_start = $(row.find("#time-block-start")).val();
    let time_end = $(row.find("#time-block-end")).val();
    let time_block_path_update = $(ev.target).data('update-path');

    console.log("je")
    let text = JSON.stringify({
      id: time_block_id,
      time_block: {
        time_start: time_start,
        time_end: time_end,
        task_id: task_id,
      },
    });

    $.ajax(time_block_path_update, {
      method: "put",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: text,
      success: (resp) => {
        $('.time-update-button').text("Time Updated");
        console.log(resp);
      },
      error: (resp) => {
        console.log(resp)
      }
    });
  });
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
    console.log(resp.data);
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
