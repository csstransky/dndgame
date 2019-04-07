import React from 'react';
import ReactDOM from 'react-dom';
import _ from "lodash";

// test line
export default function dndgame_init(game, channel) {
  ReactDOM.render(<Dndgame channel={channel} />, game);
}
let WIDTH = 1050;
let HEIGHT = 650;
let XOFFSET = 50;
let YOFFSET = 50;
let DAWNHOUR = 6;
let DUSKHOUR = 18;
let PLAYERX = 500;
let PLAYERY = 300;
let PLAYERSIZE = 50;
let MAPSIZE = 4000;
// 6AM
let earlyDate = Date.parse(new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate(), DAWNHOUR, 0, 0));
// 6PM
let lateDate = Date.parse(new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate(), DUSKHOUR, 0, 0));


class Dndgame extends React.Component {
  constructor(props) {
    super(props);

    this.channel = props.channel;
    this.state = {
      playerPosns: [],
      characterIndex: 0,
      party: [],
      monsters: [],
      boss: {},
      weather: {},
      orderArray: [],
      orderIndex: 0,
      mainMenuOptions: [],
      mainMenuCurrentSelection: 0,
      subMenuOptions: [],
      subMenuCurrentSelection: 0,
      monsterCurrentSelection: 0,
      currentMenu: "main",
      battleAction: "",
      buildMenuPath: [],
      timezone: 0
    };


    this.channel
      .join()
      .receive("ok", this.got_view.bind(this))
      .receive("error", resp => {
        console.log("Unable to join", resp);
      });

    this.channel.on("update", resp => {
      this.setState(resp)
    });
  }

  got_view(view) {
    console.log(view.game);
    this.setState(view.game);
  }

  componentDidMount() {
    let fps = 60;
    this.drawDisplay();
  }

  componentWillUnmount() {
    // no intervals, leaving empty for now
  }

  componentDidUpdate(prevProps, prevState, snapshot) {
    this.drawDisplay();
  }

  // This figures out what type of display to render in the canvas
  drawDisplay() {
    if (this.state.monsters.length == 0) {
      this.drawGameMap();
    } else {
      this.drawBattleScreen();
    }
  }

  // Parses through the chracter order array based on the current player index to determine the type of the next player
  determineCurrentPlayerType() {
    let currentPlayerString = this.state.orderArray[this.state.orderIndex]
    if (currentPlayerString[0] == "c") {
      return "character";
    } else {
      return "monster";
    }
  }

  // Parses through the character array to determine the index (within the character or monster array) of the next chracter
  determineCurrentPlayerIndex() {
    let currentPlayerString = this.state.orderArray[this.state.orderIndex]
    if (currentPlayerString[0] == "c") {
      return currentPlayerString[9];
    } else {
      return currentPlayerString[7];
    }
  }

  //ATTRIBUTION: function to calc timezeone
  // stackoverflow.com/questions/8201655/get-time-of-specific-timezone
  calcTime(offset) {
    var d = new Date();
    var utc = d.getTime() + (d.getTimezoneOffset() * 60000);
    var nd = new Date(utc + (3600000 * offset));
    return Date.parse(nd.toLocaleString());
  }

