//
//  FlickrTagsCDTVC.h
//  СoreDataSPoT
//
//  Created by Mudryak on 20.11.13.
//  Copyright (c) 2013 Mudryak. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface FlickrTagsCDTVC : CoreDataTableViewController <UISearchBarDelegate>

-(void)setupFetchResultController;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (strong, nonatomic) NSPredicate *searchPredicate;

@end
