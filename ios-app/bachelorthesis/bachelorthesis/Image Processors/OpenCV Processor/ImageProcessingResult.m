//
//  ImageProcessingResult.m
//  bachelorthesis
//
//  Created by Erik Maximilian Martens on 12.09.19.
//  Copyright © 2019  Erik Maximilian Martens. All rights reserved.
//

#import "ImageProcessingResult.h"

@implementation ImageProcessingResult

//- (instancetype)init
//{
//  return [super init];
//}

- (instancetype)initWithCroppedImage:(UIImage *)croppedImage
                       contoursImage:(UIImage *)contoursImage
                  intersectionsImage:(UIImage *)intersectionsImage {
  self = [super init];
  if (self) {
    _croppedImage = croppedImage;
    _contoursImage = contoursImage;
    _intersectionsImage = intersectionsImage;
  }
  return self;
}

-(BOOL)hasContent
{
  return !(!self.croppedImage && !self.contoursImage && !self.intersectionsImage);
}

@end
