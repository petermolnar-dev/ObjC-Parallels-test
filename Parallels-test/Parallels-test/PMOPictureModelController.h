//
//  PMOPictureModelController.h
//  Parallels-test
//
//  Created by Peter Molnar on 28/04/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMOPicture.h"

#import "PMODownloadTaskQueues.h"

@interface PMOPictureModelController : NSObject

@property (copy, nonatomic) NSString *baseURLAsString;
@property (strong, nonatomic) PMOPicture *picture;

@property (weak, nonatomic) PMODownloadTaskQueues *downloadQueues;

@property (weak, nonatomic, readonly) UIImage *image;
@property (weak, nonatomic, readonly) UIImage *thumbnailImage;

- (void)createPictureFromDictionary:(NSDictionary *)pictureDetails baseURLAsStringForImage:(NSString *)baseURLAsString;
- (void)requestDownloadOfThePictureImage;

@end
