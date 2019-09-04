//
//  OpenCVScannerBridge.h
//  bachelorthesis
//
//  Created by  Erik Maximilian Martens on 02.09.19.
//  Copyright © 2019  Erik Maximilian Martens. All rights reserved.
//

#ifndef OpenCVScannerBridge_h
#define OpenCVScannerBridge_h

#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

@interface OpenCVScannerBridge : NSObject

+ (NSString * _Nonnull)openCVVersionString;

- (UIImage * _Nullable)extractLoyaltyCardImage:(UIImage * _Nonnull)image;

- (UIImage * _Nonnull)extractSquaresFrom:(CMSampleBufferRef _Nonnull)sampleBuffer withOrientation:(AVCaptureVideoOrientation)imageOrientation;
- (UIImage * _Nonnull)extractEdgesFrom:(CMSampleBufferRef _Nonnull)sampleBuffer withOrientation:(AVCaptureVideoOrientation)imageOrientation;

@end

#endif /* OpenCVScannerBridge_h */
