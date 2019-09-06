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

void LoyaltyCardDetector::extract_card_from(Mat &image)
{
  vector<Point> card_corners = get_card_vertices(image);
  //  Mat warpedCard;
  //  if (card_corners.size() == 4)
  //  {
  //    Mat homography = findHomography(card_corners, vector<Point>{Point(warpedCard.cols, 0), Point(warpedCard.cols, warpedCard.rows), Point(0,0) , Point(0, warpedCard.rows)});
  //    warpPerspective(image, warpedCard, homography, Size(image.cols, image.rows));
  //  }
  //  image = warpedCard;
  
  //  four_points_transform(image, card_corners);
}

void LoyaltyCardDetector::extract_loyalty_card_from(Mat &image)
{
  Mat imageCopy = image.clone();
  
  if( !image.data )
  {
    return;
  }
  
  vector<vector<Point> > quadrangles;
  vector<vector<Point> > contours;
  find_potential_card_contours( imageCopy, quadrangles, contours );
  
  //  vector<Point> biggest_square;
  //  filter_largest_square( squares, biggest_square );
  
  draw_squares( image, contours );
  //  draw_square(image, biggest_square);
  
  //  four_points_transform(image, biggest_square);
}

void LoyaltyCardDetector::detect_squares( Mat& image )
{
  vector<vector<Point> > quadrangles;
  vector<vector<Point> > contours;
  find_potential_card_contours( image, quadrangles, contours );
  
  vector<Point> biggest_square;
  filter_largest_square( image, biggest_square );
  
  if ( !biggest_square.size() ){
    // square was detected
    draw_square( image, biggest_square);
  }
  
  //  draw_squares( image, squares );
}

#pragma mark Private

#pragma mark Private Card Detection Functions

//void LoyaltyCardDetector::get_image_canny_borders(Mat &image)
//{
//  cvtColor( image, image, COLOR_BGR2GRAY );
//  GaussianBlur( image, image, Size(5,5), 0, 0, BORDER_DEFAULT );
//  Canny(image, image, 75, 200);
//}
//
//void LoyaltyCardDetector::find_vertices(Mat &image, vector<cv::Point> &borders)
//{
//  vector<vector<Point> > contours;
//  findContours( image, contours, RETR_TREE, CHAIN_APPROX_SIMPLE, Point(0, 0) );
//
//  vector<vector<Point> > contours_poly( contours.size() );
//
//  for(unsigned int i = 0; i < contours.size(); i++ )
//  {
//    double peri = arcLength(contours[i], true);
//    approxPolyDP( Mat(contours[i]), contours_poly[i], 0.02 * peri, true );
//    if (contours_poly[i].size() == 4)
//    {
//      borders = contours_poly[i];
//      return;
//    }
//  }
//
//  borders = contours_poly[0];
//}

vector<Point> LoyaltyCardDetector::order_points(vector<Point> points)
{
  if ( !points.size() )
  {
    return points;
  }
  
  vector<Point> order;
  Point tl(numeric_limits<int>::max(), 0);
  Point tr(0,numeric_limits<int>::max());
  Point bl(numeric_limits<int>::max(),numeric_limits<int>::max());
  Point br(numeric_limits<int>::min(), numeric_limits<int>::min());
  
  for ( int i = 0; i < 4; i++ )
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

void LoyaltyCardDetector::four_points_transform(Mat &image, vector<Point> corners)
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
  image = rotated;
}

double LoyaltyCardDetector::angle( Point pt1, Point pt2, Point pt0 )
{
  double dx1 = pt1.x - pt0.x;
  double dy1 = pt1.y - pt0.y;
  double dx2 = pt2.x - pt0.x;
  double dy2 = pt2.y - pt0.y;
  return (dx1*dx2 + dy1*dy2)/sqrt((dx1*dx1 + dy1*dy1)*(dx2*dx2 + dy2*dy2) + 1e-10);
}

