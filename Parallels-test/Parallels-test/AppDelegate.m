//
//  AppDelegate.m
//  Parallels-test
//
//  Created by Peter Molnar on 27/04/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#define kDataBaseURLAsString @"http://93.175.29.76/web/wwdc/"
#define kJSONURLAsString [kDataBaseURLAsString stringByAppendingString:@"items.json"]

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
    
    // handing over the globals to the rootViewController
    PMOImageTableViewController *vc = (PMOImageTableViewController *)self.window.rootViewController;
    
    vc.queues = self.downloadQueues;
    vc.JSONFileURLAsString = kJSONURLAsString;
    vc.baseImageURLAsString = kDataBaseURLAsString;
    
    return YES;
}



@end
