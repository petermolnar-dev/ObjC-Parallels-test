//
//  PMOPictureModelController.m
//  Parallels-test
//
//  Created by Peter Molnar on 28/04/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMOPictureModellController.h"
#import "PMOPictureDownloaderWithQueues.h"
#import "PMOThumbnailCreator.h"


@implementation PMOPictureModellController

#pragma mark - Accessors
- (UIImage *)image {
    // Small trick: returns back the picture's image or triggers the download
    if (!self.picture.image) {
        [self requestDownloadOfThePictureImage];
    }
    return self.picture.image;
}

- (UIImage *)thumbnailImage {
    // Small trick: returns back the picture's thumbnailImage or triggers the download
    if (!self.picture.image) {
        [self requestDownloadOfThePictureImage];
    }
    return self.picture.thumbnailImage;
}

- (NSString *)imageFileName {
    if (self.picture) {
        return self.picture.imageFileName;
    } else {
        return nil;
    }
}

- (NSString *)imageTitle {
    if (self.picture) {
        return self.picture.imageTitle;
    } else {
        return nil;
    }
}

- (NSString *)imageDescription {
    if (self.picture) {
        return self.picture.imageDescription;
    } else {
        return nil;
    }
}

#pragma mark - observer helpers
- (void)addDownloadObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDownloadNotification:)
                                                 name:PMOPictureDownloaderImageDidDownloaded
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDownloadErrorNotification:) name:PMODataDownloaderError
                                               object:nil];
  
}

- (void)removeDownloadObservers {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:PMODataDownloaderDidDownloadEnded
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:PMODataDownloaderError
                                                  object:nil];

}

#pragma mark - Observer triggers
- (void)didReceiveDownloadNotification:(NSNotification *)notification {
    
    [self removeDownloadObservers];
    // Update the model with KVO compliant mode
    [self.picture setValue:[UIImage imageWithData:[notification.userInfo valueForKey:@"data"]]
                    forKey:@"image"];
    [self requestThumbnailImageFromImage:self.picture.image];
}

- (void)didReceiveImageTransformationNotification:(NSNotification *) notification {
    
    // Update the model with KVO compliant mode
    [self.picture setValue:[notification.userInfo valueForKey:@"image"]
                    forKey:@"thumbnailImage"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:PMOThumbnailImageGenerated
                                                  object:nil];
    
}

- (void)didReceiveDownloadErrorNotification:(NSNotification *)notification {

    [self removeDownloadObservers];
    NSError *error = [notification.userInfo objectForKey:@"error"];
    NSLog(@"Image downlad failed: %@",[error localizedDescription]);
}

#pragma mark - Dynamic image retrieving
- (void)requestDownloadOfThePictureImage {

    [self addDownloadObservers];
    PMOPictureDownloaderWithQueues *downloader = [[PMOPictureDownloaderWithQueues alloc] init];
    
    [downloader setQueues:self.downloadQueues];
    [downloader downloadDataFromURL:self.picture.imageURL];
}


- (void)requestThumbnailImageFromImage:(UIImage *)image {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveImageTransformationNotification:)
                                                 name:PMOThumbnailImageGenerated
                                               object:nil];
    PMOThumbnailCreator *thumbnailCreator = [[PMOThumbnailCreator alloc] init];
    thumbnailCreator.size = CGSizeMake(20.0, 20.0);
    [thumbnailCreator processData:self.image withOptions:nil];
    
    
}

- (void)changePictureDownloadPriorityToHigh {
    [self.downloadQueues changeDownloadTaskToHighPriorityQueueFromURL:self.picture.imageURL];
}

- (void)changePictureDownloadPriorityToDefault {
    [self.downloadQueues changeDownloadTaskToNormalPriorityQueueFromURL:self.picture.imageURL];
}

@end
