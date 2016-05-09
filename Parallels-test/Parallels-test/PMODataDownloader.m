//
//  PMODataDownloader.m
//  Parallels-test
//
//  Created by Peter Molnar on 06/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMODataDownloader.h"


@implementation PMODataDownloader

-(void)downloadDataFromURL:(NSURL *)sourceURL {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:sourceURL];
    
    NSURLSessionDataTask *downloadTask = [self.session dataTaskWithRequest:request completionHandler:
                                          ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                              
                                              [self notifyObserversWithDownloadedData:data];
                                          }];
    [downloadTask resume];
    
}

-(NSURLSession *)session {
    
    // Session can be injected, but if not initialized a default config is provided.
    if (!_session) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                 delegate:nil
                                            delegateQueue:nil];
    }
    return _session;
}

-(void)notifyObserversWithDownloadedData:(NSData *)data {
    NSDictionary *userInfo = @{@"data" : data };
    [[NSNotificationCenter defaultCenter] postNotificationName:PMODataDownloaderDidDownloadEnded
                                                        object:self
                                                      userInfo:userInfo];
}

@end
