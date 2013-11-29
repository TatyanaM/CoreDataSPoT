//
//  ImageViewController.m
//  SPoT
//
//  Created by Mudryak on 23.10.13.
//  Copyright (c) 2013 Mudryak. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarButtonItem;

@end

@implementation ImageViewController

-(void)setTitle:(NSString *)title
{
    super.title = title;
    self.titleBarButtonItem.title = self.title;
}

-(void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self resetImage];
}

-(UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}

-(void)resetImage
{
    if (self.scrollView)
    {
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        [self.spinner startAnimating];
        NSURL *imageURL = self.imageURL;
        dispatch_queue_t imageLoadQ = dispatch_queue_create("image load", NULL);
        dispatch_async(imageLoadQ, ^{
          [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
           NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
          [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
          UIImage *image = [[UIImage alloc] initWithData:imageData];
          
          if (self.imageURL == imageURL)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (image)
                    {
                        self.scrollView.zoomScale = 1.0;
                        self.scrollView.contentSize = image.size;
                        self.imageView.image = image;
                        self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                    }
                    [self.spinner stopAnimating];
                });
            }
        });
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.scrollView flashScrollIndicators];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    double heightZoomMin = self.scrollView.bounds.size.height / self.imageView.bounds.size.height;
    double widhtZoomMin = self.scrollView.bounds.size.width / self.imageView.bounds.size.width;
    [self.scrollView setZoomScale: MAX(heightZoomMin, widhtZoomMin)];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 3.0;
    self.scrollView.delegate = self;
    self.titleBarButtonItem.title = self.title;
    [self resetImage];
}



@end