void LoyaltyCardDetector::find_potential_card_contours( Mat& image, vector<vector<Point> >& quadrangles, vector<vector<Point> >& contours )
{
  int thresh = 50, N = 11;
  
  quadrangles.clear();
  
  Mat pyr, timg, gray0(image.size(), CV_8U), gray;
  
  // down-scale and upscale the image to filter out the noise
  pyrDown(image, pyr, Size(image.cols/2, image.rows/2));
  pyrUp(pyr, timg, image.size());
  vector<vector<Point> > allIndentifiedContours;
  
  // find squares in every color plane of the image
  for ( int c = 0; c < 3; c++ )
  {
    int ch[] = {c, 0};
    mixChannels(&timg, 1, &gray0, 1, ch, 1);
    
    // try several threshold levels
    for ( int l = 0; l < N; l++ )
    {
      // hack: use Canny instead of zero threshold level.
      // Canny helps to catch squares with gradient shading
      if ( l == 0 )
      {
        // apply Canny. Take the upper threshold from slider
        // and set the lower to 0 (which forces edges merging)
        Canny(gray0, gray, 0, thresh, 5);
        // dilate canny output to remove potential
        // holes between edge segments
        dilate(gray, gray, Mat(), Point(-1,-1));
      }
      else
      {
        // apply threshold if l!=0:
        //     tgray(x,y) = gray(x,y) < (l+1)*255/N ? 255 : 0
        gray = gray0 >= (l+1)*255/N;
      }
      
      int max_contour_area = (gray.cols) * (gray.rows);
      
      // find contours and store them all as a list
      findContours(gray, allIndentifiedContours, RETR_LIST, CHAIN_APPROX_SIMPLE);
      
      vector<Point> approximatedCorners;
      
      // test each contour
      for ( size_t i = 0; i < allIndentifiedContours.size(); i++ )
      {
        // filter contours above the threshhold of 0.99, likely belonging to the image border
        // the card needs to cover a significant portion of the image,
        // therefore filter contours below a threshhold of 0.5
        double countourArea = contourArea(allIndentifiedContours[i]);
        if ( countourArea >= (double) max_contour_area * 0.95
            || countourArea <= (double) max_contour_area * 0.5 )
        {
          continue;
        }
        
        Point2f vertices2f[4];
        RotatedRect bounds = minAreaRect(InputArray(allIndentifiedContours[i]));
        bounds.points(vertices2f);
        vector<Point> vertices;
        vertices.push_back(vertices2f[0]);
        vertices.push_back(vertices2f[1]);
        vertices.push_back(vertices2f[2]);
        vertices.push_back(vertices2f[3]);
        approximatedCorners = vertices;
        
        // approximate contour with accuracy proportional
        // to the contour perimeter
        // max corner radius percentage of a ISO 7810 ID-1 card is
        double arclength = arcLength( allIndentifiedContours[i], true );
        double cornerRadius = loyalty_card_corner_radius(arclength);
        double maxEpsilonFactor = max_epsilon_factor(arclength, cornerRadius);
        approxPolyDP( allIndentifiedContours[i], approximatedCorners, arclength*maxEpsilonFactor, true );
        
        // square contours should have 4 vertices after approximation
        // relatively large area (to filter out noisy contours)
        // and be convex.
        // Note: absolute value of an area is used because
        // area may be positive or negative - in accordance with the
        // contour orientation
        if ( approximatedCorners.size() == 4 &&
            isContourConvex(approximatedCorners) )
        {
          double maxCosine = 0;
          
          for ( int j = 2; j < 5; j++ )
          {
            // find the maximum cosine of the angle between joint edges
            double cosine = fabs(angle(approximatedCorners[j%4], approximatedCorners[j-2], approximatedCorners[j-1]));
            maxCosine = MAX(maxCosine, cosine);
          }
          
          // if cosines of all angles are small
          // (all angles are ~90 degree) then write quandrange
          // vertices to resultant sequence
          if ( maxCosine < 0.3 )
            contours.push_back(allIndentifiedContours[i]);
          quadrangles.push_back(approximatedCorners);
        }
      }
    }
  }
}

double LoyaltyCardDetector::loyalty_card_corner_radius(double arclength)
{
  return arclength / (6283.0/87.0 + 2*M_PI);
}

