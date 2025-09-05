class Enemy {
  constructor(ctx, x, y) {
    this.ctx = ctx;
    this.x = x;
    this.y = y;
    this.width = 30;
    this.height = 30;
    this.speed = 2;
  }

  draw() {
    this.ctx.fillStyle = 'red';
    this.ctx.fillRect(this.x, this.y, this.width, this.height);
  }

  update(deltaTime) {
    this.y += this.speed * deltaTime;
  }

  collidesWith(other) {
    return (
      this.x < other.x + other.width &&
      this.x + this.width > other.x &&
      this.y < other.y + other.height &&
      this.y + this.height > other.y
    );
  }
}