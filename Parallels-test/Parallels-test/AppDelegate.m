//
//  AppDelegate.m
//  Parallels-test
//
//  Created by Peter Molnar on 27/04/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#define kDataBaseURL @"http://93.175.29.76/web/wwdc/"
#define kDataURL [NSURL URLWithString:[kDataBaseURL stringByAppendingString:@"items.json"]]

#import "AppDelegate.h"
#import "PMODownloadTaskQueues.h"
#import "PMOPictureStorageModellController.h"
// Temporary only for testing
#import "PMOImageViewController.h"

@interface AppDelegate()

@property (strong, nonatomic) PMODownloadTaskQueues *downloadQueues;
@property (strong, nonatomic) PMOPictureModelController *modellController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Setting up the initial values
   self.downloadQueues =[[PMODownloadTaskQueues alloc] init];
   // Only for testing
    NSDictionary  *firstPicture = @{ @"image" : @"wwdc5.png",
                                     @"name" : @"WWDC'05",
                                     @"description" : @"Image for WWDC 2005"};
    NSDictionary  *smallPicture = @{ @"image" : @"wwdc11.png",
                                     @"name" : @"WWDC'05",
                                     @"description" : @"Image for WWDC 2005"};

    self.modellController = [[PMOPictureModelController alloc] init];
    
    self.modellController.downloadQueues = self.downloadQueues;
//    [self.modellController createPictureFromDictionary:firstPicture baseURLAsStringForImage:@"http://93.175.29.76/web/wwdc/"];
        [self.modellController createPictureFromDictionary:smallPicture baseURLAsStringForImage:@"http://demo.petermolnar.hu/web/wwdc"];

    PMOImageViewController *vc = (PMOImageViewController *)self.window.rootViewController;
    
    vc.modellController = self.modellController;
    
    return YES;
}



@end
