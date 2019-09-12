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

# pragma mark Public

bool LoyaltyCardDetector::extract_card_from(Mat &sourceImage, Mat &outputImage, Mat &debugContoursImage, Mat &debugHoughLinesImage, Mat &debugIntersectionsImage,  Mat &debugVerticesImage)
{
  /// identify contours in image
  vector<vector<Point>> contours;
  find_potential_card_contours(sourceImage, contours);
  
  /// sort most promising contours to top
  vector<int> indices(contours.size());
  for ( int i = 0; i < contours.size(); i++ )
  {
    indices[i] = i;
  }
  sort(indices.begin(), indices.end(), [&contours](int lhs, int rhs) {
    return contours[lhs].size() < contours[rhs].size()
    && contourArea(contours[lhs]) > contourArea(contours[rhs]);
  });
  
  /// identify quadrangles from contours
  vector<Mat> debugContoursOutputs;
  vector<Mat> debugIntersectionPointsOutputs;
  vector<Mat> debugHoughLinesOutputs;
  vector<Mat> debugVerticesOutputs;
 
  vector<vector<Point> > potentialCardVertices;
  
  for (int i = 0; i < contours.size(); i++)
  {
    Mat debugContoursOutput;
    Mat debugIntersectionPointsOutput;
    Mat debugHoughLinesOutput;
    Mat debugVerticesOutput;
    
    vector<Point> quadrangle;
    quadrangle.clear();
    
    identify_quadrangle_from_contour(contours[indices[i]], quadrangle, sourceImage.cols, sourceImage.rows, debugContoursOutput, debugIntersectionPointsOutput, debugHoughLinesOutput, debugVerticesOutput);
    
    if (quadrangle.size() == 4)
    {
      debugContoursOutputs.push_back(debugContoursOutput);
      debugIntersectionPointsOutputs.push_back(debugIntersectionPointsOutput);
      debugHoughLinesOutputs.push_back(debugHoughLinesOutput);
      
      potentialCardVertices.push_back(quadrangle);
    }
  }
  
  /// no vertices at all were found -> can't cut out anything
  if (potentialCardVertices.size() == 0) {
    return false;
  }
  
  /// find best matching quadrangle
  vector<Point> bestQuadrangle;
  int selectedIndex = find_best_matching_quadrangle_from_quadrangles(potentialCardVertices, bestQuadrangle);
  
  // best effort quadrangle is used
  if (bestQuadrangle.size() == 0) {
    selectedIndex = 0;
    bestQuadrangle = potentialCardVertices[0];
  }
  
#if DEBUG==1

  if (selectedIndex != -1)
  {
    if (debugContoursOutputs.size() > selectedIndex) debugContoursImage = debugContoursOutputs[selectedIndex];
    if (debugHoughLinesOutputs.size() > selectedIndex) debugHoughLinesImage = debugHoughLinesOutputs[selectedIndex];
    if (debugIntersectionPointsOutputs.size() > selectedIndex) debugIntersectionsImage = debugIntersectionPointsOutputs[selectedIndex];
    if (debugVerticesOutputs.size() > selectedIndex) debugVerticesImage = debugVerticesOutputs[selectedIndex];
  }
#endif
  
  // TODO homography
  // We don't need to find homography since we know the 4 vertices and the original aspect ratio
  four_points_transform(outputImage, bestQuadrangle);
  return true;
}

# pragma mark Private

double LoyaltyCardDetector::toleranceThreshold = 0.95;

# pragma mark Detection

// TODO add binarization
void LoyaltyCardDetector::find_potential_card_contours(Mat& image, vector<vector<Point> >& contours)
{
  int thresh = 50, N = 11;
  
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
        
        // approximate contour with accuracy proportional to the contour perimeter
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
        if (approximatedCorners.size() == 4 && isContourConvex(approximatedCorners))
        {
          double maxCosine = 0;
          
          for (int j = 2; j < 5; j++)
          {
            // find the maximum cosine of the angle between joint edges
            double cosine = fabs(angle(approximatedCorners[j%4], approximatedCorners[j-2], approximatedCorners[j-1]));
            maxCosine = MAX(maxCosine, cosine);
          }
          
          // if cosines of all angles are small
          // (all angles are ~90 degree) then write contour
          // vertices to resultant sequence
          if ( maxCosine < 0.3 )
            contours.push_back(allIndentifiedContours[i]);
        }
      }
    }
  }
}

