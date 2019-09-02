//
//  OpenCVWrapper.h
//  bachelorthesis
//
//  Created by  Erik Maximilian Martens on 02.09.19.
//  Copyright © 2019  Erik Maximilian Martens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

@interface OpenCVScannerBridge : NSObject
  
+ (NSString * _Nonnull)openCVVersionString;
  
- (CGPathRef * _Nullable)extractDocumentFrom:(CMSampleBufferRef _Nonnull)sampleBuffer;
- (UIImage * _Nonnull)extractEdgesFrom:(CMSampleBufferRef _Nonnull)sampleBuffer withOrientation:(AVCaptureVideoOrientation)imageOrientation;
  
@end
