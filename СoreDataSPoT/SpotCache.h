//
//  SpotCache.h
//  SPoT
//
//  Created by Mudryak on 05.11.13.
//  Copyright (c) 2013 Mudryak. All rights reserved.
//
// Cache

#import <Foundation/Foundation.h>
#import "Photo.h"

@interface SpotCache : NSObject

+ (void)cacheData:(Photo *)photo;
+ (NSURL *)checkPhotoInCache:(Photo *)photo;
@end
