//
//  PMODataDownloader.h
//  Parallels-test
//
//  Created by Peter Molnar on 06/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMODownloadNotifier.h"

// String constant for the NSNotificationCenter notification
static NSString *const PMODataDownloaderDidDownloadEnded = @"PMODataDownloaderDidDownloadEnded";

@interface PMODataDownloader : UIViewController <PMODownloadNotifier>

@property (strong, nonatomic) NSURLSession *session;

-(void)downloadDataFromURL:(NSURL *)sourceURL;

@end
