//
//  PMOImageViewController.m
//  Parallels-test
//
//  Created by Peter Molnar on 31/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMOImageViewController.h"
#import "PMODataDownloader.h"
#import "PMOImageViewScrollViewDelegate.h"

@interface PMOImageViewController()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) PMOImageViewScrollViewDelegate *scrollViewDelegate;

@end

@implementation PMOImageViewController
@dynamic view;


#pragma mark - LifeCycle
-(void)loadView {
    [super loadView];
    self.view = [[PMOViewWithIndicator alloc] initWithFrame:[UIScreen mainScreen].bounds];
}


- (void)viewDidLoad {
    self.scrollViewDelegate.parentView = self.view;
    [self.scrollView setDelegate:self.scrollViewDelegate];
    [self.scrollView addSubview:self.imageView];
    
    if (self.modellController.picture.image) {
        // If image stored, then display it
        self.imageView.image = self.modellController.image;
    } else {
        [self.modellController addObserver:self
                               forKeyPath:@"picture.image"
                                  options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                                  context:nil ];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveDownloadErrorNotification:) name:PMODataDownloaderError
                                                   object:nil];
        self.imageView.image = self.modellController.image;

        [self.view startSpinner];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        [self.modellController.downloadQueues changeDownloadTaskToHighPriorityQueueFromURL:self.modellController.picture.imageURL];
        
    }
}

- (void)viewWillLayoutSubviews {
    [self.scrollView setFrame:self.view.frame];

}


#pragma mark - Accessors

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    
    return _imageView;
}

- (PMOImageViewScrollViewDelegate *)scrollViewDelegate {
    if (!_scrollViewDelegate) {
        _scrollViewDelegate = [[PMOImageViewScrollViewDelegate alloc] init];
        _scrollViewDelegate.scrollDestinationView = self.imageView;
    }
    
    return _scrollViewDelegate;
}


- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [self.scrollViewDelegate scrollviewFactory];
    }
    return _scrollView;
}

- (void)updateScrollViewToPictureFit
{
    float minZoom = MIN(self.view.bounds.size.width / self.imageView.image.size.width, self.view.bounds.size.height / self.imageView.image.size.height);
    // Set back to self.scrollView.zoomScale=1.0; if they want to see the full image, in real size.
    self.scrollView.zoomScale=minZoom;
    
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    // Update the UI from the main Queue
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.imageView.image = self.modellController.image;
        [self.view stopSpinner];
        [self.modellController.downloadQueues changeDownloadTaskToNormalPriorityQueueFromURL:self.modellController.picture.imageURL];
        self.scrollView.zoomScale = 1.0;
        self.scrollView.minimumZoomScale = 0.02;
        self.scrollView.maximumZoomScale = 2.0;
        
        self.imageView.frame = CGRectMake(0, 0, self.modellController.image.size.width, self.modellController.image.size.height);
        self.scrollView.frame = self.imageView.frame;
        self.scrollView.contentSize =  self.modellController.image.size;
        
        [self updateScrollViewToPictureFit];

        [self.view setNeedsDisplay];
        [self.scrollView setNeedsDisplay];
        [self.imageView setNeedsDisplay];
    }];
    
}

-(void)didReceiveDownloadErrorNotification:(NSNotification *)notification  {
    NSError *error = [notification.userInfo objectForKey:@"error"];
    [self.view displayErrorMessage:error];
}




@end
