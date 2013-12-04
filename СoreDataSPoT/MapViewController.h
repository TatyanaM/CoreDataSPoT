//
//  MapViewController.h
//  СoreDataSPoT
//
//  Created by Mudryak on 04.12.13.
//  Copyright (c) 2013 Mudryak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
