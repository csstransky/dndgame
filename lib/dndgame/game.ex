defmodule Dndgame.Game do
  def new do
    %{
      name: "",
      isLobby: true,
      lobbyList: [],
      playerOne: %{
        name: "",
        score: 0,
        paddleX: 10,
        paddleY: 245,
        ballX: 50,
        ballY: 300,
        ballSpeedX: Enum.random(5..7),
        ballSpeedY: Enum.random([-1, 1]) * Enum.random(5..7),
      },
      playerTwo: %{
        name: "",
        score: 0,
        paddleX: 770,
        paddleY: 245,
        ballX: 750,
        ballY: 300,
        ballSpeedX: -1 * Enum.random(5..7),
        ballSpeedY: Enum.random([-1, 1]) * Enum.random(5..7),
      },
      windowHeight: 600,
      windowWidth: 800,
      winScore: 50,
      blocks: [],
    }
  end

  def client_view(game) do
    %{
      isLobby: game.isLobby,
      lobbyList: game.lobbyList,
      player1: game.playerOne.name,
      player2: game.playerTwo.name,
      ball1x: game.playerOne.ballX,
      ball1y: game.playerOne.ballY,
      ball2x: game.playerTwo.ballX,
      ball2y: game.playerTwo.ballY,
      player1x: game.playerOne.paddleX,
      player1y: game.playerOne.paddleY,
      player2x: game.playerTwo.paddleX,
      player2y: game.playerTwo.paddleY,
      player1score: game.playerOne.score,
      player2score: game.playerTwo.score,
      windowWidth: Map.get(game, :windowWidth),
      windowHeight: Map.get(game, :windowHeight),
      blocks: Map.get(game, :blocks),
      winScore: game.winScore
    }
  end

end
