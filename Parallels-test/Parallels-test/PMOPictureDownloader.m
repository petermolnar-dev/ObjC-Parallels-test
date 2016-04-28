//
//  PMOPictureDownloader.m
//  Parallels-test
//
//  Created by Peter Molnar on 28/04/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMOPictureDownloader.h"

@interface PMOPictureDownloader()
@property (strong,nonatomic) NSURLSession *session;
@end

@implementation PMOPictureDownloader

-(void)downloadPictureImage {
    if (self.picture) {
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.picture.imageURL];
    
        __weak PMOPictureDownloader *weakSelf = self;
    NSURLSessionDataTask *downloadTask = [self.session dataTaskWithRequest:request completionHandler:
                                           ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                              
                                               UIImage *image = [UIImage imageWithData:data];
                                               weakSelf.picture.image = image;
                                              
                                               
                                           }];
        [downloadTask resume];
    }
    
    
    
}

-(NSURLSession *)session {

    if (!_session) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        //TODO: Check how and what should be parametarized for the session
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                 delegate:nil
                                            delegateQueue:nil];

    }
    
    return _session;
}


@end
