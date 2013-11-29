//
//  AllPhotoCDTVC.h
//  СoreDataSPoT
//
//  Created by Mudryak on 26.11.13.
//  Copyright (c) 2013 Mudryak. All rights reserved.
//
// Show the list of all Flickr photos

#import "PhotosByTagCDTVC.h"

@interface AllPhotoCDTVC : PhotosByTagCDTVC <UISearchBarDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (strong, nonatomic) NSPredicate *searchPredicate;

@end
