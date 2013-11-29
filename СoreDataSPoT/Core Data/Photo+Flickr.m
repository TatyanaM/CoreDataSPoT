//
//  Photo+Photo_Flickr.m
//  СoreDataSPoT
//
//  Created by Mudryak on 19.11.13.
//  Copyright (c) 2013 Mudryak. All rights reserved.
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"
#import "Tags+Create.h"

@implementation Photo (Flickr)

+(Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary inManagedObjectContext:(NSManagedObjectContext *)contex
{
    Photo *photo = nil;
    
    //проверяем наличие фото в БД
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Photo"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", [photoDictionary[FLICKR_PHOTO_ID] description]];
    
    NSError *error = nil;
    NSArray *matches = [contex executeFetchRequest:request error:&error];
    
    if (!matches || [matches count] > 1)
    {
        //error handler
    } else if (![matches count]) //пустой массив = фото нет в БД
    {
     //создаем фото и заполняем аттрибуты
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:contex];
        photo.unique = [photoDictionary[FLICKR_PHOTO_ID] description];
        photo.title = [photoDictionary[FLICKR_PHOTO_TITLE] description];
        photo.section = [[photo.title substringWithRange:NSMakeRange(0, 1)] uppercaseString];
        photo.subtitle = [[photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION] description];
        
        FlickrPhotoFormat imageFormat = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? FlickrPhotoFormatOriginal : FlickrPhotoFormatLarge;
        photo.imageURL = [[FlickrFetcher urlForPhoto:photoDictionary format:imageFormat] absoluteString];
        photo.thumbnail = [NSData dataWithContentsOfURL:[FlickrFetcher urlForPhoto:photoDictionary format:FlickrPhotoFormatSquare]];


     //связи
        for (NSString *title in [[photoDictionary[FLICKR_TAGS] description] componentsSeparatedByString:@" "])
        {
          if (![title isEqualToString:@"cs193pspot"] && ![title isEqualToString:@"portrait"] && ![title isEqualToString:@"landscape"])
          {
           Tags *tag = [Tags addTag:title forPhoto:photo inManagedObjectContext:contex];
          [photo.tags addObject:tag];
          }
        }
        
    } else
    {
        photo = [matches lastObject]; //перезаписываем фото
    }
    return photo;
}


@end
