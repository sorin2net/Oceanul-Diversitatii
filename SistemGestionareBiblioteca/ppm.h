#ifndef PPM_H
#define PPM_H

typedef struct {
    int width;
    int height;
    uint8_t* data;
} PPMImage;

PPMImage* ppm_create(int width, int height);
void ppm_set_pixel(PPMImage* image, int x, int y, uint8_t r, uint8_t g, uint8_t b);
void ppm_save(PPMImage* image, const char* filename);
void ppm_destroy(PPMImage* image);

#endif