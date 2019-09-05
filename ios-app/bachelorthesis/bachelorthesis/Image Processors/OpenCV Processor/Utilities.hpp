#ifndef __UTILITIES_H__
#define __UTILITIES_H__

#include <opencv2/opencv.hpp>

using namespace std;
using namespace cv;

class Utilities {
  
public:
  static void downscale_image_by_factor(const int factor, Mat &image);
  static int downscale_image_by_max_factor(const int factor, Mat &image);
  static void upscale_image_by_factor(const int factor, Mat &image);
};

#endif /* Utilities.hpp */
