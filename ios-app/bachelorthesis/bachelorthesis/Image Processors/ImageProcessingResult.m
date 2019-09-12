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
                     houghLinesImage:(UIImage *)houghLinesImage
                  intersectionsImage:(UIImage *)intersectionsImage
                       verticesImage:(UIImage * _Nullable)verticesImage {
  self = [super init];
  if (self) {
    _croppedImage = croppedImage;
    _contoursImage = contoursImage;
    _houghLinesImage = houghLinesImage;
    _intersectionsImage = intersectionsImage;
    _verticesImage = verticesImage;
  }
  return self;
}

-(BOOL)hasContent
{
  return !(!self.croppedImage
           && !self.contoursImage
           && !self.intersectionsImage
           && !self.houghLinesImage
           && !self.verticesImage);
}

@end