void LoyaltyCardDetector::identify_quadrangle_from_contour(vector<Point> &contour, vector<Point> &vertices, int imageWidth, int imageHeight, Mat &debugContoursOutput, Mat &debugIntersectionsOutput, Mat &debugHoughLinesOutput, Mat &debugVerticesOutput)
{
  /// Find the convex hull object
  Mat convexHull_mask(imageHeight, imageWidth, CV_8UC1);
  convexHull_mask = Scalar(0);
  vector<vector<Point> >hull(1);
  convexHull(Mat(contour), hull[0], false);
  
  /// find hough lines of convex hull
  vector<Vec4i> lines;
  drawContours(convexHull_mask, hull, 0, Scalar(255), 5, LINE_AA);
  HoughLinesP(convexHull_mask, lines, 1, CV_PI / 80, 100, 30, 10);
  
  /// find intersection points of all lines
  vector<Point> intersections;
  get_intersections(lines, intersections, imageWidth, imageHeight);
  
  /// filter down to 4 cornerpoints of quadrangle
  vector<Point> finalVertices;
  filter_intersections_for_vertices(intersections, finalVertices, imageWidth, imageHeight);
  
  /// only return results if we have exactly corner points
  if (finalVertices.size() == 4)
  {
    vertices = finalVertices;
  }
  
#if DEBUG==1
  /// DEBUG
  Mat contoursOutput(imageHeight, imageWidth, CV_8UC1);
  contoursOutput = Scalar(0);
  draw_points(contour, contoursOutput);
  debugContoursOutput = contoursOutput;
  
  Mat linesOutput(imageHeight, imageWidth, CV_8UC1);
  linesOutput = Scalar(0);
  draw_vectors(lines, linesOutput);
  debugHoughLinesOutput = linesOutput;
  
  Mat intersectionsOutput(imageHeight, imageWidth, CV_8UC1);
  intersectionsOutput = Scalar(0);
  draw_points(intersections, intersectionsOutput);
  debugIntersectionsOutput = intersectionsOutput;
  
  Mat verticesOutput(imageHeight, imageWidth, CV_8UC1);
  verticesOutput = Scalar(0);
  draw_points(finalVertices, verticesOutput);
  debugVerticesOutput = verticesOutput;
#endif

}

