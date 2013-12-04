//
//  Photo+Annotation.m
//  СoreDataSPoT
//
//  Created by Mudryak on 04.12.13.
//  Copyright (c) 2013 Mudryak. All rights reserved.
//

#import "Photo+Annotation.h"

@implementation Photo (Annotation)

-(CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];
    return coordinate;
}

@end
