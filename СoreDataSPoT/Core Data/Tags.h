//
//  Tags.h
//  СoreDataSPoT
//
//  Created by Mudryak on 25.11.13.
//  Copyright (c) 2013 Mudryak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface Tags : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSMutableSet *photo;
@end

@interface Tags (CoreDataGeneratedAccessors)

- (void)addPhotoObject:(Photo *)value;
- (void)removePhotoObject:(Photo *)value;
- (void)addPhoto:(NSSet *)values;
- (void)removePhoto:(NSSet *)values;

@end
