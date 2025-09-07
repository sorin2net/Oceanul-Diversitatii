#include <stdio.h>
#include <stdlib.h>
#include "image.h"
#include "fractal.h"
#include "complex.h"

Image *create_image(int width, int height) {
    Image *image = (Image *)malloc(sizeof(Image));
    image->width = width;
    image->height = height;
    image->data = (int **)malloc(height * sizeof(int *));
    for (int i = 0; i < height; i++) {
        image->data[i] = (int *)malloc(width * sizeof(int));
    }
    return image;
}

void free_image(Image *image) {
    for (int i = 0; i < image->height; i++) {
        free(image->data[i]);
    }
    free(image->data);
    free(image);
}

void generate_mandelbrot(Image *image, double xmin, double xmax, double ymin, double ymax, int max_iter) {
    double dx = (xmax - xmin) / image->width;
    double dy = (ymax - ymin) / image->height;
    for (int i = 0; i < image->height; i++) {
        for (int j = 0; j < image->width; j++) {
            Complex c = complex_new(xmin + j * dx, ymin + i * dy);
            image->data[i][j] = mandelbrot(c, max_iter);
        }
    }
}


void generate_julia(Image *image, double xmin, double xmax, double ymin, double ymax, Complex c, int max_iter){
    double dx = (xmax - xmin) / image->width;
    double dy = (ymax - ymin) / image->height;
    for (int i = 0; i < image->height; i++) {
        for (int j = 0; j < image->width; j++) {
            Complex z = complex_new(xmin + j * dx, ymin + i * dy);
            image->data[i][j] = julia(z, c, max_iter);
        }
    }
}

void save_image_ppm(Image *image, const char *filename) {
    FILE *fp = fopen(filename, "wb");
    fprintf(fp, "P6\n%d %d\n255\n", image->width, image->height);
    for (int i = 0; i < image->height; i++) {
        for (int j = 0; j < image->width; j++) {
            int val = image->data[i][j] % 256;
            fputc(val, fp);
            fputc(val, fp);
            fputc(val, fp);
        }
    }
    fclose(fp);
}