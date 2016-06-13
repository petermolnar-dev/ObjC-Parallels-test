//
//  PMOThumbnailCreator.m
//  Parallels-test
//
//  Created by Peter Molnar on 10/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMOThumbnailCreator.h"
#import "PMOThumbnailCreatorNotification.h"

@interface PMOThumbnailCreator()

@property (copy, nonatomic) NSString *pictureKey;

@end

@implementation PMOThumbnailCreator

#pragma mark - Data validation
- (BOOL)isImageValid:(id)image {
    return image && [image isMemberOfClass:[UIImage class]];
}

- (BOOL)isSizeValid {
    return self.size.height != 0 && self.size.width != 0;
}

- (BOOL)isPictureKeyPassedWithOptions:(NSDictionary *)options {
    return [[options allKeys] indexOfObject:@"pictureKey"] != NSNotFound;
}


#pragma mark - Main function
- (void)processData:(UIImage *)image withOptions:(id)options {
    
    if ( [self isSizeValid] && [self isImageValid:image] && [self isPictureKeyPassedWithOptions:options]) {
        self.pictureKey = [options valueForKey:@"pictureKey"];
        NSBlockOperation *transformBlockOP =[NSBlockOperation blockOperationWithBlock:^{
            UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
            // draw scaled image into thumbnail context
            [image drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
            UIImage *newThumbnail = UIGraphicsGetImageFromCurrentImageContext();
            // pop the context
            UIGraphicsEndImageContext();
            [self notifyObserverWithProcessedData:newThumbnail];
        }];
        
        [self.sharedQueue addOperation:transformBlockOP];
    }
}

#pragma mark - Notification
- (void)notifyObserverWithProcessedData:(UIImage *)data {
    if (self.pictureKey) {
        
    NSDictionary *userInfo = @{@"image" : data ,
                               @"pictureKey" : self.pictureKey};
    [[NSNotificationCenter defaultCenter] postNotificationName:PMOThumbnailImageGenerated
                                                        object:self
                                                      userInfo:userInfo];
    } else {
        NSLog(@"PictureKey is missing");
    }
    
    }

@end
