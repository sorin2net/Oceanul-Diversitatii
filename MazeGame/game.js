class Game {
  constructor(mazeData) {
    this.maze = mazeData;
    this.player = { x: 0, y: 0 };
    this.goal = { x: this.maze.width - 1, y: this.maze.height - 1 };
    this.canvas = document.getElementById('gameCanvas');
    this.ctx = this.canvas.getContext('2d');
    this.canvas.width = this.maze.width * 20;
    this.canvas.height = this.maze.height * 20;
    this.intervalId = null;
    this.gameOver = false;
    this.moves = 0;
  }

  init() {
    this.drawMaze();
    this.drawPlayer();
  }

  drawMaze() {
    this.ctx.fillStyle = 'black';
    this.ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);
    this.ctx.fillStyle = 'white';
    for (let y = 0; y < this.maze.height; y++) {
      for (let x = 0; x < this.maze.width; x++) {
        if (this.maze.data[y][x] === 0) {
          this.ctx.fillRect(x * 20, y * 20, 20, 20);
        }
      }
    }
  }

  drawPlayer() {
    this.ctx.fillStyle = 'blue';
    this.ctx.fillRect(this.player.x * 20, this.player.y * 20, 20, 20);
  }

  movePlayer(dx, dy) {
    const newX = this.player.x + dx;
    const newY = this.player.y + dy;
    if (newX >= 0 && newX < this.maze.width && newY >= 0 && newY < this.maze.height && this.maze.data[newY][newX] === 0) {
      this.player.x = newX;
      this.player.y = newY;
      this.moves++;
      this.drawMaze();
      this.drawPlayer();
      this.checkWin();
    }
  }

  checkWin() {
    if (this.player.x === this.goal.x && this.player.y === this.goal.y) {
      this.gameOver = true;
      alert(`You win! Moves: ${this.moves}`);
      clearInterval(this.intervalId);
    }
  }

  start() {
      this.intervalId = setInterval(() => {
          if (!this.gameOver) this.checkWin();
      }, 100)
  }

}