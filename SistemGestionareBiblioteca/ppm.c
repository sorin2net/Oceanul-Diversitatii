#include <stdio.h>
#include <stdlib.h>
#include "ppm.h"

PPMImage* ppm_create(int width, int height) {
    PPMImage* image = (PPMImage*)malloc(sizeof(PPMImage));
    image->width = width;
    image->height = height;
    image->data = (uint8_t*)malloc(width * height * 3 * sizeof(uint8_t));
    return image;
}

void ppm_set_pixel(PPMImage* image, int x, int y, uint8_t r, uint8_t g, uint8_t b) {
    if (x < 0 || x >= image->width || y < 0 || y >= image->height) return;
    int index = (y * image->width + x) * 3;
    image->data[index] = r;
    image->data[index + 1] = g;
    image->data[index + 2] = b;
}

void ppm_save(PPMImage* image, const char* filename) {
    FILE* fp = fopen(filename, "wb");
    fprintf(fp, "P6\n%d %d\n255\n", image->width, image->height);
    fwrite(image->data, 1, image->width * image->height * 3, fp);
    fclose(fp);
}

void ppm_destroy(PPMImage* image) {
    free(image->data);
    free(image);
}