int LoyaltyCardDetector::find_best_matching_quadrangle_from_quadrangles(vector<vector<Point> > &quadrangles, vector<Point> &bestQudrangle)
{
  int selectedIndexForGroup0 = -1;
  int selectedIndexForGroup1 = -1;
  int selectedIndexForGroup2 = -1;
  int selectedIndexForGroup3 = -1;
  
  vector<vector<Point>> currentBestQuadrangleGroup0;
  vector<vector<Point>> currentBestQuadrangleGroup1;
  vector<vector<Point>> currentBestQuadrangleGroup2;
  vector<vector<Point>> currentBestQuadrangleGroup3;
  
  /// iterate over every corner
  for (int i = 0; i < quadrangles.size(); i++)
  {
    vector<Point> quadrangle = quadrangles[i];
    order_points(quadrangle);
    
    Vec4i topHorizontalLine = Vec4i(quadrangle[0].x, quadrangle[0].y, quadrangle[1].x, quadrangle[1].y);
    Vec4i bottomHorizontalLine = Vec4i(quadrangle[2].x, quadrangle[2].y, quadrangle[3].x, quadrangle[3].y);
    Vec4i leftVerticalLine = Vec4i(quadrangle[0].x, quadrangle[0].y, quadrangle[2].x, quadrangle[2].y);
    Vec4i rightVerticalLine = Vec4i(quadrangle[1].x, quadrangle[1].y, quadrangle[3].x, quadrangle[3].y);
    
    double slopeTopHorizontalLine = line_slope(topHorizontalLine);
    double slopeBottomHorizontalLine = line_slope(bottomHorizontalLine);
    double slopeLeftVerticalLine = line_slope(leftVerticalLine);
    double slopeRightVerticalLine = line_slope(rightVerticalLine);
    
    bool slopesTopBottomAreSimilar = ((slopeTopHorizontalLine >= 0.0 && slopeBottomHorizontalLine >= 0.0) || (slopeTopHorizontalLine <= 0.0 && slopeBottomHorizontalLine <= 0.0)) && (slopeBottomHorizontalLine*toleranceThreshold <= slopeTopHorizontalLine <= slopeBottomHorizontalLine || slopeTopHorizontalLine*toleranceThreshold <= slopeBottomHorizontalLine <= slopeTopHorizontalLine);
    bool slopesLeftRightAreSimilar = ((slopeLeftVerticalLine >= 0.0 && slopeRightVerticalLine >= 0.0) || (slopeLeftVerticalLine <= 0.0 && slopeRightVerticalLine <= 0.0)) && (slopeRightVerticalLine*toleranceThreshold <= slopeLeftVerticalLine <= slopeRightVerticalLine || slopeLeftVerticalLine*toleranceThreshold <= slopeRightVerticalLine <= slopeLeftVerticalLine);
    
    bool slopesTopBottomAreOpposite = ((slopeTopHorizontalLine >= 0.0 && slopeBottomHorizontalLine < 0.0) || (slopeTopHorizontalLine < 0.0 && slopeBottomHorizontalLine >= 0.0)) && (fabs(slopeBottomHorizontalLine)*toleranceThreshold <= fabs(slopeTopHorizontalLine) <= fabs(slopeBottomHorizontalLine) || fabs(slopeTopHorizontalLine)*toleranceThreshold <= fabs(slopeBottomHorizontalLine) <= fabs(slopeTopHorizontalLine));
    bool slopesLeftRightAreOpposite = ((slopeLeftVerticalLine >= 0.0 && slopeRightVerticalLine < 0.0) || (slopeLeftVerticalLine < 0.0 && slopeRightVerticalLine >= 0.0)) && (fabs(slopeRightVerticalLine)*toleranceThreshold <= fabs(slopeLeftVerticalLine) <= fabs(slopeRightVerticalLine) || fabs(slopeLeftVerticalLine)*toleranceThreshold <= fabs(slopeRightVerticalLine) <= fabs(slopeLeftVerticalLine));
    
    vector<double> angle_cosines;
    angle_cosines.push_back(fabs(angle(quadrangle[2], quadrangle[0], quadrangle[1])));
    angle_cosines.push_back(fabs(angle(quadrangle[3], quadrangle[1], quadrangle[2])));
    angle_cosines.push_back(fabs(angle(quadrangle[0], quadrangle[2], quadrangle[3])));
    angle_cosines.push_back(fabs(angle(quadrangle[1], quadrangle[0], quadrangle[3])));
    
    /// sorting into groups
    /// group 0 - 2x parallel sides, 4x 90° corner angles
    /// cos(90) = 0, cos(85) ~ 0.087, cos(95) ~ -0.87
    if (slopesTopBottomAreSimilar
        && slopesLeftRightAreSimilar
        && fabs(angle_cosines[0]) < 0.075
        && fabs(angle_cosines[1]) < 0.075
        && fabs(angle_cosines[2]) < 0.075
        && fabs(angle_cosines[3]) < 0.075)
    {
      if (selectedIndexForGroup0 == -1) selectedIndexForGroup0 = i;
      currentBestQuadrangleGroup0.push_back(quadrangle);
    }
    /// group 1 - 1x parallel sides, 1x opposite slope sides, 2x same corner angle
    else if (((slopesTopBottomAreSimilar && slopesLeftRightAreOpposite)
        || (slopesLeftRightAreSimilar && slopesTopBottomAreOpposite))
        && two_times_same_corner_angles(angle_cosines))
    {
      if (selectedIndexForGroup1 == -1) selectedIndexForGroup1 = i;
      currentBestQuadrangleGroup1.push_back(quadrangle);
    }
    /// group 2 - 2x parallel sides, 2x same corner angle
    else if (slopesTopBottomAreSimilar
             && slopesLeftRightAreSimilar
             && two_times_same_corner_angles(angle_cosines))
    {
      if (selectedIndexForGroup2 == -1) selectedIndexForGroup2 = i;
      currentBestQuadrangleGroup2.push_back(quadrangle);
    }
    /// group 3 - 1x parallel sides
    else if (slopesTopBottomAreSimilar
             || slopesLeftRightAreSimilar)
    {
      if (selectedIndexForGroup3 == -1) selectedIndexForGroup3 = i;
      currentBestQuadrangleGroup3.push_back(quadrangle);
    }
  }
  
  /// finished - ouput return value if available
  if (currentBestQuadrangleGroup0.size() > 0)
  {
    bestQudrangle = currentBestQuadrangleGroup0[0];
    return selectedIndexForGroup0;
  }
  else if (currentBestQuadrangleGroup1.size() > 0)
  {
    bestQudrangle = currentBestQuadrangleGroup1[0];
    return selectedIndexForGroup1;
  }
  else if (currentBestQuadrangleGroup2.size() > 0)
  {
    bestQudrangle = currentBestQuadrangleGroup2[0];
    return selectedIndexForGroup2;
  }
  else if (currentBestQuadrangleGroup3.size() > 0)
  {
    bestQudrangle = currentBestQuadrangleGroup3[0];
    return selectedIndexForGroup3;
  }
  return -1;
}

