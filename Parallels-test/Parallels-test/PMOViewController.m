//
//  PMOViewController.m
//  Parallels-test
//
//  Created by Peter Molnar on 28/04/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMOViewController.h"
#import "PMOPictureModellControllerFactory.h"
#import "PMOPictureStorageModellController.h"
#import "PMODataDownloader.h"


@interface PMOViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) PMOPictureModellController *modelController;
@property (strong, nonatomic) PMOPictureStorageModellController *storageController;

-(void)didReceiveDownloadErrorNotification:(NSNotification *)notification ;

@end

@implementation PMOViewController
@dynamic view;


-(void)loadView {
    [super loadView];
    self.view = [[PMOViewWithIndicator alloc] initWithFrame:[UIScreen mainScreen].bounds];

}

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
        self.modelController = [PMOPictureModellControllerFactory modellControllerFromDictionary:firstPicture
                                                                         baseURLAsStringForImage:@"http://93.175.29.76/web/wwdc/"];
                            
                            
     
    [self.modelController setDownloadQueues:self.downloadQueues];
    

    [self.modelController addObserver:self
                           forKeyPath:@"picture.image"
                              options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                              context:nil ];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDownloadErrorNotification:) name:PMODataDownloaderError
                                               object:nil];
    
    NSURL *jsonURL = [NSURL URLWithString:@"http://localhost/items.json"];
    
    [self.storageController setupFromJSONFileatURL:jsonURL baseURLStringForImages:@"http://localhost"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view startSpinner];
    [self.view addSubview:self.imageView];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.imageView.image = self.modelController.image;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    // Update the UI from the main Queue
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.imageView.image = [change valueForKey:@"new"];
        NSLog(@"Picture downloaded, imageview hidden? %d", self.imageView.isHidden);
        
        self.imageView.image = self.modelController.image;
        [self.view stopSpinner];
        [self.view setNeedsDisplay];
        [self.imageView setNeedsDisplay];
    }];

}

-(void)didReceiveDownloadErrorNotification:(NSNotification *)notification  {
     [[NSOperationQueue mainQueue] addOperationWithBlock:^{
         [self.view stopSpinner];
         
    UILabel *errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
         errorLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
         errorLabel.center = self.view.center;
    NSError *error = [notification.userInfo objectForKey:@"error"];

    errorLabel.text = [error localizedDescription];
         errorLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:errorLabel];
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PMOPictureModellController *)modelController {

    if (!_modelController) {
        _modelController = [[PMOPictureModellController alloc] init];

    }
    
    return _modelController;
}

- (PMOPictureStorageModellController *)storageController {
    
    if (!_storageController) {
        _storageController = [[PMOPictureStorageModellController alloc] init];
    }
    
    return _storageController;
}
@end
