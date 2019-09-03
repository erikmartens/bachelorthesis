#ifndef __UTILITIES_H__
#define __UTILITIES_H__

#include <opencv2/opencv.hpp>

class Utilities {
  
public:
  static void downscaleImageByFactor(const int factor, cv::Mat &image);
  static int downscaleImageByMaxFactor(const int factor, cv::Mat &image);
  static void upscaleImageByFactor(const int factor, cv::Mat &image);
};

#endif /* Utilities.hpp */
