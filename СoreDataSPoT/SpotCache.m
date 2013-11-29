//
//  SpotCache.m
//  SPoT
//
//  Created by Mudryak on 05.11.13.
//  Copyright (c) 2013 Mudryak. All rights reserved.
//


#import "SpotCache.h"
#import "FlickrFetcher.h"

@implementation SpotCache

#define MAXIMUM_CHACHE_SIZE 3145728 //3Mb

static NSURL *cacheURL;
static NSFileManager *fileManager;

+(NSFileManager *)fileManager
{
    if (!fileManager) fileManager = [NSFileManager defaultManager];
    return fileManager;
}

+(NSURL *)cacheURL
{
    if (!cacheURL)
    {
        NSArray *paths = [[self fileManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
        if (paths.count > 0)
        {
           cacheURL = [paths lastObject];
           cacheURL = [cacheURL URLByAppendingPathComponent:@"cachedImages/"];
        }
        if (![fileManager fileExistsAtPath:[cacheURL path]])
        {
            [fileManager createDirectoryAtPath:cacheURL.path withIntermediateDirectories:NO attributes:nil error:nil];
        }
    }
    return cacheURL;
}

//add new image to cache
+ (void)cacheData:(Photo *)photo
{
    NSURL *cacheURL = [[NSURL alloc] init];
    cacheURL = [self  pathForPhoto:photo];
    NSURL *imageURL = [NSURL URLWithString:photo.imageURL];
    
    if (![self fileExistAtPath:cacheURL.path])
    {
    dispatch_queue_t fileProcessQ = dispatch_queue_create("file process", NULL);
    dispatch_async(fileProcessQ, ^{
      NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
      [self checkCacheSizeWithPhotoSize:[imageData length]];
      if (imageData)
        [imageData writeToURL:cacheURL atomically:YES];
    });
    } else
    {
      [cacheURL setResourceValue:[NSDate date] forKey:NSURLContentAccessDateKey error:nil];
    }
}

+(NSURL *)pathForPhoto:(Photo *)photo
{
    NSString *photoFormat = [[[[photo.imageURL lastPathComponent] componentsSeparatedByString:@"."] lastObject] lowercaseString];
    NSString *fullFileName = [NSString stringWithFormat:@"%@.%@", photo.unique, photoFormat];
    NSURL *path = [[self cacheURL] URLByAppendingPathComponent:fullFileName];
    return path;
}

+(BOOL)fileExistAtPath:(NSString *)path
{
    if ([self.fileManager fileExistsAtPath:path])
        return YES;
    else return NO;
}

//is photo already in cache?
+ (NSURL *)checkPhotoInCache:(Photo *)photo
{
    NSURL *pathForPhoto = [self pathForPhoto:photo];
    if ([self fileExistAtPath:pathForPhoto.path])
       return pathForPhoto;    
    else
        return nil;
}

+(void)removeLastFile
{
   NSArray *cachedURLs = [fileManager contentsOfDirectoryAtURL:cacheURL
                               includingPropertiesForKeys:@[NSURLContentAccessDateKey]
                                                  options:NSDirectoryEnumerationSkipsHiddenFiles
                                                    error:NULL];
   cachedURLs = [cachedURLs sortedArrayUsingComparator:^(NSURL *obj1, NSURL *obj2) {
        NSDate *date1 = [[fileManager attributesOfItemAtPath:[obj1 path] error:nil] valueForKey:NSFileModificationDate];
        NSDate *date2 = [[fileManager attributesOfItemAtPath:[obj2 path] error:nil] valueForKey:NSFileModificationDate];
        return [date2 compare:date1];
    }];
    
    NSURL *lastURL = [cachedURLs lastObject];
    [fileManager removeItemAtURL:lastURL error:nil];
}

+(void)checkCacheSizeWithPhotoSize:(NSUInteger)size
{
    int cacheSize = 0;
    NSArray *photosInCache = [NSArray arrayWithArray:[self.fileManager contentsOfDirectoryAtURL:cacheURL
                                        includingPropertiesForKeys:@[NSURLContentAccessDateKey]
                                                           options:NSDirectoryEnumerationSkipsHiddenFiles
                                                             error:nil]];
    
    for (NSURL *url in photosInCache)
    {
        cacheSize += [[[fileManager attributesOfItemAtPath:url.path error:nil] valueForKey:NSFileSize] intValue];
    }
    NSLog(@"Cache size = %d", cacheSize);
    if (cacheSize + size > MAXIMUM_CHACHE_SIZE) [self removeLastFile];
}


@end
