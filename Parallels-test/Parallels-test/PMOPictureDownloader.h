//
//  PMOPictureDownloader.h
//  Parallels-test
//
//  Created by Peter Molnar on 28/04/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMODataDownloader.h"
#import "PMOPictureDownloaderNotifications.h"

@interface PMOPictureDownloader : PMODataDownloader

@property (copy, nonatomic) NSString *pictureKey;

@end
