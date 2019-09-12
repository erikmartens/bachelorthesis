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
@property UIImage * _Nullable intersectionsImage;

- (instancetype _Nonnull)initWithCroppedImage:(UIImage * _Nullable)croppedImage
                                contoursImage:(UIImage * _Nullable)countoursImage
                           intersectionsImage:(UIImage * _Nullable)intersectionsImage;

- (BOOL)hasContent;

@end

#endif /* ImageProcessingResult_h */
