#include "image.h"
#include <fstream>

Image::Image(int width, int height) : width(width), height(height), pixels(width, std::vector<std::vector<int>>(height, std::vector<int>(3))) {}

void Image::setPixel(int x, int y, int r, int g, int b) {
    pixels[x][y][0] = r;
    pixels[x][y][1] = g;
    pixels[x][y][2] = b;
}

void Image::save(const std::string& filename) {
    std::ofstream file(filename);
    file << "P3\n" << width << " " << height << "\n255\n";
    for (int y = 0; y < height; ++y) {
        for (int x = 0; x < width; ++x) {
            file << pixels[x][y][0] << " " << pixels[x][y][1] << " " << pixels[x][y][2] << "\n";
        }
    }
    file.close();
}