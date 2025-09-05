#ifndef IMAGE_H
#define IMAGE_H

#include <vector>

class Image {
public:
    Image(int width, int height);
    void setPixel(int x, int y, int r, int g, int b);
    void save(const std::string& filename);

private:
    int width;
    int height;
    std::vector<std::vector<std::vector<int>>> pixels;
};

#endif