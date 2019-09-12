//
//  BuildEnvironment.m
//  bachelorthesis
//
//  Created by Erik Maximilian Martens on 12.09.19.
//  Copyright © 2019  Erik Maximilian Martens. All rights reserved.
//

#import "BuildEnvironment.h"

@implementation BuildEnvironment

+ (BOOL)isReleaseEvironment
{
#if RELEASE==1
  return YES;
#else
  return NO;
#endif
}

@end
