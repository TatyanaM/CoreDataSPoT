//
//  Photo+Photo_Flickr.h
//  СoreDataSPoT
//
//  Created by Mudryak on 19.11.13.
//  Copyright (c) 2013 Mudryak. All rights reserved.
//

#import "Photo.h"

@interface Photo (Photo_Flickr)

+(Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary inManagedObjectContext:(NSManagedObjectContext *)contex;
@end
