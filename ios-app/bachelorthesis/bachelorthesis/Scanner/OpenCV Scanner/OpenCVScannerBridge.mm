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
  
//- (CGPathRef * _Nullable)extractDocumentFrom:(CMSampleBufferRef _Nonnull)sampleBuffer
//    {
//      CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//      CVPixelBufferLockBaseAddress(imageBuffer, 0);
//      int bufferHeight = (int) CVPixelBufferGetHeight(imageBuffer);
//      int bufferWidth = (int) CVPixelBufferGetWidth(imageBuffer);
//      void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
//      size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
//      const cv::Mat image {bufferHeight, bufferWidth, CV_8UC4, (void *)baseAddress, bytesPerRow};
//
//      const cv::Mat grayImage;
//      cv::cvtColor(image, grayImage, cv::COLOR_RGBA2GRAY);
//
//      cv::Mat edges;
//      cv::Canny(grayImage, edges, 0, 50);
//
////      std::vector<OcrWord> candidates = self.extractionBarcode->extract(image, [@"" UTF8String]);
////      SCExtractionBarcodeResult *result = [[SCExtractionBarcodeResult alloc] init];
////      if (candidates.size() > 0) {
////        OcrWord candidate = candidates[0];
////        result.cardNumber = [NSString stringWithCString:candidate.text.c_str() encoding:[NSString defaultCStringEncoding]];
////        result.confidence = candidate.confidence;
////        result.barcodeFormat = [[BarcodeFormat alloc] initWithManateeType:candidate.barcodeTypeCode];
////      }
//
//      CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
//      return result;
//      return nil;
//    }
  
  - (UIImage * _Nonnull)extractEdgesFrom:(CMSampleBufferRef _Nonnull)sampleBuffer withOrientation:(AVCaptureVideoOrientation)imageOrientation
  {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    int bufferHeight = (int) CVPixelBufferGetHeight(imageBuffer);
    int bufferWidth = (int) CVPixelBufferGetWidth(imageBuffer);
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    const cv::Mat image {bufferHeight, bufferWidth, CV_8UC4, (void *)baseAddress, bytesPerRow};
    
    cv::Mat grayImage;
    cv::cvtColor(image, grayImage, cv::COLOR_RGBA2GRAY);
    
    cv::Mat edges;
    cv::Canny(grayImage, edges, 0, 50);
    
    cv::Mat edgesFlipped;
    switch (imageOrientation)
    {
      case AVCaptureVideoOrientationPortrait:
      cv::rotate(edges, edgesFlipped, cv::ROTATE_90_CLOCKWISE);
      break;
      case AVCaptureVideoOrientationPortraitUpsideDown:
      cv::rotate(edges, edgesFlipped, cv::ROTATE_90_CLOCKWISE);
      break;
      case AVCaptureVideoOrientationLandscapeRight:
      cv::rotate(edges, edgesFlipped, cv::ROTATE_90_CLOCKWISE);
      break;
      case AVCaptureVideoOrientationLandscapeLeft:
      cv::rotate(edges, edgesFlipped, cv::ROTATE_90_CLOCKWISE);
      break;
    }
    
    return MatToUIImage(edgesFlipped);
  }
  
@end
