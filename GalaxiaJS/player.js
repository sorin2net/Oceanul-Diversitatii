class Player {
  constructor() {
    this.name = prompt("Introdu numele tau:");
    this.highScore = 0;
  }

  updateHighScore(score) {
    if (score > this.highScore) {
      this.highScore = score;
      console.log(`Nou highscore: ${this.highScore}`);
    }
  }
}