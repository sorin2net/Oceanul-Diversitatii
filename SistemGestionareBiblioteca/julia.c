#include "julia.h"

Image generateJuliaImage(JuliaParameters params) {
    Image img = createImage(params.params.width, params.params.height);
    double scaleX = (params.params.maxX - params.params.minX) / params.params.width;
    double scaleY = (params.params.maxY - params.params.minY) / params.params.height;
    for (int y = 0; y < params.params.height; y++) {
        for (int x = 0; x < params.params.width; x++) {
            double complex z = params.params.minX + x * scaleX + I * (params.params.minY + y * scaleY);
            int i = 0;
            for (; i < 255; i++) {
                z = z * z + params.c;
                if (cabs(z) > 2) break;
            }
            img.data[y * params.params.width + x] = i;
        }
    }
    return img;
}