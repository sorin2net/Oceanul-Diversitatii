class Bullet {
  constructor(ctx, x, y) {
    this.ctx = ctx;
    this.x = x;
    this.y = y;
    this.width = 5;
    this.height = 10;
    this.speed = 10;
  }

  draw() {
    this.ctx.fillStyle = 'yellow';
    this.ctx.fillRect(this.x, this.y, this.width, this.height);
  }

  update(deltaTime) {
    this.y -= this.speed * deltaTime;
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