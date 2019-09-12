//
//  OpenCVScannerBridge.h
//  bachelorthesis
//
//  Created by  Erik Maximilian Martens on 02.09.19.
//  Copyright © 2019  Erik Maximilian Martens. All rights reserved.
//

#ifndef OpenCVScannerBridge_h
#define OpenCVScannerBridge_h

#import "ImageProcessingResult.h"

#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

@interface OpenCvProcessorBridge : NSObject

- (ImageProcessingResult * _Nonnull)extractLoyaltyCardImage:(UIImage * _Nonnull)image;

- (UIImage * _Nullable)liveExtractEdgesFrom:(CMSampleBufferRef _Nonnull)sampleBuffer withOrientation:(AVCaptureVideoOrientation)imageOrientation;
- (UIImage * _Nullable)liveExtractHoughLinesFrom:(CMSampleBufferRef _Nonnull)sampleBuffer withOrientation:(AVCaptureVideoOrientation)imageOrientation;

@end

#endif /* OpenCVScannerBridge_h */
