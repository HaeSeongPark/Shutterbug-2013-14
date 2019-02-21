//
//  ImageViewController.m
//  imaginarium
//
//  Created by rhino Q on 20/02/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()<UIScrollViewDelegate, UISplitViewControllerDelegate >

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation ImageViewController(UIScrollViewDelegate)

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end

@implementation ImageViewController

- (void)viewWillAppear:(BOOL)animated {
//    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAutomatic;
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
}

- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.delegate = self;
    self.scrollView.contentSize = self.image? self.image.size : CGSizeZero;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [self startDownloadingImage];
}

-(void)startDownloadingImage {
    self.image = nil;
    if(self.imageURL) {
        [self.spinner startAnimating];
        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(!error) {
                if([request.URL isEqual:self.imageURL]) {
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.image = image;
                    });
                    [self performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
                }
            }
        }];
        
        [task resume];
    }
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    return _imageView;
}
- (UIImage *)image {
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image {
    self.scrollView.zoomScale = 1.0;
    
    self.imageView.image = image;
//    [self.imageView sizeToFit];
    
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    self.scrollView.contentSize = self.image? self.image.size : CGSizeZero;
    [self.spinner stopAnimating];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
}

# pragma mark - split view controller delegate

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

//- (BOOL)splitViewController:(UISplitViewController *)svc
//   shouldHideViewController:(UIViewController *)vc
//              inOrientation:(UIInterfaceOrientation)orientation
//{
//    return UIInterfaceOrientationIsPortrait(orientation);
//}

- (void)splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode {
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
}

//- (void)splitViewController:(UISplitViewController *)svc
//     willHideViewController:(UIViewController *)aViewController
//          withBarButtonItem:(UIBarButtonItem *)barButtonItem
//       forPopoverController:(UIPopoverController *)pc
//{
//    barButtonItem.title = aViewController.title;
//    self.navigationItem.leftBarButtonItem = barButtonItem;
//}
//
//- (void)splitViewController:(UISplitViewController *)svc
//     willShowViewController:(UIViewController *)aViewController
//  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
//{
//    self.navigationItem.leftBarButtonItem = nil;
//}

@end
