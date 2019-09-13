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
#if DEBUG==1
  return NO;
#else
  return YES;
#endif
}

@end
