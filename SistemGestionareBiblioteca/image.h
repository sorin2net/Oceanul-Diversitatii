typedef struct {
    int width;
    int height;
    int **data;
} Image;

Image *create_image(int width, int height);
void free_image(Image *image);
void generate_mandelbrot(Image *image, double xmin, double xmax, double ymin, double ymax, int max_iter);
void generate_julia(Image *image, double xmin, double xmax, double ymin, double ymax, Complex c, int max_iter);
void save_image_ppm(Image *image, const char *filename);