import React from 'react';
import ReactDOM from 'react-dom';
import _ from "lodash";

export default function dndgame_init(game, channel) {
  ReactDOM.render(<Dndgame channel={channel} />, game);
  ReactDOM.render(<Dndgame channel={channel} />, game);
}

class Dndgame extends React.Component {
  constructor(props) {
    super(props);

    this.channel = props.channel;
    this.state = {
      isLobby: true,
      lobbyList: ["Loading lobby..."],
      winScore: 50,
      player1: "",
      player2: "",
      ball1x: 100,
      ball1y: 120,
      ball2x: 700,
      ball2y: 120,
      player1x: 10,
      player1y: 5,
      player2x: 770,
      player2y: 5,
      player1score: 0,
      player2score: 0,
      windowHeight: 600,
      windowWidth: 800,
      blocks: [
        {x: 310, y: 1, hp: 1},
        {x: 350, y: 1, hp: 2},
        {x: 390, y: 1, hp: 4},
        {x: 430, y: 1, hp: 2},
        {x: 470, y: 1, hp: 1},
        {x: 310, y: 100, hp: 1},
        {x: 350, y: 100, hp: 2},
        {x: 390, y: 100, hp: 4},
        {x: 430, y: 100, hp: 2},
        {x: 470, y: 100, hp: 1},
        {x: 310, y: 200, hp: 1},
        {x: 350, y: 200, hp: 2},
        {x: 390, y: 200, hp: 4},
        {x: 430, y: 200, hp: 2},
        {x: 470, y: 200, hp: 1},
        {x: 310, y: 300, hp: 1},
        {x: 350, y: 300, hp: 2},
        {x: 390, y: 300, hp: 4},
        {x: 430, y: 300, hp: 2},
        {x: 470, y: 300, hp: 1},
        {x: 310, y: 400, hp: 1},
        {x: 350, y: 400, hp: 2},
        {x: 390, y: 400, hp: 4},
        {x: 430, y: 400, hp: 2},
        {x: 470, y: 400, hp: 1},
        {x: 310, y: 499, hp: 1},
        {x: 350, y: 499, hp: 2},
        {x: 390, y: 499, hp: 4},
        {x: 430, y: 499, hp: 2},
        {x: 470, y: 499, hp: 1}]
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

  componentDidMount() {
    this.draw_canvas();
  }

  componentWillUnmount() {
      // no intervals, leaving empty for now
  }
  // ******************************** IMPORTANT *******************************
  // TODO: During the inevitable merge, make sure to just completely accept the
  // new file and delete this one. I'm just keeping this so I have something to play with.

  // main view drawing function
  draw_canvas() {

      // things we need to draw:
      // map
      // underneath map(?), party status -- 4 squares with player info
      //


      let canvas = this.refs.canvas;
      let ctx = canvas.getContext("2d");
      ctx.strokeStyle = "#000000";

      // clear the canvas
      ctx.clearRect(0,0, WIDTH, HEIGHT);

      // map outline
      // just an empty rectangle for now -- assuming it will possibly be some type of colored grid eventually
      ctx.fillStyle = "#808080";
      ctx.strokeRect(0, 0, 1000, 1000);
      ctx.fillRect(0, 0, 1000, 1000);

      // Party graphics
      // four rectangles with information

      // first character
      ctx.fillStyle = "#808080";
      ctx.strokeRect(0, 1100, 400, 400);
      ctx.fillRect(0, 1100, 400, 400);

      // second character
      ctx.fillStyle = "#808080";
      ctx.strokeRect(500, 1100, 400, 400);
      ctx.fillRect(500, 1100, 400, 400);

      // third character
      ctx.fillStyle = "#808080";
      ctx.strokeRect(900, 0, 400, 400);
      ctx.fillRect(900, 0, 400, 400);

      // fourth character
      ctx.fillStyle = "#808080";
      ctx.strokeRect(1300, 1100, 400, 400);
      ctx.fillRect(1300, 1100, 1000, 400);

  }
}