double LoyaltyCardDetector::max_epsilon_factor(double arclength, double cornerRadius)
{
  double arcLengthBoundingRect = arclength - 2*cornerRadius*M_PI + 8*cornerRadius;
  return arcLengthBoundingRect/arclength - 1;
}

//void LoyaltyCardDetector::identify_loyalty_card_square(vector<vector<Point> >& squares, vector<Point>& vertics)
//{
//  // the largest square usually is the image border
//  remove_largest_square(squares);
////  filter_squares_for_aspect_ratio(squares);
//}

void LoyaltyCardDetector::filter_largest_square(const vector<vector<Point> >& squares, vector<Point>& biggest_square)
{
  if (!squares.size()){
    // no squares detected
    return;
  }
  
  double maxArea = 0;
  int largestIndex = -1;
  
  for ( int i = 0; i < squares.size(); i++)
  {
    vector<Point> square = squares[i];
    double area = contourArea(Mat(square));
    if ( area >= maxArea)
    {
      largestIndex = i;
      maxArea = area;
    }
  }
  if ( largestIndex >= 0 && largestIndex < squares.size() )
  {
    biggest_square = squares[largestIndex];
  }
}

//void LoyaltyCardDetector::remove_largest_square(vector<vector<Point> >& squares)
//{
//  if (!squares.size())
//  {
//    // no squares detected
//    return;
//  }
//
//  double maxArea = 0;
//  int largestIndex = -1;
//
//  for ( int i = 0; i < squares.size(); i++)
//  {
//    vector<Point> square = squares[i];
//    double area = contourArea(Mat(square));
//    if ( area >= maxArea )
//    {
//      largestIndex = i;
//      maxArea = area;
//    }
//  }
//  if ( largestIndex >= 0 && largestIndex < squares.size() )
//  {
//    squares.erase( squares.begin() + largestIndex );
//  }
//}

//void LoyaltyCardDetector::filter_squares_for_aspect_ratio(vector<vector<Point> >& squares)
//{
//
//}


//////////////////

vector<Point> LoyaltyCardDetector::get_card_vertices(Mat &destination)
{
  vector<vector<Point>> contours;
  vector<vector<Point>> quadrangles;
  find_potential_card_contours(destination, quadrangles, contours);
  
  /// sort found contours to identify most promising contour
  vector<int> indices(contours.size());
  for ( int i = 0; i < contours.size(); i++ )
  {
    indices[i] = i;
  }
  sort(indices.begin(), indices.end(), [&contours](int lhs, int rhs) {
    return contours[lhs].size() < contours[rhs].size()
    && contourArea(contours[lhs]) > contourArea(contours[rhs]);
  });
  
  /// Find the convex hull object
  Mat convexHull_mask(destination.rows, destination.cols, CV_8UC1);
  convexHull_mask = Scalar(0);
  vector<vector<Point> >hull(1);
  convexHull(Mat(contours[indices[0]]), hull[0], false);
  
  /// find hough lines of convex hull
  vector<Vec4i> lines;
  drawContours(convexHull_mask, hull, 0, Scalar(255), 2, LINE_AA);
  HoughLinesP(convexHull_mask, lines, 1, CV_PI / 180, 80, 30, 10);
  
  /// debug
//  Mat output(destination.rows, destination.cols, CV_8UC1);
//  output = Scalar(0);
//  draw_lines(lines, output);
//  destination = output;
  
  // find intersection points of all lines
  vector<Point> intersections;
  get_intersections(lines, intersections, destination.cols, destination.rows);
  
  // filter down to 4 cornerpoints of quadrangle
  vector<Point> vertices;
  filter_for_vertices(intersections, vertices);
  
  /// debug
  Mat output(destination.rows, destination.cols, CV_8UC1);
  output = Scalar(0);
  draw_points(vertices, output);
  destination = output;
  
  if (vertices.size() == 4) // we have the 4 final corners
  {
    return(vertices);
  }
  return(vector<Point>());
}

# pragma mark Private Helper Functions

