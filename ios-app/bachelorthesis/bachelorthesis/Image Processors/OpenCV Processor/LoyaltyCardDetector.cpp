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
//  Mat input_grey;
//  cvtColor(image, input_grey, COLOR_BGR2GRAY);
//  Mat threshold1;
  Mat edges;
//  blur(input_grey, input_grey, Size(3, 3));
//  Canny(input_grey, edges, 30, 100);

  vector<Point> card_corners = get_quadrilateral(image, edges);
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
  find_squares( imageCopy, quadrangles, contours );
  
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
  find_squares( image, quadrangles, contours );
  
  vector<Point> biggest_square;
  filter_largest_square( image, biggest_square );
  
  if ( !biggest_square.size() ){
    // square was detected
    draw_square( image, biggest_square);
  }
  
  //  draw_squares( image, squares );
}

#pragma mark Private

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
    return points;
  
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

void LoyaltyCardDetector::find_squares( Mat& image, vector<vector<Point> >& quadrangles, vector<vector<Point> >& contours )
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


//////////////////

Vec3f LoyaltyCardDetector::calc_params(Point2f p1, Point2f p2) // line's equation Params computation
{
  float a, b, c;
  if (p2.y - p1.y == 0)
  {
    a = 0.0f;
    b = -1.0f;
  }
  else if (p2.x - p1.x == 0)
  {
    a = -1.0f;
    b = 0.0f;
  }
  else
  {
    a = (p2.y - p1.y) / (p2.x - p1.x);
    b = -1.0f;
  }
  
  c = (-a * p1.x) - b * p1.y;
  return(Vec3f(a, b, c));
}

Point LoyaltyCardDetector::find_intersection(Vec3f params1, Vec3f params2)
{
  float x = -1, y = -1;
  float det = params1[0] * params2[1] - params2[0] * params1[1];
  if (det < 0.5f && det > -0.5f) // lines are approximately parallel
  {
    return(Point(-1, -1));
  }
  else
  {
    x = (params2[1] * -params1[2] - params1[1] * -params2[2]) / det;
    y = (params1[0] * -params2[2] - params2[0] * -params1[2]) / det;
  }
  return(Point(x, y));
}

// returns the 4 intersection points of the card
vector<Point> LoyaltyCardDetector::get_quadrilateral(Mat &grayscale, Mat &output)
{
  Mat convexHull_mask(grayscale.rows, grayscale.cols, CV_8UC1);
  convexHull_mask = Scalar(0);
  
  vector<vector<Point>> contours;
  vector<vector<Point>> vertices;
  find_squares(grayscale, vertices, contours);
//  findContours(grayscale, contours, RETR_EXTERNAL, CHAIN_APPROX_NONE);
  
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
  vector<vector<Point> >hull(1);
  convexHull(Mat(contours[indices[0]]), hull[0], false);
  
  vector<Vec4i> lines;
  drawContours(convexHull_mask, hull, 0, Scalar(255), 2, LINE_AA);
  HoughLinesP(convexHull_mask, lines, 1, CV_PI / 180, 80, 30, 10);
  
  
  
  Mat cdst(grayscale.rows, grayscale.cols, CV_8UC1);
  cdst = Scalar(0);
  for (size_t i = 0; i < lines.size(); i++)
  {
    Vec4i l = lines[i];
    line(cdst, Point(l[0], l[1]), Point(l[2], l[3]), Scalar(0, 0, 255), 3, LINE_8);
  }
  
  
  
  grayscale = cdst; //
  
//  if (lines.size() >= 4) // we found the 4 sides
//  {
    vector<Vec3f> params(4);
    for (int l = 0; l < 4; l++)
    {
      params.push_back(calc_params(Point(lines[l][0], lines[l][1]), Point(lines[l][2], lines[l][3])));
    }
    
    vector<Point> corners;
    for (int i = 0; i < params.size(); i++)
    {
      for (int j = i; j < params.size(); j++) // j starts at i so we don't have duplicated points
      {
        Point intersec = find_intersection(params[i], params[j]);
        if ((intersec.x > 0) && (intersec.y > 0) && (intersec.x < grayscale.cols) && (intersec.y < grayscale.rows))
        {
          corners.push_back(intersec);
        }
      }
    }
    
    for (int i = 0; i < corners.size(); i++)
    {
      circle(output, corners[i], 3, Scalar(0, 0, 255));
    }
    
    if (corners.size() == 4) // we have the 4 final corners
    {
      return(corners);
    }
//  }
  return(vector<Point>());
}
