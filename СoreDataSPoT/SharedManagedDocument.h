//
//  SharedManagedDocument.h
//  СoreDataSPoT
//
//  Created by Mudryak on 25.11.13.
//  Copyright (c) 2013 Mudryak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedManagedDocument : NSObject

@property (nonatomic, strong) UIManagedDocument *document;

+(SharedManagedDocument *)sharedDocument;

@end