  // Here's the big function for drawing the game world when character is not in battle
  drawGameMap() {
    let canvas = this.refs.canvas;
    let ctx = canvas.getContext("2d");
    ctx.fillStyle = "#FFFFFF";
    ctx.strokeStyle = "#000000";
    ctx.strokeRect(0, 0, 1000, 600);
    ctx.fillRect(0, 0, 1000, 600);


    let drawing = new Image();

    // time calculations
    // current time, still need to do comparisons
    let date =  this.calcTime(this.state.timezone);

    ctx.drawImage(drawing, 0, 0, MAPSIZE, MAPSIZE);
    // DAY
    if (earlyDate < date && date < lateDate) {
      // snow
      if(this.state.weather.temperature < 30) {
        drawing.src = require("../static/snow_day.png");
      }
       // hot
      else if (this.state.weather.temperature > 90) {
        drawing.src = require("../static/hot_day.png");
      } // anything in between (day)
      else {
        drawing.src = require("../static/cool_day.png");
      }
    }
    else { // NIGHT
      if(this.state.weather.temperature < 20) {
        drawing.src = require("../static/snow_night.png");
      } // hot
      else if (this.state.weather.temperature > 80) {
        drawing.src = require("../static/hot_night.png");
      } // anything in between (day)
      else {
        drawing.src = require("../static/cool_night.png");
      }
    }

    let player = this.state.playerPosns[this.state.characterIndex];
    let direction;
    if (player != null) {

    direction = player.direction;
    ctx.drawImage(drawing, 0-player.x*50,0-player.y*50, MAPSIZE, MAPSIZE);
    let character = new Image();
    
    if (direction == "right") {
      character.src = require("../static/character/playerMoveRight.png");
    }
    else  if (direction == "left") {
      character.src = require("../static/character/playerMoveLeft.png");
    }
     else  if (direction == "up") {
      character.src = require("../static/character/playerMoveUp.png");
    }
    else  if (direction == "down") {
      character.src = require("../static/character/playerMoveDown.png");
    }

    ctx.drawImage(character, PLAYERX, PLAYERY, PLAYERSIZE, PLAYERSIZE);
    }
    /*character.onload = function () {
      ctx.save(); //saves the state of canvas
      ctx.clearRect(0, 0, canvas.width, canvas.height); //clear the canvas
      ctx.translate(character.width, character.height); //let's translate
      ctx.rotate(Math.PI / 180 * (character.direction)); //increment the angle and rotate the image
      ctx.drawImage(character, character.x, character.y, 10, 10);
      ctx.restore(); //restore the state of canvas}
    };*/




    /*let boss = new Image();
    boss.onload = function () {
      ctx.save(); //saves the state of canvas
      ctx.clearRect(0, 0, canvas.width, canvas.height); //clear the canvas
      ctx.translate(boss.width, boss.height); //let's translate
      ctx.rotate(Math.PI / 180 * (boss.direction)); //increment the angle and rotate the image
      ctx.drawImage(boss, boss.x, boss.y, 10, 10);
      ctx.restore(); //restore the state of canvas}
    };
    //boss.src = require('./images/char.png');
    //boss.src = "https://cdn4.iconfinder.com/data/icons/cute-funny-monster-characters/66/35-512.png";


    console.log(this.state.playerPosns);
    $.each(this.state.playerPosns, function (index, value) {
      let img = new Image();
      img.onload = function () {
        ctx.save(); //saves the state of canvas
        ctx.clearRect(0, 0, canvas.width, canvas.height); //clear the canvas
        ctx.translate(img.width, img.height); //let's translate
        ctx.rotate(Math.PI / 180 * (value.direction)); //increment the angle and rotate the image
        // img.src = "https://cdn4.iconfinder.com/data/icons/cute-funny-monster-characters/66/35-512.png";
        img.src = require('./images' + value.name + '.png');
        ctx.drawImage(img, value.x, value.y, 100, 100);
        ctx.restore(); //restore the state of canvas}
        img.src = require('./images' + value.name + '.png');
      };
    });

*/
    ctx.font = "25px Arial";
    ctx.fillText("Visibility:" + this.state.weather.visibility, 10,30);
    ctx.fillText("Temp:" + this.state.weather.temperature, 10, 65);
    ctx.fillText("Wind:" + this.state.weather.wind, 10, 100);

    return canvas;

  };

