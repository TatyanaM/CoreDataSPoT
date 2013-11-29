
//
//  AllPhotoCDTVC.m
//  СoreDataSPoT
//
//  Created by Mudryak on 26.11.13.
//  Copyright (c) 2013 Mudryak. All rights reserved.
//

#import "AllPhotoCDTVC.h"

@implementation AllPhotoCDTVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.searchButton;
}

-(void)setupFetchResultController
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Photo"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    request.predicate = self.searchPredicate;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:@"section"
                                                                                   cacheName:nil];
}

#pragma mark - UISearchBar Delegate Methods

-(UISearchBar *)searchBar
{
    if (!_searchBar)
    {
        _searchBar = [[UISearchBar alloc] initWithFrame:self.navigationController.navigationBar.frame];
        _searchBar.delegate = self;
    }
    return _searchBar;
}

-(UIBarButtonItem *)searchButton
{
    if (!_searchButton)
        _searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                      target:self
                                                                      action:@selector(searchButtonPressed:)];
    return _searchButton;
}


-(IBAction)searchButtonPressed:(id)sender
{
    if (self.tableView.tableHeaderView)
    {
        self.tableView.tableHeaderView = nil;
    } else
    {
        self.tableView.tableHeaderView = self.searchBar;
        if (self.searchPredicate)
        {
            self.searchPredicate = nil;
            [self setupFetchResultController];
        }
        [self.searchBar becomeFirstResponder];
    }
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length])
        self.searchPredicate = [NSPredicate predicateWithFormat:@"title contains[cd] %@", searchText];
    else
        self.searchPredicate = nil;
    
    [self setupFetchResultController];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.tableView.tableHeaderView = nil;
    self.searchPredicate = nil;
    [self setupFetchResultController];
}


@end
