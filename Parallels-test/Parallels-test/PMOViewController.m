//
//  PMOViewController.m
//  Parallels-test
//
//  Created by Peter Molnar on 28/04/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMOViewController.h"
#import "PMOPictureModelController.h"


@interface PMOViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) PMOPictureModelController *modelController;
@property (weak, nonatomic)UIActivityIndicatorView *loadingActivity;
@end

@implementation PMOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.downloadQueues =[[PMODownloadTaskQueues alloc] init];
    NSDictionary  *firstPicture = @{ @"image" : @"wwdc5.png",
        @"name" : @"WWDC'05",
        @"description" : @"Image for WWDC 2005"};
    NSDictionary  *smallPicture = @{ @"image" : @"pm_cv-2015_preview.png",
                                     @"name" : @"WWDC'05",
                                     @"description" : @"Image for WWDC 2005"};

//    [self.modelController createPictureFromDictionary:smallPicture baseURLAsStringForImage:@"http://i2.wp.com/petermolnar.hu/wp-content/uploads/2014/04/"];
    [self.modelController setDownloadQueues:self.downloadQueues];
    
    [self.modelController createPictureFromDictionary:firstPicture baseURLAsStringForImage:@"http://93.175.29.76/web/wwdc/"];
    
    [self.modelController addObserver:self
                           forKeyPath:@"picture.thumbnailImage"
                              options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                              context:nil ];
    self.loadingActivity = [self addSpinnerToView:self.view];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.imageView.image = self.modelController.thumbnailImage;
}

- (UIActivityIndicatorView *)addSpinnerToView:(UIView *)parentView {
    UIActivityIndicatorView *loadingActivity = [[UIActivityIndicatorView alloc]
                                                initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [loadingActivity setColor:[UIColor blackColor]];
    [parentView addSubview:loadingActivity];
    [parentView bringSubviewToFront:loadingActivity];
    loadingActivity.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    loadingActivity.center = parentView.center;
    [loadingActivity startAnimating];
    
    return loadingActivity;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    // Update the UI from the main Queue
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.imageView.image = [change valueForKey:@"new"];
        [self.loadingActivity stopAnimating];
        [self.loadingActivity removeFromSuperview];

        [self.view setNeedsDisplay];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PMOPictureModelController *)modelController {
    if (!_modelController) {
        _modelController = [[PMOPictureModelController alloc] init];

    }
    
    return _modelController;
}
@end
