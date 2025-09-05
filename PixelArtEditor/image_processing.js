
function loadAndProcessImage(imagePath) {
    const img = new Image();
    img.src = imagePath;
    img.onload = () => {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
    };
}

function applyFilter(imageData, filterType) {
    if (filterType === 'sepia') {
        return sepiaFilter(imageData);
    }
    return imageData;
}

function sepiaFilter(imageData) {
    const data = imageData.data;
    for (let i = 0; i < data.length; i += 4) {
        const r = data[i];
        const g = data[i + 1];
        const b = data[i + 2];

        data[i]     = Math.min(0.393*r + 0.769*g + 0.189*b, 255); // R
        data[i + 1] = Math.min(0.349*r + 0.686*g + 0.168*b, 255); // G
        data[i + 2] = Math.min(0.272*r + 0.534*g + 0.131*b, 255); // B
    }
    return imageData;
}

function applyFilterToCanvas(filterType) {
    const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
    const filteredData = applyFilter(imageData, filterType);
    ctx.putImageData(filteredData, 0, 0);
}

