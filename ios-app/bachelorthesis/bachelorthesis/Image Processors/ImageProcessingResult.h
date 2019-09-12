//
//  ImageProcessingResult.h
//  bachelorthesis
//
//  Created by Erik Maximilian Martens on 12.09.19.
//  Copyright © 2019  Erik Maximilian Martens. All rights reserved.
//

#ifndef ImageProcessingResult_h
#define ImageProcessingResult_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageProcessingResult : NSObject

@property UIImage * _Nullable croppedImage;
@property UIImage * _Nullable contoursImage;
@property UIImage * _Nullable houghLinesImage;
@property UIImage * _Nullable intersectionsImage;
@property UIImage * _Nullable verticesImage;

- (instancetype _Nonnull)initWithCroppedImage:(UIImage * _Nullable)croppedImage
                                contoursImage:(UIImage * _Nullable)countoursImage
                              houghLinesImage:(UIImage * _Nullable)houghLinesImage
                           intersectionsImage:(UIImage * _Nullable)intersectionsImage
                                verticesImage:(UIImage * _Nullable)verticesImage;

- (BOOL)hasContent;

@end

#endif /* ImageProcessingResult_h */
