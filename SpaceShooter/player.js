class Player {
  constructor(ctx, x, y) {
    this.ctx = ctx;
    this.x = x;
    this.y = y;
    this.width = 50;
    this.height = 30;
    this.speed = 5;
  }

  draw() {
    this.ctx.fillStyle = 'blue';
    this.ctx.fillRect(this.x, this.y, this.width, this.height);
  }

  update(deltaTime) {
    if (keysPressed['ArrowLeft'] && this.x > 0) {
      this.x -= this.speed * deltaTime;
    }
    if (keysPressed['ArrowRight'] && this.x < this.ctx.canvas.width - this.width) {
      this.x += this.speed * deltaTime;
    }
  }
}