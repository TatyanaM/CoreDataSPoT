//
//  TagPhotoCDTVC.m
//  СoreDataSPoT
//
//  Created by Mudryak on 20.11.13.
//  Copyright (c) 2013 Mudryak. All rights reserved.
//

#import "FlickrTagsCDTVC.h"
#import "Tags.h"

@implementation FlickrTagsCDTVC

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext)
    {
        [self setupFetchResultController];
    } else
    {
        self.fetchedResultsController = nil;
    }
}

//fetch all tags from core data
-(void)setupFetchResultController
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Tags"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    request.predicate = self.searchPredicate;
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
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
        if ([segue.identifier isEqualToString:@"photoByTag"])
        {
            Tags *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
            if ([segue.destinationViewController respondsToSelector:@selector(setTag:)])
            {
                [segue.destinationViewController performSelector:@selector(setTag:) withObject:tag];
            }
        }
    }
}

#pragma mark - UITableView Delegate Methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Tag"];
    Tags *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [tag.title capitalizedString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Photos: %d", [tag.photo count]];
    
    return cell;
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















