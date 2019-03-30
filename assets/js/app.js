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
  $('#time-end-button').click((ev) => {
    let task_id = $(ev.target).data('task-id');
    let time_start = $('#time-start-text').text();

    console.log(time_start)
    let text = JSON.stringify({
      time_block: {
        time_start: new Date(time_start),
        time_end: new Date(Date.now()),
        task_id: task_id,
      },
    });

    $.ajax(time_block_path_create, {
      method: "post",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: text,
      success: (resp) => {
        $('#time-start-end').text("Time updating...");
        location.reload();
      },
      error: (resp) => {
        console.log(resp)
      }
    });
  });

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
        console.log(resp);
        $('#HELLFIRE').text(resp.data.name);
      },
      error: (resp) => {
        console.log(resp)
      }
    });
  });

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