  // Giant function for drawing the battle scene, as well as handling a little logic.
  drawBattleScreen() {

    // There will be used later to render the appropriate menu
    let currentPlayerType = this.determineCurrentPlayerType();
    let currentPlayerIndex = this.determineCurrentPlayerIndex();

    // initialize canvas
    let canvas = this.refs.canvas;
    let ctx = canvas.getContext("2d");
    // x: 600, Y: 800
    ctx.clearRect(0, 0, 1000, 600);

    // screen setup
    ctx.rect(0, 0, 1000, 600);
    ctx.stroke();

    // divide up the bottom of the screen for menus
    ctx.beginPath();
    ctx.moveTo(0, 400);
    ctx.lineTo(1000, 400);
    ctx.stroke()

    ctx.beginPath();
    ctx.moveTo(333, 400);
    ctx.lineTo(333, 600);
    ctx.stroke();

    ctx.beginPath();
    ctx.moveTo(666, 400);
    ctx.lineTo(666, 600);
    ctx.stroke();

    // add a header area for attack description text
    ctx.beginPath();
    ctx.moveTo(0, 50);
    ctx.lineTo(1000, 50);
    ctx.stroke();

    // can't use a "this" within the each statements, so saving as var out here
    // not super elegant, and we can factor this out later, but it works decently
    // and I'm trying to get everything else to work first
    let orderArray = this.state.orderArray;
    let orderIndex = this.state.orderIndex;
    let mainMenuCurrentSelection = this.state.mainMenuCurrentSelection;
    let subMenuOptions = this.state.subMenuOptions;
    let subMenuCurrentSelection = this.state.subMenuCurrentSelection;
    let currentMenu = this.state.currentMenu;
    let mainMenuOptions = this.state.mainMenuOptions;
    let monsters = this.state.monsters;
    let monsterCurrentSelection = this.state.monsterCurrentSelection;
    let battleAction = this.state.battleAction

    // draw party on right of screen
    $.each(this.state.party, function (index, value) {

      // This area renders the actual images for the characters in party
      var img = new Image();
      img.addEventListener('load', function() {
        ctx.drawImage(img, (index * 333) + 260, 550, 50, 50);
      }, false);
      //img.src = require('./images/' + value.name + '.png');
      img.src = "https://cdn4.iconfinder.com/data/icons/cute-funny-monster-characters/66/35-512.png";

      // This determines if the given "option" number matches the currently selected menu option and returns
      // a " <-" string to append to that menu option to indicate it has been selected.
      function addSelection(type, option) {
        var x;
        switch (type ) {
          case "main":
            x = mainMenuCurrentSelection;
            break;
          case "sub":
            x = subMenuCurrentSelection;
            break;
          case "monster":
            x = monsterCurrentSelection;
            break;
        }
        if (option == x) {
          return " <-";
        } else {
          return "";
        }
      }


      // Wrapping this function in an if statement to only be triggered if it is a character's turn & statement string is empty
      if (currentPlayerType == "character" && battleAction == "") {

        // This determines which menu to display, using the stored string in this.state.currentMenu, then draws it
        ctx.font = "25px Helvetica";

        // Determines if the current player in the each loop is equal to the character who's turn it currently is
        if (currentPlayerIndex == index) {
          switch (currentMenu) {
            case "main":
              $.each(mainMenuOptions, function (index2, value2) {
                ctx.fillText(value2 + addSelection("main", index2), ((index * 333) + 5), ((index2 * 40) + 440));
              });
              break;
            case "sub":
              $.each(subMenuOptions, function (index2, value2) {
                ctx.fillText(value2 + addSelection("sub", index2), ((index * 333) + 5), ((index2 * 40) + 440));
              });
              break;
            case "monster":
              $.each(monsters, function (index2, value2) {
                ctx.fillText(addSelection("monster", index2), ((index2 * 333) + 220), 170);
              });
              break;
          }
        }
      }

      // Display the name and stats for this character
      ctx.font = "25px Ariel";
      ctx.fillText("HP:" + value.hp, ((index * 333) + 250), 420);
      ctx.fillText("MP:" + value.mp, ((index * 333) + 250), 450);
      ctx.fillText("SP:" + value.sp, ((index * 333) + 250), 480);
      ctx.font = "30px Ariel";
      ctx.fillText(value.name, ((index * 333) + 130), 395);

    });


    // Draw monsters on the screen
    $.each(this.state.monsters, function (index, value) {
      let img = new Image();
      img.addEventListener('load', function() {
        ctx.drawImage(img, ((index * 333) + 70), 100, 150, 150);
      }, false);
      // img.src = require('./images/' + value.name + '.png');
      img.src = "https://cdn4.iconfinder.com/data/icons/cute-funny-monster-characters/66/35-512.png";
      // stack party vertically based on order in array
      ctx.fillText("HP:" + value.hp, ((index * 333) + 110), 280);

      // Check if the current charcter's turn is a monster
      if (currentPlayerType == "monster") {
        // Check if the current character matches the index
        if (currentPlayerIndex == index) {
          // TODO: add some graphics here to indicate which monster is selected
        }
      }

    });

    if (!this.state.battleAction == "") {
      // TODO: show a "press any key to continue" message
    }

    // Draw the headline text describing what is happening in the game
    ctx.font = "25px Ariel";
    ctx.fillText(this.state.battleAction, 20, 40);
  return canvas;
  }







  /////////////////////////////
  /// INTERACTIVE FUNCTIONS ///
  /////////////////////////////

