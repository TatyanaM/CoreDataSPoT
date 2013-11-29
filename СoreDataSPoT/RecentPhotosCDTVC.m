//
//  RecentPhotosCDTVC.m
//  СoreDataSPoT
//
//  Created by Mudryak on 24.11.13.
//  Copyright (c) 2013 Mudryak. All rights reserved.
//

#import "RecentPhotosCDTVC.h"
#import "Photo.h"

@implementation RecentPhotosCDTVC

-(void)setupFetchResultController
{
  if (self.managedObjectContext)
    {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Photo"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastViewed" ascending:NO]];
    request.predicate = [NSPredicate predicateWithFormat:@"lastViewed != nil"];
    request.fetchLimit = 10;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    }
}

@end
