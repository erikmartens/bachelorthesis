//
//  OpenCVWrapper.m
//  bachelorthesis
//
//  Created by  Erik Maximilian Martens on 02.09.19.
//  Copyright © 2019  Erik Maximilian Martens. All rights reserved.
//

//#import "Stocard-Swift.h"
#import "OpenCVScannerBridge.h"

#import <opencv2/opencv.hpp>
#include <opencv2/imgcodecs/ios.h>
#include "squares.cpp"

@implementation OpenCVScannerBridge
  
# pragma mark Initiliazation
  
- (id)init
  {
    self = [super init];
    
    if (self)
    {
      
    }
    return self;
  }
  
# pragma mark Static Functions
  
+ (NSString *)openCVVersionString
  {
    return [NSString stringWithFormat:@"OpenCV Version %s",  CV_VERSION];
  }
  
# pragma mark Functions
  
- (UIImage * _Nonnull)extractSquaresFrom:(CMSampleBufferRef _Nonnull)sampleBuffer withOrientation:(AVCaptureVideoOrientation)imageOrientation
    {
      CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
      CVPixelBufferLockBaseAddress(imageBuffer, 0);
      int bufferHeight = (int) CVPixelBufferGetHeight(imageBuffer);
      int bufferWidth = (int) CVPixelBufferGetWidth(imageBuffer);
      void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
      size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
      const cv::Mat image {bufferHeight, bufferWidth, CV_8UC4, (void *)baseAddress, bytesPerRow};
  
      vector<vector<cv::Point> > detected_squares;
      findSquares(image, detected_squares);
      
      cv::Mat squares_image = image;
      drawSquares(squares_image, detected_squares);

      cv::Mat squares_flipped;
      switch (imageOrientation)
      {
        case AVCaptureVideoOrientationPortrait:
        cv::rotate(squares_image, squares_flipped, cv::ROTATE_90_CLOCKWISE);
        break;
        case AVCaptureVideoOrientationPortraitUpsideDown:
        cv::rotate(squares_image, squares_flipped, cv::ROTATE_90_CLOCKWISE);
        break;
        case AVCaptureVideoOrientationLandscapeRight:
        cv::rotate(squares_image, squares_flipped, cv::ROTATE_90_CLOCKWISE);
        break;
        case AVCaptureVideoOrientationLandscapeLeft:
        cv::rotate(squares_image, squares_flipped, cv::ROTATE_90_CLOCKWISE);
        break;
      }

      return MatToUIImage(squares_flipped);
    }

  - (UIImage * _Nonnull)extractEdgesFrom:(CMSampleBufferRef _Nonnull)sampleBuffer withOrientation:(AVCaptureVideoOrientation)imageOrientation
  {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    int bufferHeight = (int) CVPixelBufferGetHeight(imageBuffer);
    int bufferWidth = (int) CVPixelBufferGetWidth(imageBuffer);
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    const cv::Mat image {bufferHeight, bufferWidth, CV_8UC4, (void *)baseAddress, bytesPerRow};
    
    cv::Mat gray_image;
    cv::cvtColor(image, gray_image, cv::COLOR_RGBA2GRAY);
    cv::GaussianBlur(gray_image, gray_image, cv::Size(5,5), 1.2);
    
    cv::Mat edges;
    cv::Canny(gray_image, edges, 0, 50);
    
    cv::Mat edges_flipped;
    switch (imageOrientation)
    {
      case AVCaptureVideoOrientationPortrait:
      cv::rotate(edges, edges_flipped, cv::ROTATE_90_CLOCKWISE);
      break;
      case AVCaptureVideoOrientationPortraitUpsideDown:
      cv::rotate(edges, edges_flipped, cv::ROTATE_90_CLOCKWISE);
      break;
      case AVCaptureVideoOrientationLandscapeRight:
      cv::rotate(edges, edges_flipped, cv::ROTATE_90_CLOCKWISE);
      break;
      case AVCaptureVideoOrientationLandscapeLeft:
      cv::rotate(edges, edges_flipped, cv::ROTATE_90_CLOCKWISE);
      break;
    }
    
    return MatToUIImage(edges_flipped);
  }
  
@end
