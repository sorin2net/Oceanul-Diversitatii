class Game {
  constructor(canvas) {
    this.canvas = canvas;
    this.ctx = canvas.getContext('2d');
    this.player = new Player(this.ctx, this.canvas.width / 2, this.canvas.height - 50);
    this.enemies = [];
    this.bullets = [];
    this.score = 0;
    this.gameOver = false;
    this.enemySpawnInterval = 2000;
    this.lastEnemySpawn = 0;
  }

  update(deltaTime) {
    if (this.gameOver) return;

    this.player.update(deltaTime);
    this.updateBullets(deltaTime);
    this.updateEnemies(deltaTime);
    this.checkCollisions();
    this.spawnEnemies();
    this.draw();
  }

  draw() {
    this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
    this.player.draw();
    this.drawBullets();
    this.drawEnemies();
    this.drawScore();
  }

  updateBullets(deltaTime){
    this.bullets = this.bullets.filter(bullet => {
      bullet.update(deltaTime);
      return bullet.y > 0;
    });
  }

  updateEnemies(deltaTime){
    this.enemies = this.enemies.filter(enemy => {
      enemy.update(deltaTime);
      return enemy.y < this.canvas.height;
    });
  }

  spawnEnemies() {
    const now = Date.now();
    if (now - this.lastEnemySpawn > this.enemySpawnInterval) {
      this.enemies.push(new Enemy(this.ctx, Math.random() * this.canvas.width, 0));
      this.lastEnemySpawn = now;
    }
  }

  checkCollisions() {
    this.bullets.forEach((bullet, bulletIndex) => {
      this.enemies.forEach((enemy, enemyIndex) => {
        if (bullet.collidesWith(enemy)) {
          this.enemies.splice(enemyIndex, 1);
          this.bullets.splice(bulletIndex, 1);
          this.score += 10;
        }
      });
    });

    this.enemies.forEach(enemy => {
      if (enemy.collidesWith(this.player)) {
        this.gameOver = true;
      }
    });
  }


  drawBullets() {
    this.bullets.forEach(bullet => bullet.draw());
  }

  drawEnemies() {
    this.enemies.forEach(enemy => enemy.draw());
  }

  drawScore() {
    this.ctx.fillStyle = 'white';
    this.ctx.font = '20px Arial';
    this.ctx.fillText(`Score: ${this.score}`, 10, 30);
  }

  fireBullet(){
    this.bullets.push(new Bullet(this.ctx, this.player.x + this.player.width / 2, this.player.y));
  }
}