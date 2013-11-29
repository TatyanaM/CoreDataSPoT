//
//  Tag+Tag_Create.m
//  СoreDataSPoT
//
//  Created by Mudryak on 19.11.13.
//  Copyright (c) 2013 Mudryak. All rights reserved.
//

#import "Tags+Create.h"

@implementation Tags (Create)

+(Tags *)addTag:(NSString *)tagTitle forPhoto: (Photo*)photo inManagedObjectContext:(NSManagedObjectContext *)context
{
    Tags *tag = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tags"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"title = %@", tagTitle];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || [matches count] > 1)
    {
        //error handler
    } else if (![matches count])
    {
        tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tags" inManagedObjectContext:context];
        tag.title = tagTitle;
        [tag.photo addObject:photo];
    } else
    {
        tag = [matches lastObject];
        [tag.photo addObject:photo];
    }
    return tag;
}

@end
