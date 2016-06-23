//
//  AppDelegate.m
//  Parallels-test
//
//  Created by Peter Molnar on 27/04/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#define kDataBaseURLAsString @"http://93.175.29.76/web/wwdc/"
#define kDataBaseURLAsStringLocalTests @"http://localhost/web/wwdc/"
#define kJSONURLAsString [kDataBaseURLAsString stringByAppendingString:@"items.json"]

#import "AppDelegate.h"
#import "PMOPictureStorageModellController.h"
#import "PMOPictureModellControllerFactory.h"
#import "PMOImageTableViewController.h"


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    // handing over the globals to the rootViewController
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    PMOImageTableViewController *vc = (PMOImageTableViewController *)navigationController.topViewController;
    
    vc.JSONFileURLAsString = kJSONURLAsString;
    vc.baseImageURLAsString = kDataBaseURLAsString;
    
    return YES;
}



@end
