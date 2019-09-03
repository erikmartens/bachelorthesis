#include <iostream>
#include <opencv2/opencv.hpp>

#include "Utilities.hpp"

using namespace std;
using namespace cv;

const bool debug = false;

int Utilities::downscaleImageByFactor(const int factor, cv::Mat &image) {
    
    // Quick return if there is nothing to resize
    if (factor <= 1)
    {
        return 1;
    }
    
    int width = image.cols;
    int height = image.rows;
    
    // we don't want to loose information, height and width need to be divisible by factor
    int updated_factor = factor;
    bool did_find_factor = false;
    while (did_find_factor == false && updated_factor > 1)
    {
        if (height % factor == 0 && width % factor == 0)
        {
            did_find_factor = true;
            break;
        }
        updated_factor -= 1;
    }
    
    if (factor > 1)
    {
        int updated_width = height / updated_factor;
        int updated_height = height / updated_factor;
        if(debug) cout << "Resizing image from " << image.rows << "x" << image.cols << " to " <<  height << "x" << width << " ..." << endl;
        cv::resize(image, image, Size( (double) updated_width, (double) updated_height));
        return updated_factor;
    }
    return 1;
}

void Utilities::upscaleImageByFactor(const int factor, cv::Mat &image) {
    
    // Quick return if there is nothing to resize
    if (factor <= 1)
    {
        return;
    }
    
    int width = image.cols;
    int height = image.rows;
    
    double updated_width = (double) width * (double) factor;
    double updated_height = (double) height * (double) factor;
    if(debug) cout << "Resizing image from " << image.rows << "x" << image.cols << " to " <<  height << "x" << width << " ..." << endl;
    cv::resize(image, image, Size( updated_width, updated_height));
}
