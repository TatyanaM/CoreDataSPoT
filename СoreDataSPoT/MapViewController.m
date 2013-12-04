//
//  MapViewController.m
//  СoreDataSPoT
//
//  Created by Mudryak on 04.12.13.
//  Copyright (c) 2013 Mudryak. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@property (nonatomic) BOOL needUpdateRegion;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.mapView.delegate = self;
    self.needUpdateRegion = YES;
    
}

// after we have appeared, zoom in on the annotations (but only do that once)

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.needUpdateRegion) [self updateRegion];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *reuseID = @"MapView";
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseID];
    if (!view) {
        view  = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseID];
        view.canShowCallout = YES;
    }
    return view;
}

// zooms to a region that encloses the annotations
// kind of a crude version
// (using CGRect for latitude/longitude regions is sorta weird, but CGRectUnion is nice to have!)

- (void)updateRegion
{
    self.needUpdateRegion = NO;
    CGRect boundingRect;
    BOOL started = NO;
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        CGRect annotationRect = CGRectMake(annotation.coordinate.latitude, annotation.coordinate.longitude, 0, 0);
        if (!started) {
            started = YES;
            boundingRect = annotationRect;
        } else {
            boundingRect = CGRectUnion(boundingRect, annotationRect);
        }
    }
    if (started) {
        boundingRect = CGRectInset(boundingRect, -0.2, -0.2);
        if ((boundingRect.size.width < 20) && (boundingRect.size.height < 20)) {
            MKCoordinateRegion region;
            region.center.latitude = boundingRect.origin.x + boundingRect.size.width / 2;
            region.center.longitude = boundingRect.origin.y + boundingRect.size.height / 2;
            region.span.latitudeDelta = boundingRect.size.width;
            region.span.longitudeDelta = boundingRect.size.height;
            [self.mapView setRegion:region animated:YES];
        }
    }
}


@end
