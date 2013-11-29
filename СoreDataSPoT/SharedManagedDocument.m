//
//  SharedManagedDocument.m
//  СoreDataSPoT
//
//  Created by Mudryak on 25.11.13.
//  Copyright (c) 2013 Mudryak. All rights reserved.
//

#import "SharedManagedDocument.h"

@implementation SharedManagedDocument

static SharedManagedDocument *sharedDocument = nil;

+(SharedManagedDocument *)sharedDocument
{
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
        sharedDocument = [[self alloc] init];
    });
    return sharedDocument;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Photo Document"];
        self.document = [[UIManagedDocument alloc] initWithFileURL:url];
    }
    return self;
}

@end
