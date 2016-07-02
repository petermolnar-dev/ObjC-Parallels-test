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
#import "PMOImageViewScrollViewFactory.h"
#import "PMOPictureModellController.h"
#import "PMOPicture.h"

@interface PMOImageViewController() <UISplitViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) PMOImageViewScrollViewDelegate *scrollViewDelegate;

@end

@implementation PMOImageViewController

@dynamic view;

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.scrollView addSubview:self.imageView];
    [self.scrollView setDelegate:self.scrollViewDelegate];
    [self.scrollViewDelegate setScrollDestinationView:self.imageView];
    [self setupImage];
}


- (void)setupImage {
    if (self.modellController.picture.image) {
        // If image stored, then display it
        self.imageView.image = self.modellController.image;
        [self setupScrollAndImageViews];
    } else {
        self.imageView.image = self.modellController.image;
        [self.view startSpinner];
        [self.modellController changePictureDownloadPriorityToHigh];
    }
}


#pragma mark - Accessors

- (PMOImageViewScrollViewDelegate *)scrollViewDelegate {
    if (!_scrollViewDelegate) {
        _scrollViewDelegate = [[PMOImageViewScrollViewDelegate alloc] init];
        _scrollViewDelegate.scrollDestinationView = self.imageView;
    }
    
    return _scrollViewDelegate;
}

- (UIImageView *)imageView {
    
    if (!_imageView) _imageView = [[UIImageView alloc] init];
    return _imageView;
}

- (void)removePictureImageObserverFromController:(PMOPictureModellController *)modellController {
    [modellController removeObserver:self
                          forKeyPath:@"picture.image" ];
    
}

- (void)changePreviousModellControllerOnSplitView {
    if (self.splitViewController.viewControllers[1]) { // Check if we are on iPad/iPhone 6Plus
        if (_modellController) {
            // If there _modelcontroller is not nil, probably it might be
            // observed by this class
            @try {
                [self removePictureImageObserverFromController:_modellController];
            }
            @catch(id anException){
                //do nothing, obviously it wasn't attached because an exception was thrown
            }
            [_modellController changePictureDownloadPriorityToDefault];
        }
    }
    
}

- (void)setModellController:(PMOPictureModellController *)modellController {
    
    [self changePreviousModellControllerOnSplitView];
    
    _modellController = modellController;
    if (_modellController) {
        [self.modellController addObserver:self
                                forKeyPath:@"picture.image"
                                   options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                                   context:nil ];
        [self.view hideMessageLabel];
        [self setupImage];
    }
    
}

#pragma mark - Update helpers

- (void)updateScrollViewToPictureFit {
    float minZoom = MIN(self.view.bounds.size.width / self.imageView.image.size.width, self.view.bounds.size.height / self.imageView.image.size.height);
    self.scrollView.zoomScale=minZoom;
}

- (void)setupScrollAndImageViews {
    [self.view stopSpinner];
    
    self.scrollView.zoomScale = 1.0;
    self.scrollView.minimumZoomScale = 0.02;
    self.scrollView.maximumZoomScale = 2.0;
    self.imageView.frame = CGRectMake(0, 0, self.modellController.image.size.width, self.modellController.image.size.height);
    self.scrollView.frame = self.imageView.frame;
    self.scrollView.contentSize = self.imageView.image ? self.imageView.image.size : CGSizeZero;
    [self updateScrollViewToPictureFit];
    [self.view setNeedsDisplay];
    [self.scrollView setNeedsDisplay];
    [self.imageView setNeedsDisplay];
    
}

#pragma mark - Observer triggers
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    // Update the UI from the main Queue
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.imageView.image = self.modellController.image;
        [self.modellController changePictureDownloadPriorityToDefault];
        [self setupScrollAndImageViews];
    }];
    
}

#pragma mark - SplitViewController setup
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.splitViewController.displayMode == UISplitViewControllerDisplayModePrimaryHidden)
    {
        [self showBackButtonOnSplitViewController];
    }
    if (self.splitViewController && !self.modellController) {
        [self.view displayInitialMessage:@"Select a picture from the list."];
    }
}

-(void)showBackButtonOnSplitViewController
{
    UIBarButtonItem *barButtonItem = self.splitViewController.displayModeButtonItem;
    barButtonItem.title = @"Show List";
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
}

- (void)awakeFromNib
{
    self.splitViewController.delegate = self;
}

- (void)splitViewController:(UISplitViewController *)svc
    willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode {
    
    if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        [self showBackButtonOnSplitViewController];
    }
}

#pragma mark - Dealloc cleanup
-(void)dealloc {
    [self removePictureImageObserverFromController:self.modellController];
    
}

@end
