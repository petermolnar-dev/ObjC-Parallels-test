//
//  PMOThumbnailCreator.h
//  Parallels-test
//
//  Created by Peter Molnar on 10/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// String constant for the NSNotificationCenter notification
static NSString *const PMOThumbnailImageGenerated = @"PMOThumbnailImageGenerated";

@interface PMOThumbnailCreator : NSObject

@property (retain, nonatomic) NSOperationQueue *sharedQueue;

-(void) resizeImageWithFixedValues:(UIImage *)image size:(CGSize)size;


@end
