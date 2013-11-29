//
//  Tag+Tag_Create.h
//  СoreDataSPoT
//
//  Created by Mudryak on 19.11.13.
//  Copyright (c) 2013 Mudryak. All rights reserved.
//

#import "Tags.h"

@interface Tags (Create)

+(Tags *)addTag:(NSString *)tagTitle forPhoto: (Photo*)photo inManagedObjectContext:(NSManagedObjectContext *)context;

@end