# pragma mark Detection Helpers

double LoyaltyCardDetector::loyalty_card_corner_radius(double arclength)
{
  return arclength / (6283.0/87.0 + 2*M_PI);
}

double LoyaltyCardDetector::max_epsilon_factor(double arclength, double cornerRadius)
{
  double arcLengthBoundingRect = arclength - 2*cornerRadius*M_PI + 8*cornerRadius;
  return arcLengthBoundingRect/arclength - 1;
}

# pragma mark Warping

void LoyaltyCardDetector::four_points_transform(Mat &image, vector<Point> vertices)
{
  Point2f currentVertices2f[4];
  vector<Point> verticesOrdered = order_points(vertices);
  std::copy(verticesOrdered.begin(), verticesOrdered.end(), currentVertices2f);
  Point tl = currentVertices2f[0];
  Point tr = currentVertices2f[1];
  Point bl = currentVertices2f[2];
  Point br = currentVertices2f[3];
  
  float widthA, widthB, maxWidth;
  float heightA, heightB, maxHeight;
  
  // compute the width of the new image, which will be the
  // maximum distance between bottom-right and bottom-left
  // x-coordiates or the top-right and top-left x-coordinates
  widthA = sqrt((pow((br.x - bl.x), 2)) + (pow((br.y - bl.y), 2)));
  widthB = sqrt((pow((tr.x - tl.x), 2)) + (pow((tr.y - tl.y), 2)));
  maxWidth = max(int(widthA), int(widthB));
  
  // compute the height of the new image, which will be the
  // maximum distance between the top-right and bottom-right
  // y-coordinates or the top-left and bottom-left y-coordinates
  heightA = sqrt((pow((tr.x - br.x), 2)) + (pow((tr.y - br.y), 2)));
  heightB = sqrt((pow((tl.x - bl.x), 2)) + (pow((tl.y - bl.y), 2)));
  maxHeight = max(int(heightA), int(heightB));
  maxHeight = (5398.0f/8560.0f) * maxWidth; // override for card aspect ratio
  
  Point2f destinationVertices[4];
  destinationVertices[0] = Point(0,0);
  destinationVertices[1] = Point(maxWidth-1,0);
  destinationVertices[2] = Point(0, maxHeight-1);
  destinationVertices[3] = Point(maxWidth-1,maxHeight-1);
  
  Mat warpMatrix = getPerspectiveTransform(currentVertices2f, destinationVertices);
  
  Mat rotated;
  Size size(maxWidth, maxHeight);
  warpPerspective(image, rotated, warpMatrix, size, INTER_LINEAR, BORDER_CONSTANT);
  image = rotated;
}

# pragma mark Utilities

