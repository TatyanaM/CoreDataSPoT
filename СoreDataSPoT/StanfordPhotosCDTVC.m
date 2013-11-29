//
//  StanfordPhotosCDTVC.m
//  СoreDataSPoT
//
//  Created by Mudryak on 20.11.13.
//  Copyright (c) 2013 Mudryak. All rights reserved.
//

#import "StanfordPhotosCDTVC.h"
#import "FlickrFetcher.h"
#import "Photo+Flickr.h"
#import "SharedManagedDocument.h"

@implementation StanfordPhotosCDTVC 

-(void)awakeFromNib
{
    self.splitViewController.delegate = self;
}

-(BOOL)splitViewController:(UISplitViewController *)svc
  shouldHideViewController:(UIViewController *)vc
             inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.managedObjectContext)
    {
      [self setupFetchResultController];
      if (![self.fetchedResultsController.fetchedObjects count])
        [self refresh];
    } else
        [self useDocument];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.rightBarButtonItem = self.searchButton;
}


-(IBAction)refresh
{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t fetchQ = dispatch_queue_create("Flickr Fetch", NULL);
    dispatch_async(fetchQ, ^{
       
        //download photo from FLickr
        NSArray *photos = [FlickrFetcher stanfordPhotos];
       
        //put the photos in core data
        [self.managedObjectContext performBlock:^{
            for (NSDictionary *photo in photos)
            {
                [Photo photoWithFlickrInfo:photo  inManagedObjectContext:self.managedObjectContext];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
            });
        }];
    });
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
              [self refresh];
            }
        }];
    } else if (document.documentState == UIDocumentStateClosed)
    {
        //open it
        [document openWithCompletionHandler:^(BOOL success) {
            if (success)
            {
             self.managedObjectContext = document.managedObjectContext;
            }
         }];
    } else
        //use it
        self.managedObjectContext = document.managedObjectContext;
    
}

@end









