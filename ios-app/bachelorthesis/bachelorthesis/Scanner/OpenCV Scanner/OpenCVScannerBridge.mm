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
#include "Utilities.hpp"

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
  
  cv::Mat image {bufferHeight, bufferWidth, CV_8UC4, (void *)baseAddress, bytesPerRow};
  cv::Mat canvas {bufferHeight, bufferWidth, CV_8UC4};
  
  //    const int scaleFactor = Utilities::downscaleImageByFactor(5, image);
  
  vector<vector<cv::Point> > detected_squares;
  findSquares(image, detected_squares);
  drawSquares(canvas, detected_squares);
  
  cv::Mat canvas_flipped;
  switch (imageOrientation)
  {
    case AVCaptureVideoOrientationPortrait:
      cv::rotate(canvas, canvas_flipped, cv::ROTATE_90_CLOCKWISE);
      break;
    case AVCaptureVideoOrientationPortraitUpsideDown:
      cv::rotate(canvas, canvas_flipped, cv::ROTATE_90_CLOCKWISE);
      break;
    case AVCaptureVideoOrientationLandscapeRight:
      cv::rotate(canvas, canvas_flipped, cv::ROTATE_90_CLOCKWISE);
      break;
    case AVCaptureVideoOrientationLandscapeLeft:
      cv::rotate(canvas, canvas_flipped, cv::ROTATE_90_CLOCKWISE);
      break;
  }
  
  return MatToUIImage(canvas_flipped);
  
  //    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
  //    CVPixelBufferLockBaseAddress(imageBuffer, 0);
  //    int bufferHeight = (int) CVPixelBufferGetHeight(imageBuffer);
  //    int bufferWidth = (int) CVPixelBufferGetWidth(imageBuffer);
  //    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
  //    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
  //    const cv::Mat image {bufferHeight, bufferWidth, CV_8UC4, (void *)baseAddress, bytesPerRow};
  //
  //    vector<vector<cv::Point> > detected_quadrangles;
  //    findQudrangles(image, detected_quadrangles);
  //
  //    cv::Mat image_flipped;
  //    switch (imageOrientation)
  //    {
  //        case AVCaptureVideoOrientationPortrait:
  //            cv::rotate(image, image_flipped, cv::ROTATE_90_CLOCKWISE);
  //            break;
  //        case AVCaptureVideoOrientationPortraitUpsideDown:
  //            cv::rotate(image, image_flipped, cv::ROTATE_90_CLOCKWISE);
  //            break;
  //        case AVCaptureVideoOrientationLandscapeRight:
  //            cv::rotate(image, image_flipped, cv::ROTATE_90_CLOCKWISE);
  //            break;
  //        case AVCaptureVideoOrientationLandscapeLeft:
  //            cv::rotate(image, image_flipped, cv::ROTATE_90_CLOCKWISE);
  //            break;
  //    }
  //
  //    return MatToUIImage(image_flipped);
}

- (UIImage * _Nonnull)extractEdgesFrom:(CMSampleBufferRef _Nonnull)sampleBuffer withOrientation:(AVCaptureVideoOrientation)imageOrientation
{
  CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
  CVPixelBufferLockBaseAddress(imageBuffer, 0);
  int bufferHeight = (int) CVPixelBufferGetHeight(imageBuffer);
  int bufferWidth = (int) CVPixelBufferGetWidth(imageBuffer);
  void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
  size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
  
  cv::Mat image {bufferHeight, bufferWidth, CV_8UC4, (void *)baseAddress, bytesPerRow};
  
  // downscale image to reduce compute time
  const int scaleFactor = 2;
  Utilities::downscaleImageByFactor(scaleFactor, image);
  
  cv::cvtColor(image, image, cv::COLOR_RGBA2GRAY);
  cv::GaussianBlur(image, image, cv::Size(5,5), 1.2);
  cv::Canny(image, image, 0, 50);
  
  cv::Mat edges_flipped;
  switch (imageOrientation)
  {
    case AVCaptureVideoOrientationPortrait:
      cv::rotate(image, edges_flipped, cv::ROTATE_90_CLOCKWISE);
      break;
    case AVCaptureVideoOrientationPortraitUpsideDown:
      cv::rotate(image, edges_flipped, cv::ROTATE_90_CLOCKWISE);
      break;
    case AVCaptureVideoOrientationLandscapeRight:
      cv::rotate(image, edges_flipped, cv::ROTATE_90_CLOCKWISE);
      break;
    case AVCaptureVideoOrientationLandscapeLeft:
      cv::rotate(image, edges_flipped, cv::ROTATE_90_CLOCKWISE);
      break;
  }
  
  Utilities::upscaleImageByFactor(scaleFactor, edges_flipped);
  return MatToUIImage(edges_flipped);
}

@end
