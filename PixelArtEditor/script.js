const canvas = document.getElementById('canvas');
const ctx = canvas.getContext('2d');
const colorPicker = document.getElementById('colorPicker');
const clearButton = document.getElementById('clearButton');
const saveButton = document.getElementById('saveButton');
const gridSizeInput = document.getElementById('gridSize');
let gridSize = parseInt(gridSizeInput.value);
let drawing = false;

function drawGrid() {
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  ctx.strokeStyle = '#ccc';
  for (let x = 0; x <= canvas.width; x += gridSize) {
    ctx.beginPath();
    ctx.moveTo(x, 0);
    ctx.lineTo(x, canvas.height);
    ctx.stroke();
  }
  for (let y = 0; y <= canvas.height; y += gridSize) {
    ctx.beginPath();
    ctx.moveTo(0, y);
    ctx.lineTo(canvas.width, y);
    ctx.stroke();
  }
}

function drawPixel(x, y) {
  ctx.fillStyle = colorPicker.value;
  ctx.fillRect(x, y, gridSize, gridSize);
}

canvas.addEventListener('mousedown', (e) => {
  drawing = true;
  const x = Math.floor(e.offsetX / gridSize) * gridSize;
  const y = Math.floor(e.offsetY / gridSize) * gridSize;
  drawPixel(x, y);
});

canvas.addEventListener('mousemove', (e) => {
  if (drawing) {
    const x = Math.floor(e.offsetX / gridSize) * gridSize;
    const y = Math.floor(e.offsetY / gridSize) * gridSize;
    drawPixel(x, y);
  }
});

canvas.addEventListener('mouseup', () => drawing = false);

clearButton.addEventListener('click', () => {
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  drawGrid();
});

saveButton.addEventListener('click', () => {
  const dataURL = canvas.toDataURL();
  const link = document.createElement('a');
  link.href = dataURL;
  link.download = 'pixel_art.png';
  link.click();
});

gridSizeInput.addEventListener('change', () => {
  gridSize = parseInt(gridSizeInput.value);
  drawGrid();
});

drawGrid();