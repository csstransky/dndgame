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
let BOSSNAME = "young green dragon"

class Dndgame extends React.Component {
  constructor(props) {
    super(props);

    this.channel = props.channel;
    this.state = {
      playerPosns: [],
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
      timezone: 0,
      battleOverArray: [],
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
    if ((this.state.monsters.length == 0) && (this.state.battleOverArray.length <= 0)) {
      this.drawGameMap();
    } else {
      this.drawBattleScreen();
    }
  }

  // Parses through the chracter order array based on the current player index to determine the type of the next player
  determineCurrentPlayerType() {
    let currentPlayerString = this.state.orderArray[this.state.orderIndex]
    if (currentPlayerString.charAt(0) == "c") {
      return "character";
    } else {
      return "monster";//todo change back to monster
    }
  }//lol

  // Parses through the character array to determine the index (within the character or monster array) of the next chracter
  determineCurrentPlayerIndex() {
    let currentPlayerString = this.state.orderArray[this.state.orderIndex]
    if (currentPlayerString.charAt(0) == "c") {
      return currentPlayerString.charAt(9);
    } else {
      return currentPlayerString.charAt(7);
    }
  }

  //ATTRIBUTION: function to calc timezeone
  // stackoverflow.com/questions/8201655/get-time-of-specific-timezone
  calcTime(offset) {
    var d = new Date();
    var utc = d.getTime() + (d.getTimezoneOffset() * 60000);
    var nd = new Date(utc + (3600000 * offset));
    console.log(nd.toLocaleString());
    //return Date.parse(nd.toLocaleString()); # TODO use this for clock
    return nd;
  }

  getDisplayTime() {
    let time = this.calcTime(this.state.timezone)
    if (time.getHours() > 12) {
      if (time.getMinutes() < 10) {
        return (time.getHours() - 12) + ":0" + time.getMinutes() + " pm";
      } else {
        return (time.getHours() - 12) + ":" + time.getMinutes() + " pm";
      }
       return
    } else {
      if (time.getMinutes() < 10) {
        return time.getHours() + ":0" + time.getMinutes() + " am";
      } else {
        return time.getHours() + ":" + time.getMinutes() + " am";
      }
    }
  }

  // Here's the big function for drawing the game world when character is not in battle
  drawGameMap() {
    console.log(this.state);
    let canvas = this.refs.canvas;
    let ctx = canvas.getContext("2d");
    //ctx.clearRect(0, 0, WIDTH, HEIGHT);
    //ctx.fillStyle = "#FFFFFF";
    //ctx.strokeStyle = "#000000";
    //ctx.fillRect(0, 0, WIDTH, HEIGHT);

    let drawing = this.getEnvironmentMap();
    let player = this.state.playerPosns[this.state.playerIndex];
    let direction;

    // This should be changed to to a closure statement b/c super inefficient,
    // but leaving this for now
    let visibility = this.state.weather.visibility;
    let temp = this.state.weather.temperature;
    let wind = this.state.weather.wind;

    let displayTime = this.getDisplayTime();

    if (player != null) {
      drawing.onload = function() {
        ctx.drawImage(drawing, 0-player.x*50,0-player.y*50, MAPSIZE, MAPSIZE);
        ctx.globalAlpha = 0.75;
        ctx.font = "25px Arial";
        ctx.fillStyle = "#70a4be";
        ctx.fillRect(0, 0, 220, 150);
        ctx.stroke();
        ctx.globalAlpha = 1;
        ctx.fillStyle = "#FFFFFF";
        ctx.fillText("VSBY: " + visibility + " Miles", 10,30);
        ctx.fillText("Temp: " + temp + "°F", 10, 65);
        ctx.fillText("Wind: " + wind + " MPH", 10, 100);
        ctx.fillText("Time: "+ displayTime, 10, 135);
      };
    let bossDrawing = new Image();
    bossDrawing.onload = function () {
      ctx.drawImage(bossDrawing, 0-player.x*50,0-player.y*50, PLAYERSIZE, PLAYERSIZE);
    };
    bossDrawing.src = require("../static/monsters/dragonBossMapSprite.png");


    var mainCharacter = this.state.playerPosns[this.state.playerIndex];
    for (let i = 0; i < this.state.playerPosns.length; i++) {
      let character = new Image();
      let currplayer = this.state.playerPosns[i];
      direction = currplayer.direction;
      switch (direction){
        case "right":
          character.src = require("../static/character/playerMoveRight.png");
          break;
        case "left":
          character.src = require("../static/character/playerMoveLeft.png");
          break;
        case "up":
          character.src = require("../static/character/playerMoveUp.png");
          break;
        case "down":
          character.src = require("../static/character/playerMoveDown.png");
          break;
        default:
          console.log("broken");
          break;
      }
      if (this.state.playerIndex === i) {
        character.onload = function() {
          ctx.drawImage(character, PLAYERX, PLAYERY, PLAYERSIZE, PLAYERSIZE);
        };
      } else {
        let diffDistanceX = mainCharacter.x - currplayer.x;
        let diffDistanceY = mainCharacter.y - currplayer.y;
        let date = this.calcTime(this.state.timezone)
        character.onload = function() {
          // DAY
          if (DAWNHOUR <= date.getHours() && date.getHours() <= DUSKHOUR) {
            // DAY
            ctx.fillStyle = "#000000";
          } else {
            ctx.fillStyle = "#FFFFFF";
          }
          ctx.drawImage(character, PLAYERX - (diffDistanceX * PLAYERSIZE),
            PLAYERY - (diffDistanceY * PLAYERSIZE), PLAYERSIZE, PLAYERSIZE);
          ctx.fillText(currplayer.name,
            (PLAYERX - (diffDistanceX * PLAYERSIZE)),
            (PLAYERY - (diffDistanceY * PLAYERSIZE)));
        };
      }
    }

    }


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

    return canvas;

  };

  getEnvironmentMap() {
    let drawing = new Image();
    let offset = this.state.timezone;
    this.calcTime(offset)
    // time calculations
    // current time, still need to do comparisons
    let date =  this.calcTime(this.state.timezone);

    // DAY
    if (DAWNHOUR <= date.getHours() && date.getHours() <= DUSKHOUR) {
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
    return drawing;
  }

  // Giant function for drawing the battle scene, as well as handling a little logic.
  drawBattleScreen() {
    console.log(this.state);

    // There will be used later to render the appropriate menu
    let currentPlayerType = this.determineCurrentPlayerType();
    let currentPlayerIndex = this.determineCurrentPlayerIndex();

    // initialize canvas
    let canvas = this.refs.canvas;
    let ctx = canvas.getContext("2d");
    // x: 600, Y: 800
    ctx.clearRect(0, 0, WIDTH, HEIGHT);

    let drawing = this.getEnvironmentMap();
    let player = this.state.playerPosns[this.state.playerIndex];
    ctx.drawImage(drawing, 0-player.x*50,0-player.y*50, MAPSIZE, MAPSIZE);
    ctx.stroke();

    // Top background for header
    ctx.fillStyle = "#70a4be";
    ctx.fillRect(0, 0, 1050, 50);
    ctx.stroke();

    // Bottom background for party
    ctx.fillRect(0, 400, 1050, 650);
    ctx.stroke();

    // divide up the bottom of the screen for menus

    // screen setup
    let date =  this.calcTime(this.state.timezone);

    // DAY
    if (DAWNHOUR <= date.getHours() && date.getHours() <= DUSKHOUR) {
      // DAY
      ctx.fillStyle = "#000000";
    }
    else {
      ctx.fillStyle = "#FFFFFF";
    }
    ctx.rect(0, 0, 1050, 650);
    ctx.stroke();
    // add a header area for attack description text
    ctx.beginPath();
    ctx.moveTo(0, 50);
    ctx.lineTo(1050, 50);
    ctx.stroke();


    // divide up the bottom of the screen for menus
    ctx.beginPath();
    ctx.moveTo(350, 400);
    ctx.lineTo(350, 645);
    ctx.stroke();

    ctx.beginPath();
    ctx.moveTo(700, 400);
    ctx.lineTo(700, 650);
    ctx.stroke();

    ctx.beginPath();
    ctx.moveTo(0, 400);
    ctx.stroke()

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
    let spaceBuffer = WIDTH / (this.state.monsters.length + 1);

    // draw party on right of screen
    $.each(this.state.party, function (index, value) {

      // This determines if the given "option" number matches the currently selected menu option and returns
      // a " <-" string to append to that menu option to indicate it has been selected.
      function addSelection(type, option) {
        var x;
        switch (type) {
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
      if (currentPlayerType == "character") {
         // This determines which menu to display, using the stored string in this.state.currentMenu, then draws it
        ctx.font = "25px Helvetica";

        // Determines if the current player in the each loop is equal to the character who's turn it currently is
        if (currentPlayerIndex == index) {
          switch (currentMenu) {
              case "main":
                $.each(mainMenuOptions, function (index2, value2) {
                ctx.fillText(value2 + addSelection("main", index2), ((index * 333) + 50), ((index2 * 40) + 440));
              });
              break;
            case "sub":
              $.each(subMenuOptions, function (index2, value2) {
                ctx.fillText(value2 + addSelection("sub", index2), ((index * 333) + 50), ((index2 * 40) + 440));
              });
              break;
            case "monster":
              $.each(monsters, function (index2, value2) {
                ctx.fillText(addSelection("monster", index2), ((spaceBuffer) * (index2 + 1)) + 150, 170);
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

    function getMonsterImage(monster) {
      switch (monster.name.toLowerCase()){
        case "goblin":
          return require("../static/monsters/goblin.png");
        case "fire goblin":
          return require("../static/monsters/fireGoblin.png");
        case "ice goblin":
          return require("../static/monsters/iceGoblin.png");
        case "zombie":
          return require("../static/monsters/zombie.png");
        case "fire zombie":
          return require("../static/monsters/fireZombie.png");
        case "ice zombie":
          return require("../static/monsters/iceZombie.png");
        case "young green dragon":
          return require("../static/monsters/dragonBossBattleSprite.png");
        default:
          console.log("monster does not have image loaded for it");
          return null;
      }
    }




      // Draw monsters on the screen
      $.each(this.state.monsters, function (monsterIndex, monster) {
        let img = new Image();
        img.addEventListener('load', function () {
          if (monster.name.toLowerCase() == BOSSNAME) {
            ctx.drawImage(img, 350, 50, 350, 350);
            // stack party vertically based on order in array
            ctx.fillText("HP:" + monster.hp, 660, 250);
          } else {
            ctx.drawImage(img, ((monsterIndex + 1) * spaceBuffer), 100, 150, 150);
            // stack party vertically based on order in array
            ctx.fillText("HP:" + monster.hp, ((monsterIndex + 1) * spaceBuffer), 280);
          }
        }, false);

        img.src = getMonsterImage(monster);


        // Check if the current charcter's turn is a monster
        if (currentPlayerType == "monster") {
          // Check if the current character matches the monsterIndex
          if (currentPlayerIndex == monsterIndex) {
            // TODO: add some graphics here to indicate which monster is selected
          }
        }

      });


    if (!this.state.battleAction == "" && (this.determineCurrentPlayerType() == "monster")) {
      ctx.font = "35px Ariel";
      ctx.fillText("Press Enter to continue", 710, 82);

    }

    // Draw the headline text describing what is happening in the game
    ctx.font = "25px Ariel";
    ctx.fillText(this.state.battleAction, 20, 40);


    if (this.state.battleOverArray[0]) {
      console.log("BattleOverArray");
      ctx.fillStyle = "#000000";
      ctx.fillStyle = "#ac0200";
      ctx.fillRect(235, 350, 600, 150);
      ctx.strokeRect(235,350,600,150);
      ctx.stroke();
      ctx.fillStyle = "#000000";
      ctx.font = "30px Verdana";
      if (this.state.battleOverArray[0]) {
        ctx.fillText(this.state.battleOverArray[0], 245,390);
      }
      if (this.state.battleOverArray[1]) {
        ctx.fillText(this.state.battleOverArray[1], 245,420);
      }
      if (this.state.battleOverArray[2]) {
        ctx.fillText(this.state.battleOverArray[2], 245,450);

      }
      if (this.state.battleOverArray[3]) {
        ctx.fillText(this.state.battleOverArray[3], 245,480);

      }
      ctx.fillStyle = "#ffffff";

      ctx.font = "35px Ariel";
      ctx.fillText("Press Enter to continue", 710, 82);

      // DAY
      if (DAWNHOUR <= date.getHours() && date.getHours() <= DUSKHOUR) {
        // DAY
        ctx.fillStyle = "#000000";
      } else {
        ctx.fillStyle = "#FFFFFF";
      }

    }


    return canvas;
  }


  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////// INTERACTIVE FUNCTIONS ///////////////////////////
  /////////////////////////////////////////////////////////////////////////////

  // Receives the keyDown events and sorts based on menu
  onKeyDown(ev) {

    if ((!this.state.battleOverArray.length <= 0) && (ev.key = "Enter")) {
      this.setState((state, props) => ({
        battleOverArray: [],
      }));
      return;
    };

    ////////////////////////////////
    // WORLD NAVIGATION FUNCTIONS //
    ////////////////////////////////
    ev.preventDefault();
    let leftArrowCode = 37;
    let upArrowCode = 38;
    let rightArrowCode = 39;
    let downArrowCode = 40;
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

    //////////////////////
    // BATTLE FUNCTIONS //
    //////////////////////
    if (ev.key == "Escape") {
      this.runFromBattle();
    }


    if (ev.key == "Enter") {

      // If the battleAction string is not empty, the next key will be the "next" key
      if (!this.state.battleAction == "") {
        if (this.determineCurrentPlayerType() == "monster") {

          console.log("Sending monster attack command" + this.determineCurrentPlayerIndex());
          this.channel.push("enemy_attack", this.determineCurrentPlayerIndex(),)
            .receive("ok", resp => {
              this.setState(resp.game);
            });
          this.setState((state, props) => ({
            battleAction: "",
          }));
          return;
        }
      }
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
          break;
        case "sub":
          this.setState((state, props) => ({
            subMenuCurrentSelection: (state.subMenuCurrentSelection + 1) % state.subMenuOptions.length,
          }));
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
          let temp = [];
          $.each(party[orderIndex].skills, function ( index, value ) {
            temp.push(value.name);
          });
          return temp;
        case 2:
          let temp2 = [];
          $.each(party[orderIndex].spells, function ( index, value ) {
            temp2.push(value.name);
          });
          return temp2;
        case 3:
          // There should never be an option 3 down here because of the if statement above, but leaving for testing
          return ["no options"];
      }
    }

    // Depending on the current menu, this switch will generate the next menu and modify the state accordingly
    switch (this.state.currentMenu) {
      case "main":
        if (this.state.mainMenuCurrentSelection == 0) {
          this.setState((state, props) => ({
            buildMenuPath: state.buildMenuPath.concat([0]).concat([state.mainMenuCurrentSelection]),
            // mainMenuCurrentSelection: 0,
            //subMenuCurrentSelection: 0,
            currentMenu: "monster",
          }));
          return;
        }
        // Check if character has enough mp and sp to perform spells
        if ((this.state.party[this.determineCurrentPlayerIndex()].mp <= 0) && (this.state.mainMenuCurrentSelection == 2)) {
          this.setState((state, props) => ({
            battleAction: "Not enough MP for "  + state.mainMenuOptions[state.mainMenuCurrentSelection] + " right now.",
          }));
          return;
        }

        // Check if character has enough mp and sp to perform spells
        if ((this.state.party[this.determineCurrentPlayerIndex()].sp <= 0) && (this.state.mainMenuCurrentSelection == 1)) {
          this.setState((state, props) => ({
            battleAction: "Not have enough SP for " + state.mainMenuOptions[state.mainMenuCurrentSelection] + " right now.",
          }));
          return;
        }
        else {
          this.setState((state, props) => ({
            buildMenuPath: state.buildMenuPath.concat([state.mainMenuCurrentSelection]),
            // mainMenuCurrentSelection: 0,
            //subMenuCurrentSelection: 0,
            currentMenu: "sub",
            subMenuOptions: buildSubMenu(this.determineCurrentPlayerIndex(), state.mainMenuCurrentSelection, state.party),
          }));
        }
        break;
      case "sub":
        this.setState((state, props) => ({
          //mainMenuCurrentSelection: 0,
          //subMenuCurrentSelection: 0,
          currentMenu: "monster",
          buildMenuPath: state.buildMenuPath.concat([state.subMenuCurrentSelection]),
        }));
        break;
      case "monster":
        // If player has selected attack
        if (this.state.buildMenuPath[0] == 0) {
          console.log("calling player attack");
          this.playerAttack();
        }

        // If player has selected spell
        if (this.state.buildMenuPath[0] == 1) {
          console.log("calling player skill");
          this.playerSkill();
        }

        // If player has selected skill
        if (this.state.buildMenuPath[0] == 2) {
          console.log("calling player spell");
          this.playerSpell();
        }
        break;
    }
  }

  runFromBattle() {
    console.log("Player has run from battle, message has been sent through channel");
    this.channel.push("run")
      .receive("ok", resp => {
        this.setState(resp.game);
      });
  }

  playerAttack() {
    console.log("Sending player attack command through channel: "+ this.state.monsterCurrentSelection);
    this.channel.push("attack", this.state.monsterCurrentSelection)
      .receive("ok", resp => {
        this.setState(resp.game);
      });
  }

  playerSpell() {
    console.log("Sending spell command");
    console.log(this.state.buildMenuPath[1]);
    console.log(this.state.monsterCurrentSelection);
    this.channel.push("use_spell", {spellId: this.state.buildMenuPath[1], enemyIndex: this.state.monsterCurrentSelection})
      .receive("ok", resp => {
        this.setState(resp.game);
      });
  }

  playerSkill() {
    console.log("Sending skill command");
    console.log(this.state.buildMenuPath[1]);
    console.log(this.state.monsterCurrentSelection);
    this.channel.push("use_skill", {skillId: this.state.buildMenuPath[1], enemyIndex: this.state.monsterCurrentSelection})
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