double LoyaltyCardDetector::angle(Point pt1, Point pt2, Point pt0)
{
  double dx1 = pt1.x - pt0.x;
  double dy1 = pt1.y - pt0.y;
  double dx2 = pt2.x - pt0.x;
  double dy2 = pt2.y - pt0.y;
  return (dx1*dx2 + dy1*dy2)/sqrt((dx1*dx1 + dy1*dy1)*(dx2*dx2 + dy2*dy2) + 1e-10);
}

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

double LoyaltyCardDetector::line_slope(Vec4i line)
{
  return ( (double) line[3] - (double) line[1] ) / ( (double) line[2] - (double) line[0] );
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

bool LoyaltyCardDetector::get_intersection(const Vec4i &line_a, const Vec4i &line_b, Point &intersection)
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
  
  double slopeA = line_slope(line_a);
  double slopeB = line_slope(line_b);
  
  if (inter[2] == 0 || fabs(fabs(slopeA) - fabs(slopeB)) < 5.0 )
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

array<int, 3> LoyaltyCardDetector::cross(const array<int, 3> &a, const array<int, 3> &b)
{
  array<int, 3> result;
  result[0] = a[1] * b[2] - a[2] * b[1];
  result[1] = a[2] * b[0] - a[0] * b[2];
  result[2] = a[0] * b[1] - a[1] * b[0];
  return result;
}

void LoyaltyCardDetector::filter_intersections_for_vertices(vector<Point> &intersections, vector<Point> &vertices, int imageWidth, int imageHeight)
{
  /// not enough intersections found
  if (intersections.size() < 4)
  {
    return;
  }
  
  /// remove duplicates
  auto iterator = unique(intersections.begin(), intersections.end(), [](const Point& lhsP, const Point& rhsP) {
    return lhsP.x == rhsP.x && lhsP.y == rhsP.y;
  });
  intersections.erase(iterator, intersections.end());
  
  /// find cluster centers
  vector<Point2f> intersections2f;
  for (int i = 0; i < intersections.size(); i++ )
  {
    intersections2f.push_back(static_cast<Point2f>(intersections[i]));
  }
  
  vector<int> clusterIndices;
  vector<Point2f> results2f;
  kmeans(intersections2f, 4, clusterIndices, TermCriteria(TermCriteria::EPS+TermCriteria::COUNT, 20, 1.0), 3, KMEANS_PP_CENTERS, results2f);
  
  /// convert to cv::Point
  vector<Point> results;
  for ( int i = 0; i < results2f.size(); i++ )
  {
    vertices.push_back(results2f[i]);
  }
  
  // find closest actual points
}

bool LoyaltyCardDetector::two_times_same_corner_angles(vector<double> &cosines)
{
  /// only calculate if we have 4 corner angles
  if (cosines.size() != 4)
  {
    return false;
  }
  
  int count = 0;
  for (int i = 0; i < 4; i++)
  {
    double cosine = cosines[i];
    for (int j = 0; j < 4; j++)
    {
      if ((cosines[i]*toleranceThreshold <= cosine <= cosines[i] || cosine*toleranceThreshold <= cosines[i] <= cosine)
          && cosine <= cosines[i])
      {
        count++;
      }
    }
  }
  if (count != 2)
  {
    return false;
  }
  return true;
}

# pragma mark Drawing

void LoyaltyCardDetector::draw_square( const Mat& image, const vector<Point>& square )
{
  const Point* p = &square[0];
  int n = (int) square.size();
  polylines(image, &p, &n, 1, true, Scalar(0,0,255), 5, LINE_AA);
}

void LoyaltyCardDetector::draw_vectors(vector<Vec4i> &lines, Mat &destination)
{
  for (size_t i = 0; i < lines.size(); i++)
  {
    Vec4i l = lines[i];
    line(destination, Point(l[0], l[1]), Point(l[2], l[3]), Scalar(255), 5, LINE_8);
  }
}

void LoyaltyCardDetector::draw_points(vector<Point> &points, Mat &destination)
{
  for (size_t i = 0; i < points.size(); i++)
  {
    circle(destination, points[i], 20, Scalar(255), 5);
  }
}
