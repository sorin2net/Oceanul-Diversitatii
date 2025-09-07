#include "fractal.h"
#include <math.h>

MandelbrotData calculateMandelbrot(double complex c, int maxIterations) {
    double complex z = 0;
    int i = 0;
    for (; i < maxIterations; i++) {
        z = z * z + c;
        if (cabs(z) > 2) break;
    }
    return (MandelbrotData){c, i};
}

Image generateMandelbrotImage(ImageParameters params) {
    Image img = createImage(params.width, params.height);
    double scaleX = (params.maxX - params.minX) / params.width;
    double scaleY = (params.maxY - params.minY) / params.height;
    for (int y = 0; y < params.height; y++) {
        for (int x = 0; x < params.width; x++) {
            double complex c = params.minX + x * scaleX + I * (params.minY + y * scaleY);
            MandelbrotData data = calculateMandelbrot(c, 255);
            img.data[y * params.width + x] = data.iterations;
        }
    }
    return img;
}


void saveImagePPM(Image img, const char* filename) {
    FILE *fp = fopen(filename, "wb");
    fprintf(fp, "P6\n%d %d\n255\n", img.width, img.height);
    fwrite(img.data, 1, img.width * img.height, fp);
    fclose(fp);
}

ImageParameters createImageParameters(int width, int height, double minX, double maxX, double minY, double maxY){
    return (ImageParameters){minX, maxX, minY, maxY, width, height, (maxX - minX) / width};
}

Image createImage(int width, int height){
    unsigned char* data = (unsigned char*)malloc(width * height * sizeof(unsigned char));
    if(data == NULL){
        fprintf(stderr, "Memory allocation failed\n");
        exit(1);
    }
    return (Image){width, height, data};
}

void freeImage(Image img){
    free(img.data);
}

void printImageInfo(Image img){
    printf("Image width: %d\n", img.width);
    printf("Image height: %d\n", img.height);
}