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
  static void detect_squares( const Mat& image );
  
private:
  //  static void get_image_canny_borders(Mat &image);
  //  static void find_vertices(Mat &image, vector<cv::Point> &borders);
  static vector<cv::Point> order_points(vector<cv::Point> points);
  static void four_points_transform(Mat &image, vector<cv::Point> corners);
  
  static double angle( cv::Point pt1, cv::Point pt2, cv::Point pt0 );
  static void find_squares( const Mat& image, vector<vector<cv::Point> >& squares );
  //  static void identify_loyalty_card_square(vector<vector<cv::Point> >& squares, vector<cv::Point>& vertics);
  static void filter_largest_square(const vector<vector<cv::Point> >& squares, vector<cv::Point>& biggest_square );
  static void filter_squares_for_aspect_ratio(vector<vector<cv::Point> >& squares);
  //  static void remove_largest_square(vector<vector<cv::Point> >& squares);
  
  static void draw_square( const Mat& image, const vector<cv::Point>& square );
  static void draw_squares( const Mat& image, const vector<vector<cv::Point> >& squares );
};

#endif /* LoyaltyCardDetector_hpp */