  // Receives the keyDown events and sorts based on menu
  onKeyDown(ev) {
    ev.preventDefault();
    let leftArrowCode = 37;
    let upArrowCode = 38;
    let rightArrowCode = 39;
    let downArrowCode = 40;
    console.log(ev.key);
    if (this.state.monsters.length == 0) {
      if (ev.key == "w" || ev.which == upArrowCode) {
        let newPlayerPosns = this.state.playerPosns.slice();
        this.channel.push("walk", "up").receive("ok", this.got_view.bind(this));
        this.drawDisplay();
      }
      else if (ev.key == "a" || ev.which == leftArrowCode) {
        let newPlayerPosns = this.state.playerPosns.slice();
        this.channel.push("walk", "left").receive("ok", this.got_view.bind(this));
        this.drawDisplay();
      }
      else if (ev.key == "s" || ev.which == downArrowCode) {
        let newPlayerPosns = this.state.playerPosns.slice();
        this.channel.push("walk", "down").receive("ok", this.got_view.bind(this));
        this.drawDisplay();
      }
      else if (ev.key == "d" || ev.which == rightArrowCode) {
        let newPlayerPosns = this.state.playerPosns.slice();
        this.channel.push("walk", "right").receive("ok", this.got_view.bind(this));
        this.drawDisplay();
      }

    }

    // If the battleAction string is not empty, the next key will be the "next" key
    if (!this.state.battleAction == "") {
      console.log("Sending an okay command after a battleAction string was displayed");
      this.channel.push("okay")
        .receive("ok", resp => {
          this.setState(resp.game);
        });
      return;
    }

    // First, check if "Enter" key has been received
    if (ev.key == "Enter") {
      this.selectMenu();
      return;
    } else {

      // If any other key than enter, check what menu we are in, and increment by one.
      switch (this.state.currentMenu) {
        case "main":
          // Iterate through the current menu selection
          this.setState((state, props) => ({
            mainMenuCurrentSelection: (state.mainMenuCurrentSelection + 1) % state.mainMenuOptions.length,
          }));
          console.log(this.state);
          break;
        case "sub":
          this.setState((state, props) => ({
            subMenuCurrentSelection: (state.subMenuCurrentSelection + 1) % state.subMenuOptions.length,
          }));
          console.log(this.state);
          break;
        case "monster":
          this.setState((state, props) => ({
            monsterCurrentSelection: (state.monsterCurrentSelection + 1) % state.monsters.length,
          }));
          break;
      }
    }
  }

  // This is the logic for tracking where in the menu system a player is, using an array to track historical selections
  // After "enter" is received when in the monster menu, the selected options are collected and sent to the server
  selectMenu() {

    // Before running the rest of this function, check if
    if (this.state.mainMenuCurrentSelection == 3) {
      this.runFromBattle();
      return;
    }

    // This uses the currently selected index and the menu + party to return an array of what the next subMenu contains
    function buildSubMenu (orderIndex, menuSelection, party) {
      switch (menuSelection) {
        case 0:
          return ["no options"];
        case 1:
          return party[orderIndex].skills;
        case 2:
          return party[orderIndex].spells;
        case 3:
          // There should never be an option 3 down here because of the if statement above, but leaving for testing
          return ["no options"];
      }
    }

    // Depending on the current menu, this switch will generate the next menu and modify the state accordingly
    switch (this.state.currentMenu) {
      case "main":
        this.setState((state, props) => ({
          mainMenuCurrentSelection: 0,
          subMenuCurrentSelection: 0,
          currentMenu: "sub",
          subMenuOptions: buildSubMenu(state.orderIndex, state.mainMenuCurrentSelection, state.party),
          buildMenuPath: [state.buildMenuPath.concat[state.mainMenuCurrentSelection]],
        }));
        console.log(this.state);
        break;
      case "sub":
        this.setState((state, props) => ({
          mainMenuCurrentSelection: 0,
          subMenuCurrentSelection: 0,
          currentMenu: "monster",
          buildMenuPath: [state.buildMenuPath.concat[state.subMenuCurrentSelection]],
        }));
        break;
      case "monster":
        console.log("pushing the final command down the channel...Yay!");
        console.log([this.state.buildMenuPath]);
        this.channel.push([{option: this.state.subMenuCurrentSelection[this.state.buildMenuPath[1]], monster: this.state.monsterCurrentSelection}])
          .receive("ok", resp => {
            this.setState(resp.game);
          });
    }
  }

  runFromBattle() {
    console.log("Player has run from battle, message has been sent through channel");
    this.channel.push("run")
      .receive("ok", resp => {
        this.setState(resp.game);
      });
  }




  // render function down here, just renders the canvas
  render() {
    return (
      <canvas id={"canvas"} ref="canvas" tabIndex={-1} width={WIDTH} height={HEIGHT} onKeyDown={this.onKeyDown.bind(this)}/>
    )
  }
}
