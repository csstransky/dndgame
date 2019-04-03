import React from 'react';
import ReactDOM from 'react-dom';
import _ from "lodash";

export default function breakout_pong_init(game, channel) {
    ReactDOM.render(<Dndgame channel={channel} />, game);
  ReactDOM.render(<Dndgame channel={channel}/>, game);
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
