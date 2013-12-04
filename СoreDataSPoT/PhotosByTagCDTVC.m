//
//  PhotosByTagCDTVC.m
//  СoreDataSPoT
//
//  Created by Mudryak on 20.11.13.
//  Copyright (c) 2013 Mudryak. All rights reserved.
//

#import "PhotosByTagCDTVC.h"
#import "Photo.h"
#import "FlickrFetcher.h"
#import "SpotCache.h"
#import "SharedManagedDocument.h"

@implementation PhotosByTagCDTVC

-(void)setTag:(Tags *)tag
{
    _tag = tag;
    self.title = [tag.title capitalizedString];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.managedObjectContext)
    {
        [self useDocument];
    } else
    {
        [self setupFetchResultController];
    }
}

//set managed object context
-(void)useDocument
{
    SharedManagedDocument *sharedDocument = [SharedManagedDocument sharedDocument];
    UIManagedDocument *document = sharedDocument.document;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[document fileURL] path]])
    {
        //create it
        [document saveToURL:[document fileURL]
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success)
              {
                  self.managedObjectContext = document.managedObjectContext;
                  [self setupFetchResultController];
              }
          }];
    } else if (document.documentState == UIDocumentStateClosed)
    {
        //open it
        [document openWithCompletionHandler:^(BOOL success) {
            if (success)
            {
                self.managedObjectContext = document.managedObjectContext;
                [self setupFetchResultController];
            }
        }];
    } else
        //use it
        self.managedObjectContext = document.managedObjectContext;
        [self setupFetchResultController];
}

//Fetch all the photos for a given tag
-(void)setupFetchResultController
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Photo"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"%@ IN tags", self.tag];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:@"section"
                                                                                   cacheName:nil];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    
    if ([sender isKindOfClass:[UITableViewCell class]])
    {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    
    if (indexPath)
    {
        if ([segue.identifier isEqualToString:@"Show Photo"])
        {
            Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
            photo.lastViewed = [NSDate date];
            
            if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)])
            {
              //is photo in cache already?
             NSURL *imageURL = [SpotCache checkPhotoInCache:photo];
                if (imageURL) {
                    photo.imageURL = [NSString stringWithFormat:@"%@",imageURL];
                }
                [segue.destinationViewController performSelector:@selector(setPhoto:) withObject:photo];

             [segue.destinationViewController setTitle:photo.title];
             [SpotCache cacheData:photo];
            }
        }
    }
}

#pragma mark - UITableView Delegate Methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Photo"];
    
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.subtitle;
    
    if ([tableView.indexPathsForVisibleRows containsObject:indexPath])
    {
        cell.imageView.image = [UIImage imageWithData:photo.thumbnail];
    }
    return cell;
}

@end



















