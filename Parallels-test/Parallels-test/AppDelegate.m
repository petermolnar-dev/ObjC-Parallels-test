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
#import "PMOPictureModellControllerFactory.h"
#import "PMOImageTableViewController.h"

@interface AppDelegate()

@property (strong, nonatomic) PMODownloadTaskQueues *downloadQueues;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Setting up the globals
    self.downloadQueues =[[PMODownloadTaskQueues alloc] init];
    NSString *JSONFileURLAsString = @"http://93.175.29.76/web/wwdc/items.json";
    NSString *baseImageURLAsString = @"http://93.175.29.76/web/wwdc/";
    
    // handing over the globals to the rootViewController
    PMOImageTableViewController *vc = (PMOImageTableViewController *)self.window.rootViewController;
    
    vc.queues = self.downloadQueues;
    vc.JSONFileURLAsString = JSONFileURLAsString;
    vc.baseImageURLAsString = baseImageURLAsString;
    
    return YES;
}



@end
