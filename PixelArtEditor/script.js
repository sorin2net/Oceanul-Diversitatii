const canvas = document.getElementById('canvas');
const ctx = canvas.getContext('2d');
const colorPicker = document.getElementById('colorPicker');
const clearButton = document.getElementById('clearButton');
const saveButton = document.getElementById('saveButton');
const gridSizeInput = document.getElementById('gridSize');
const imageLoader = document.getElementById('imageLoader');
const filterSelect = document.getElementById('filterSelect');
const applyFilterButton = document.getElementById('applyFilterButton');

let gridSize = parseInt(gridSizeInput.value);
let drawing = false;

// ---------------- PIXEL ART FUNCTIONS ----------------

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

// Mouse events
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

// Clear button
clearButton.addEventListener('click', () => {
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  drawGrid();
});

// Save button
saveButton.addEventListener('click', () => {
  const dataURL = canvas.toDataURL();
  const link = document.createElement('a');
  link.href = dataURL;
  link.download = 'pixel_art.png';
  link.click();
});

// Grid size
gridSizeInput.addEventListener('change', () => {
  gridSize = parseInt(gridSizeInput.value);
  drawGrid();
});

drawGrid();

// ---------------- IMAGE & FILTER FUNCTIONS ----------------

function loadAndProcessImage(file) {
  const reader = new FileReader();
  reader.onload = function(event) {
    const img = new Image();
    img.onload = function() {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
    };
    img.src = event.target.result;
  };
  reader.readAsDataURL(file);
}

function applyFilter(imageData, filterType) {
  const data = imageData.data;
  for (let i = 0; i < data.length; i += 4) {
    const r = data[i];
    const g = data[i + 1];
    const b = data[i + 2];

    if (filterType === 'sepia') {
      data[i]     = Math.min(0.393*r + 0.769*g + 0.189*b, 255);
      data[i + 1] = Math.min(0.349*r + 0.686*g + 0.168*b, 255);
      data[i + 2] = Math.min(0.272*r + 0.534*g + 0.131*b, 255);
    } else if (filterType === 'grayscale') {
      const avg = (r + g + b) / 3;
      data[i] = data[i+1] = data[i+2] = avg;
    } else if (filterType === 'invert') {
      data[i] = 255 - r;
      data[i+1] = 255 - g;
      data[i+2] = 255 - b;
    }
  }
  return imageData;
}

function applyFilterToCanvas(filterType) {
  const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
  const filteredData = applyFilter(imageData, filterType);
  ctx.putImageData(filteredData, 0, 0);
}

// File input event
imageLoader.addEventListener('change', (e) => {
  const file = e.target.files[0];
  if (file) loadAndProcessImage(file);
});

// Apply filter button
applyFilterButton.addEventListener('click', () => {
  const filterType = filterSelect.value;
  if (filterType) applyFilterToCanvas(filterType);
});
