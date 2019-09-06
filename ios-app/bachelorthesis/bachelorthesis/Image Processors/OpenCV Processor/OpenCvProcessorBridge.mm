//
//  OpenCVWrapper.m
//  bachelorthesis
//
//  Created by  Erik Maximilian Martens on 02.09.19.
//  Copyright © 2019  Erik Maximilian Martens. All rights reserved.
//

//#import "Stocard-Swift.h"
#import "OpenCvProcessorBridge.h"

#include <opencv2/opencv.hpp>
#include <opencv2/imgcodecs/ios.h>
#include "LoyaltyCardDetector.hpp"
#include "Utilities.hpp"

@implementation OpenCvProcessorBridge

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

- (UIImage * _Nullable)extractLoyaltyCardImage:(UIImage * _Nonnull)image
{
  int imageHeight = (int) image.size.height;
  int imageWidth = (int) image.size.width;
  cv::Mat imageMat {imageHeight, imageWidth, CV_8UC4};
  
  UIImageToMat(image, imageMat);
//  LoyaltyCardDetector::extract_loyalty_card_from(imageMat);
  LoyaltyCardDetector::extract_card_from(imageMat);
  return MatToUIImage(imageMat);
}

- (UIImage * _Nonnull)extractSquaresFrom:(CMSampleBufferRef _Nonnull)sampleBuffer withOrientation:(AVCaptureVideoOrientation)imageOrientation
{
  CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
  CVPixelBufferLockBaseAddress(imageBuffer, 0);
  int bufferHeight = (int) CVPixelBufferGetHeight(imageBuffer);
  int bufferWidth = (int) CVPixelBufferGetWidth(imageBuffer);
  void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
  size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
  cv::Mat image {bufferHeight, bufferWidth, CV_8UC4, (void *)baseAddress, bytesPerRow};
  
  LoyaltyCardDetector::detect_squares(image);
  
  cv::Mat image_flipped;
  switch (imageOrientation)
  {
    case AVCaptureVideoOrientationPortrait:
      cv::rotate(image, image_flipped, cv::ROTATE_90_CLOCKWISE);
      break;
    case AVCaptureVideoOrientationPortraitUpsideDown:
      cv::rotate(image, image_flipped, cv::ROTATE_90_CLOCKWISE);
      break;
    case AVCaptureVideoOrientationLandscapeRight:
      cv::rotate(image, image_flipped, cv::ROTATE_90_CLOCKWISE);
      break;
    case AVCaptureVideoOrientationLandscapeLeft:
      cv::rotate(image, image_flipped, cv::ROTATE_90_CLOCKWISE);
      break;
  }
  
  return MatToUIImage(image_flipped);
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
  Utilities::downscale_image_by_factor(scaleFactor, image);
  
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
  
  Utilities::upscale_image_by_factor(scaleFactor, edges_flipped);
  return MatToUIImage(edges_flipped);
}

@end
