//
//  PMOPictureDownloader.m
//  Parallels-test
//
//  Created by Peter Molnar on 28/04/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMOPictureDownloader.h"


@interface PMOPictureDownloader()
@end

@implementation PMOPictureDownloader

- (void)notifyObserverWithProcessedData:(NSData *)data {
    NSDictionary *userInfo = @{@"data" : data};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PMOPictureDownloaderImageDidDownloaded
                                                        object:self
                                                      userInfo:userInfo];
    
}


@end
