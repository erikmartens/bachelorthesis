//
//  QuadrangleDetector.hpp
//  bachelorthesis
//
//  Created by Erik Maximilian Martens on 03.09.19.
//  Copyright © 2019  Erik Maximilian Martens. All rights reserved.
//

#ifndef QuadrangleDetector_hpp
#define QuadrangleDetector_hpp

#include <opencv2/opencv.hpp>

using namespace cv;
using namespace std;

class QuadrangleDetector
{
public:
  static void detect_squares( const Mat& image );
  
private:
  static double angle( cv::Point pt1, cv::Point pt2, cv::Point pt0 );
  static void find_squares( const Mat& image, vector<vector<cv::Point> >& squares );
  static void find_largest_square(const vector<vector<cv::Point> >& squares, vector<cv::Point>& biggest_square );
  static void draw_squares( const Mat& image, const vector<vector<cv::Point> >& squares );
  static void draw_square( const Mat& image, const vector<cv::Point>& square );
};

#endif /* QuadrangleDetector_hpp */
