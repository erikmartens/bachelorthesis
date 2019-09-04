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
  static Mat extract_loyalty_card_from(const Mat &image);
  
private:
  static void get_image_canny_borders(const Mat &image);
  static vector<Point> find_borders_points(const Mat &image);
  static vector<Point> order_points(vector<Point> points);
  static Mat four_points_transform(const Mat image, vector<Point> corners);
};

#endif /* LoyaltyCardDetector_hpp */
