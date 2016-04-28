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
@property (strong, nonatomic) PMOPictureModelController *modelController;
@end

@implementation PMOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary  *firstPicture = @{ @"image" : @"wwdc5.png",
        @"name" : @"WWDC'05",
        @"description" : @"Image for WWDC 2005"};
    self.modelController = [self.modelController initWithPictureFromDictionary:firstPicture baseURLAsStringForImage:@"http://93.175.29.76/web/wwdc/"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
