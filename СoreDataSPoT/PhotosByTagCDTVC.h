//
//  PhotosByTagCDTVC.h
//  СoreDataSPoT
//
//  Created by Mudryak on 20.11.13.
//  Copyright (c) 2013 Mudryak. All rights reserved.
//
// Show photos by defined tag

#import "CoreDataTableViewController.h"
#import "Tags.h"

@interface PhotosByTagCDTVC : CoreDataTableViewController

@property (nonatomic, strong) Tags *tag;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
