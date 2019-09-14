//
//  LoyaltyCardDetector.hpp
//  bachelorthesis
//
//  Created by  Erik Maximilian Martens on 04.09.19.
//  Copyright © 2019  Erik Maximilian Martens. All rights reserved.
//

#ifndef LoyaltyCardDetector_hpp
#define LoyaltyCardDetector_hpp

#include "Utilities.hpp"
#include "opencv2/imgproc/imgproc.hpp"

#include <stdlib.h>
#include <stdio.h>
#include <math.h>

using namespace cv;
using namespace std;

class LoyaltyCardDetector
{
public:
  
  static bool extract_card_from(Mat &sourceImage, Mat &outputImage, Mat &debugContoursImage, Mat &debugHoughLinesImage, Mat &debugIntersectionsImage, Mat &debugVerticesImage);
  
private:
  
  static double toleranceThreshold;
  
# pragma mark Detection
  
  static void find_potential_card_contours(Mat& image, vector<vector<cv::Point> >& contours);
  static void identify_quadrangle_from_contour(vector<cv::Point> &contour, vector<cv::Point> &vertices, int imageWidth, int imageHeight, Mat &debugContoursOutput, Mat &debugIntersectionsOutput, Mat &debugHoughLinesOutput, Mat &debugVerticesOutput);
  
# pragma mark Detection Helpers
  
  static double loyalty_card_corner_radius(double arclength);
  static double max_epsilon_factor(double arclength, double cornerRadius);
  static int find_best_matching_quadrangle_from_quadrangles(vector<vector<cv::Point> > &quadrangles, vector<cv::Point> &bestQudrangle);
  
# pragma mark Warping
  
  static void four_points_transform(Mat &image, vector<cv::Point> vertices);
  
# pragma mark Utilities
  
  static double angle( cv::Point pt1, cv::Point pt2, cv::Point pt0 );
  static vector<cv::Point> order_points(vector<cv::Point> points);
  static float line_slope(Vec4i line);
  static float line_slope_4f(Vec4f line);
  static void filter_intersections_for_vertices(vector<cv::Point> &intersections, vector<cv::Point> &corners, int imageWidth, int imageHeight);
  static bool two_times_same_corner_angles(vector<double> &cosines);
  static double line_length(Vec4i &line);
  static void line_intersections(vector<Vec4f> &lines, vector<cv::Point> &intersections, int imageWidth, int imageHeight);
  static void convert_contours_to_lines(vector<vector<cv::Point>> &contours, vector<Vec4f> &lines, int imageWidth, int imageHeight);
  static void convert_lines4f_to_lines4i(vector<Vec4f> &lines4f, vector<Vec4i> &lines);
  
# pragma mark Drawing
  
  static void draw_square(const Mat& image, const vector<cv::Point>& square);
  static void draw_vectors(vector<Vec4i> &lines, Mat &destination);
  static void draw_points(vector<cv::Point> &points, Mat &destination);
};

#endif /* LoyaltyCardDetector_hpp */
