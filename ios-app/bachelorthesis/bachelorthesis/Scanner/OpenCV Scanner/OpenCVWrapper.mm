//
//  OpenCVWrapper.m
//  bachelorthesis
//
//  Created by  Erik Maximilian Martens on 02.09.19.
//  Copyright © 2019  Erik Maximilian Martens. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import "OpenCVWrapper.h"

@implementation OpenCVWrapper
  
+ (NSString *)openCVVersionString {
  return [NSString stringWithFormat:@"OpenCV Version %s",  CV_VERSION];
}

@end
