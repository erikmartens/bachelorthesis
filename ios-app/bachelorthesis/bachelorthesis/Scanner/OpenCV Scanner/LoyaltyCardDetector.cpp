//
//  LoyaltyCardDetector.cpp
//  bachelorthesis
//
//  Created by  Erik Maximilian Martens on 04.09.19.
//  Copyright © 2019  Erik Maximilian Martens. All rights reserved.
//

#include "LoyaltyCardDetector.hpp"

using namespace cv;
using namespace std;

#pragma mark Public

Mat LoyaltyCardDetector::extract_loyalty_card_from(const Mat &image)
{
  Mat result;
  
  /// Load an image
  if( !image.data )
  {
    return result;
  }

  // Process image
  get_image_canny_borders(image);
  vector<Point> borders = find_borders_points(image);
  result = four_points_transform(image, borders);

  cvtColor( result, image, COLOR_BGR2GRAY );
  //GaussianBlur( graysrc, graysrc, Size(5,5), 0, 0, BORDER_DEFAULT );

  threshold( image ,result, 127, 255, THRESH_TOZERO);
  //GaussianBlur( ticketImage, ticketImage, Size(5,5), 0, 0, BORDER_DEFAULT );
  //adaptiveThreshold(ticketImage,ticketImage, 255,ADAPTIVE_THRESH_GAUSSIAN_C,THRESH_BINARY,11,2);
  return result;
}

#pragma mark Private

void LoyaltyCardDetector::get_image_canny_borders(const Mat &image)
{
  cvtColor( image, image, COLOR_BGR2GRAY );
  GaussianBlur( image, image, Size(5,5), 0, 0, BORDER_DEFAULT );
  // Canny edge detector
  Canny(image, image, 75, 200);
}

vector<Point> LoyaltyCardDetector::find_borders_points(const Mat &image)
{
  vector<vector<Point> > contours;  /// Find contours
  findContours( image, contours, RETR_TREE, CHAIN_APPROX_SIMPLE, Point(0, 0) );
  
  vector<vector<Point> > contours_poly( contours.size() );
  
  for(unsigned int i = 0; i < contours.size(); i++ )
  {
    double peri = arcLength(contours[i], true);
    approxPolyDP( Mat(contours[i]), contours_poly[i], 0.02 * peri, true );
    if (contours_poly[i].size() == 4)
    {
      return contours_poly[i];
    }
  }
  
  return contours_poly[0];
}

vector<Point> LoyaltyCardDetector::order_points(vector<Point> points)
{
  vector<Point> order;
  Point tl(std::numeric_limits<int>::max(), 0);
  Point tr(0,std::numeric_limits<int>::max());
  Point bl(std::numeric_limits<int>::max(),std::numeric_limits<int>::max());
  Point br(std::numeric_limits<int>::min(), std::numeric_limits<int>::min());
  
  for (int i = 0; i < 4;i++)
  {
    int x = points[i].x;
    int y = points[i].y;
    if (x + y < tl.x + tl.y) tl = points[i];
    if (x - y > tr.x - tr.y) tr = points[i];
    if (x - y < bl.x - bl.y) bl = points[i];
    if (x + y > br.x + br.y) br = points[i];
  }
  order.push_back(tl);
  order.push_back(tr);
  order.push_back(bl);
  order.push_back(br);
  return order;
}

Mat LoyaltyCardDetector::four_points_transform(const Mat image, vector<Point> corners)
{
  Point2f points[4];
  vector<Point> pv = order_points(corners);
  std::copy(pv.begin(), pv.end(), points);
  Point tl = points[0];
  Point tr = points[1];
  Point bl = points[2];
  Point br = points[3];
  
  // compute the width of the new image, which will be the
  // maximum distance between bottom-right and bottom-left
  // x-coordiates or the top-right and top-left x-coordinates
  float widthA, widthB, maxWidth;
  float heightA, heightB, maxHeight;
  
  widthA = sqrt((pow((br.x - bl.x), 2)) + (pow((br.y - bl.y), 2)));
  widthB = sqrt((pow((tr.x - tl.x), 2)) + (pow((tr.y - tl.y), 2)));
  maxWidth = max(int(widthA), int(widthB));
  
  // compute the height of the new image, which will be the
  // maximum distance between the top-right and bottom-right
  // y-coordinates or the top-left and bottom-left y-coordinates
  heightA = sqrt((pow((tr.x - br.x), 2)) + (pow((tr.y - br.y), 2)));
  heightB = sqrt((pow((tl.x - bl.x), 2)) + (pow((tl.y - bl.y), 2)));
  maxHeight = max(int(heightA), int(heightB));
  
  // now that we have the dimensions of the new image, construct
  // the set of destination points to obtain a "birds eye view",
  // (i.e. top-down view) of the image, again specifying points
  // in the top-left, top-right, bottom-right, and bottom-left order
  Point2f dts[4];
  dts[0] = Point(0,0);
  dts[1] = Point(maxWidth-1,0);
  dts[2] = Point(0, maxHeight-1);
  dts[3] = Point(maxWidth-1,maxHeight-1);
  
  Mat warpMatrix = getPerspectiveTransform(points, dts);
  
  Mat rotated;
  Size size(maxWidth, maxHeight);
  warpPerspective(image, rotated, warpMatrix, size, INTER_LINEAR, BORDER_CONSTANT);
  return rotated;
}
