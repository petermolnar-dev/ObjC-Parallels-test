//
//  PMOPictureModelController.h
//  Parallels-test
//
//  Created by Peter Molnar on 28/04/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

@import Foundation;
@import UIKit;
@class PMOPicture;
@class PMODownloadTaskQueues;

// Class to hold and manipulate the data modell of PMOPicture
//
@interface PMOPictureModellController : NSObject

@property (strong, nonatomic) PMOPicture *picture;
@property (weak, nonatomic, readonly) UIImage *image;
@property (weak, nonatomic, readonly) UIImage *thumbnailImage;
@property (copy, nonatomic, readonly) NSString *imageTitle;
@property (copy, nonatomic, readonly) NSString *imageFileName;
@property (copy, nonatomic, readonly) NSString *imageDescription;
@property (copy, nonatomic, readonly) NSString *pictureKey;
@property (weak, nonatomic) PMODownloadTaskQueues *queues;

- (void)changePictureDownloadPriorityToHigh;
- (void)changePictureDownloadPriorityToDefault;


@end
