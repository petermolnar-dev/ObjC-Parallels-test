//
//  PMOPictureDownloaderWithQueues.m
//  Parallels-test
//
//  Created by Peter Molnar on 09/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMOPictureDownloaderWithQueues.h"

@implementation PMOPictureDownloaderWithQueues

-(void)downloadDataFromURL:(NSURL *)sourceURL {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:sourceURL];
    
    NSURLSessionDataTask *downloadTask = [self.session dataTaskWithRequest:request completionHandler:
                                          ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                              [self notifyObserversWithDownloadedData:data];
                                          }];
    if (self.queues) {
        [self.queues addDownloadTaskToNormalPriorityQueue:downloadTask];
    } else {
        [downloadTask resume];
    }
}
@end
