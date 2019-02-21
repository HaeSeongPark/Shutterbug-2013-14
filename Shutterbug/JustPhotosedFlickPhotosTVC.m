//
//  JustPhotosedFlickPhotosTVC.m
//  Shutterbug
//
//  Created by rhino Q on 21/02/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import "JustPhotosedFlickPhotosTVC.h"
#import "FlickrFetcher.h"
@interface JustPhotosedFlickPhotosTVC ()

@end

@implementation JustPhotosedFlickPhotosTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchPhotos];
}

-(IBAction)fetchPhotos {
    [self.refreshControl beginRefreshing];
    
    NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
    
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSData *jsonResults = [NSData dataWithContentsOfURL:url];
        NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                            options:0
                                                                              error:NULL];
        NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            [self.refreshControl endRefreshing];
            self.photos = photos;
        });
    });
    
}

@end
