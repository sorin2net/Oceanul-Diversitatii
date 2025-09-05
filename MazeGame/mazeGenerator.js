class MazeGenerator {
  constructor(width, height) {
    this.width = width;
    this.height = height;
    this.data = this.generateMaze();
  }

  generateMaze() {
    const maze = Array(this.height).fill(null).map(() => Array(this.width).fill(1));
    const visited = Array(this.height).fill(null).map(() => Array(this.width).fill(false));
    const stack = [[0, 0]];
    visited[0][0] = true;

    while (stack.length > 0) {
      const [x, y] = stack[stack.length - 1];
      let neighbors = [];
      if (x > 0 && !visited[y][x - 1]) neighbors.push([-1, 0]);
      if (x < this.width - 1 && !visited[y][x + 1]) neighbors.push([1, 0]);
      if (y > 0 && !visited[y - 1][x]) neighbors.push([0, -1]);
      if (y < this.height - 1 && !visited[y + 1][x]) neighbors.push([0, 1]);

      if (neighbors.length > 0) {
        const [dx, dy] = neighbors[Math.floor(Math.random() * neighbors.length)];
        const newX = x + dx;
        const newY = y + dy;
        maze[newY][newX] = 0;
        stack.push([newX, newY]);
        visited[newY][newX] = true;
      } else {
        stack.pop();
      }
    }
    return {data: maze, width: this.width, height: this.height};
  }
}