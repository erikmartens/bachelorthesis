//
//  LoyaltyCardDetector.hpp
//  bachelorthesis
//
//  Created by  Erik Maximilian Martens on 04.09.19.
//  Copyright © 2019  Erik Maximilian Martens. All rights reserved.
//

#ifndef LoyaltyCardDetector_hpp
#define LoyaltyCardDetector_hpp

#include "opencv2/imgproc/imgproc.hpp"
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

using namespace cv;
using namespace std;

class LoyaltyCardDetector
{
public:
  static void extract_loyalty_card_from(Mat &image);
  
private:
  static void get_image_canny_borders(Mat &image);
  static void find_border_points(Mat &image, vector<cv::Point> &borders);
  static vector<cv::Point> order_points(vector<cv::Point> points);
  static void four_points_transform(Mat &image, vector<cv::Point> corners);
};

#endif /* LoyaltyCardDetector_hpp */