static array<int, 3> cross(const array<int, 3> &a, const array<int, 3> &b)
{
  array<int, 3> result;
  result[0] = a[1] * b[2] - a[2] * b[1];
  result[1] = a[2] * b[0] - a[0] * b[2];
  result[2] = a[0] * b[1] - a[1] * b[0];
  return result;
}

static bool get_intersection(const Vec4i &line_a, const Vec4i &line_b, Point &intersection)
{
  array<int, 3> pa{ { line_a[0], line_a[1], 1 } };
  array<int, 3> pb{ { line_a[2], line_a[3], 1 } };
  array<int, 3> la = cross(pa, pb);
  pa[0] = line_b[0];
  pa[1] = line_b[1];
  pa[2] = 1;
  
  pb[0] = line_b[2];
  pb[1] = line_b[3];
  pb[2] = 1;
  
  array<int, 3> lb = cross(pa, pb);
  array<int, 3> inter = cross(la, lb);
  
  // TODO: filter semiparallel lines
  
  if (inter[2] == 0)
  {
    return false; // two lines are parallel
  }
  else
  {
    intersection.x = inter[0] / inter[2];
    intersection.y = inter[1] / inter[2];
    return true;
  }
}

void LoyaltyCardDetector::get_intersections(vector<Vec4i> &lines, vector<Point> &intersections, int imageWidth, int imageHeight)
{
  for (int i = 0; i < lines.size(); i++)
  {
    for (int j = i; j < lines.size(); j++)
    {
      Point intersection;
      bool intersects = get_intersection(lines[i], lines[j], intersection);
      
      if ( intersects && (intersection.x > 0) && (intersection.y > 0) && (intersection.x < imageWidth) && (intersection.y < imageHeight) )
      {
        intersections.push_back(intersection);
      }
    }
  }
}

void LoyaltyCardDetector::filter_for_vertices(vector<Point> &intersections, vector<Point> &corners)
{
  if ( intersections.size() < 4 )
  {
    return; // not enough points to have identified a quadrangle
  }
  
  Point tl(numeric_limits<int>::max(), 0);
  Point tr(0,numeric_limits<int>::max());
  Point bl(numeric_limits<int>::max(),numeric_limits<int>::max());
  Point br(numeric_limits<int>::min(), numeric_limits<int>::min());
  
  for ( int i = 0; i < 4; i++ )
  {
    int x = intersections[i].x;
    int y = intersections[i].y;
    if (x + y < tl.x + tl.y) tl = intersections[i];
    if (x - y > tr.x - tr.y) tr = intersections[i];
    if (x - y < bl.x - bl.y) bl = intersections[i];
    if (x + y > br.x + br.y) br = intersections[i];
  }
  corners.push_back(tl);
  corners.push_back(tr);
  corners.push_back(bl);
  corners.push_back(br);
}

# pragma mark Drawing Helper Functions

void LoyaltyCardDetector::draw_square( const Mat& image, const vector<Point>& square )
{
  const Point* p = &square[0];
  int n = (int) square.size();
  polylines(image, &p, &n, 1, true, Scalar(0,0,255), 1, LINE_AA);
}

void LoyaltyCardDetector::draw_squares( const Mat& image, const vector<vector<Point> >& squares )
{
  for( size_t i = 0; i < squares.size(); i++ )
  {
    const Point* p = &squares[i][0];
    int n = (int) squares[i].size();
    polylines(image, &p, &n, 1, true, Scalar(0,0,255), 1, LINE_AA);
  }
}

void LoyaltyCardDetector::draw_lines(vector<Vec4i> lines, Mat &destination)
{
  for (size_t i = 0; i < lines.size(); i++)
  {
    Vec4i l = lines[i];
    line(destination, Point(l[0], l[1]), Point(l[2], l[3]), Scalar(255), 3, LINE_8);
  }
}

void LoyaltyCardDetector::draw_points(vector<Point> points, Mat &destination)
{
  for (size_t i = 0; i < points.size(); i++)
  {
    Point p = points[i];
    circle(destination, p, 20, Scalar(255), 20);
  }
}
