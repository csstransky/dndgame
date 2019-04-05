import React from 'react';
import ReactDOM from 'react-dom';
import _ from "lodash";


export default function dndgame_init(game, channel) {
  ReactDOM.render(<Dndgame channel={channel} />, game);
}
let WIDTH = 800;
let HEIGHT = 600;

class Dndgame extends React.Component {
  constructor(props) {
    super(props);

    this.channel = props.channel;
    this.state = {
      player: {
        name: "char",
        x: 10,
        y: 10,
        direction: 1,
      },
      other_characters: [
        {
          name: "char",
          x: 215,
          y: 150,
          direction: 3,
        },
        {
          name: "char",
          x: 315,
          y: 150,
          direction: 3,
        },
      ],
      characterIndex: 0,
      party: [
        {
          name: "char1",
          hp: 10,
          ac: 10,
          mp: 10,
          sp: 10,

          level: 10,
          exp: 10,
          initiative: 10,

          str: 10,
          dex: 10,
          int: 10,
          con: 10,
          wis: 10,
          cha: 10,

          weapon_name: "bow",
          weapon_attack_name: "shoot",

          armor_name: "metal",

          skills: [
            "skill1",
            "skill2",
            "skill3",
          ],

          spells: [
            "spell1",
            "spell2",
            "spell3",
          ],
        },
        {
          name: "char2",
          hp: 10,
          ac: 10,
          mp: 10,
          sp: 10,

          level: 10,
          exp: 10,
          initiative: 10,

          str: 10,
          dex: 10,
          int: 10,
          con: 10,
          wis: 10,
          cha: 10,

          weapon_name: "sward",
          weapon_attack_name: "slash",

          armor_name: "shield",

          skills: [
            "skill1",
            "skill2",
            "skill3",
          ],

          spells: [
            "spell1",
            "spell2",
            "spell3",
          ],
        },
        {
          name: "char3",
          hp: 10,
          ac: 10,
          mp: 10,
          sp: 10,

          level: 10,
          exp: 10,
          initiative: 10,

          str: 10,
          dex: 10,
          int: 10,
          con: 10,
          wis: 10,
          cha: 10,

          weapon_name: "bow",
          weapon_attack_name: "shoot",

          armor_name: "metal",

          skills: [
            "skill1",
            "skill2",
            "skill3",
          ],

          spells: [
            "spell1",
            "spell2",
            "spell3",
          ],
        }
      ],
      monsters: [
        {
          monster_name: "char",
          monster_attack: "spit",
          monster_hit: 10,
          hp: 10,
        },
        {
          monster_name: "char",
          monster_attack: "swipe",
          monster_hit: 10,
          hp: 10,
        },
        {
          monster_name: "char",
          monster_attack: "flame",
          monster_hit: 10,
          hp: 10,
        },
      ],
      boss: {
        posn: {
          x: 20,
          y: 20,
          direction: 2,
        },
      },
      turn: 1,
      weather: {
        wind: 15,
        visibility: 10,
        temperature: 65,
      },
      orderArray: [
        "char2",
        "monster1",
        "char1",
        "monster2",
        "char3",
        "monster3",
      ],
      orderIndex: 0,
      mainMenuOptions: [
        "Attack",
        "Skill",
        "Spell",
        "Run",
      ],
      mainMenuCurrentSelection: 0,
      subMenuOptions: [],
      subMenuCurrentSelection: 0,
      monsterCurrentSelection: 0,
      currentMenu: "main",
      battleAction: "Why does javascript suck so much, shit",
      buildMenuPath: [],
    };

    this.channel
      .join()
      .receive("ok", this.got_view.bind(this))
      .receive("error", resp => {
        console.log("Unable to join", resp);
      });
  }

  got_view(view) {
    this.setState(view.game);
  }

  componentDidMount() {
    this.drawDisplay();
    //this.interval = setInterval(() => this.setState(this.drawGameMap()), 50000);
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


  // Here's the big function for drawing the game world when character is not in battle
  drawGameMap() {
    //console.log(require('../static/standardWorld.png'));
    let canvas = this.refs.canvas;
    let ctx = canvas.getContext("2d");
    ctx.fillStyle = "#FFFFFF";
    ctx.strokeStyle = "#000000";
    ctx.strokeRect(0, 0, 1000, 600);
    ctx.fillRect(0, 0, 1000, 600);


    let drawing = new Image();
    drawing.src = require("../static/standardWorld.png");
    ctx.drawImage(drawing, 500,500);
    //drawing.src = "http://www.foster-douglas.com/img/games/755_Defining_Video_Game_Maps_1.jpg";


    let character = new Image();
    character.onload = function () {
      ctx.save(); //saves the state of canvas
      ctx.clearRect(0, 0, canvas.width, canvas.height); //clear the canvas
      ctx.translate(character.width, character.height); //let's translate
      ctx.rotate(Math.PI / 180 * (character.direction)); //increment the angle and rotate the image
      ctx.drawImage(character, character.x, character.y, 10, 10);
      ctx.restore(); //restore the state of canvas}
    };
    // character.src = require('./images/char.png');
    character.src = "https://cdn4.iconfinder.com/data/icons/cute-funny-monster-characters/66/35-512.png";


    let boss = new Image();
    boss.onload = function () {
      ctx.save(); //saves the state of canvas
      ctx.clearRect(0, 0, canvas.width, canvas.height); //clear the canvas
      ctx.translate(boss.width, boss.height); //let's translate
      ctx.rotate(Math.PI / 180 * (boss.direction)); //increment the angle and rotate the image
      ctx.drawImage(boss, boss.x, boss.y, 10, 10);
      ctx.restore(); //restore the state of canvas}
    };
    //boss.src = require('./images/char.png');
    boss.src = "https://cdn4.iconfinder.com/data/icons/cute-funny-monster-characters/66/35-512.png";


    console.log(this.state.other_characters);
    $.each(this.state.other_characters, function (index, value) {
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


    ctx.font = "10px Arial";
    ctx.fillText("Visibility:" + this.state.weather.visibility, 10, 50);
    ctx.fillText("Temp:" + this.state.weather.temperature, 10, 60);
    ctx.fillText("Wind:" + this.state.weather.wind, 10, 70);

    return canvas;

  };

  // Giant function for drawing the battle scene, as well as handling a little logic.
  drawBattleScreen() {
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
    var orderArray = this.state.orderArray;
    var orderIndex = this.state.orderIndex;
    var mainMenuCurrentSelection = this.state.mainMenuCurrentSelection;
    var subMenuOptions = this.state.subMenuOptions;
    var subMenuCurrentSelection = this.state.subMenuCurrentSelection;
    var currentMenu = this.state.currentMenu;
    var mainMenuOptions = this.state.mainMenuOptions;
    var monsters = this.state.monsters;
    var monsterCurrentSelection = this.state.monsterCurrentSelection;

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

      // This determines which menu to display, using the stored string in this.state.currentMenu, then draws it
      ctx.font = "25px Helvetica";
      if (orderArray[orderIndex] == value.name) {
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
    });

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
    console.log(ev.key);

    // First, check if "Enter" key has been received
    if (ev.key == "Enter") {
      this.selectMenu();
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
      <canvas id={"canvas"} ref="canvas" tabIndex={-1} width={1000} height={600} onKeyDown={this.onKeyDown.bind(this)}/>
    )
  }
}
