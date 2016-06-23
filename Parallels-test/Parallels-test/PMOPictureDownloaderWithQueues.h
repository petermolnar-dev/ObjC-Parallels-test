//
//  PMOPictureDownloaderWithQueues.h
//  Parallels-test
//
//  Created by Peter Molnar on 09/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMOPictureDownloader.h"
#import "PMODownloadTaskQueues.h"

@interface PMOPictureDownloaderWithQueues : PMOPictureDownloader

@property (weak, nonatomic) PMODownloadTaskQueues* queues;

@end
