//
//  PhotoViewController.m
//  СoreDataSPoT
//
//  Created by Mudryak on 04.12.13.
//  Copyright (c) 2013 Mudryak. All rights reserved.
//

#import "PhotoViewController.h"
#import "MapViewController.h"
#import "Photo+Annotation.h"

@interface PhotoViewController ()

@property (strong, nonatomic) MapViewController *mapVC;

@end

@implementation PhotoViewController

-(void)setPhoto:(Photo *)photo
{
    _photo = photo;
    self.title = self.photo.title;
    self.imageURL = [NSURL URLWithString:self.photo.imageURL];
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.mapVC.mapView addAnnotation:self.photo];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Embed Map"]){
        if ([segue.destinationViewController isKindOfClass:[MapViewController class]]) {
            self.mapVC = segue.destinationViewController;
        }
        
    }
}
@end
