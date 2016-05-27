//
//  PMOThumbnailCreator.m
//  Parallels-test
//
//  Created by Peter Molnar on 10/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMOThumbnailCreator.h"

@implementation PMOThumbnailCreator

-(BOOL)isImageValid:(id)image {
    return image && [image isMemberOfClass:[UIImage class]];
}

-(BOOL)isSizeValid {
    return self.size.height != 0 && self.size.width != 0;
}

-(void)processData:(UIImage *)image withOptions:(id)options {
    if ( [self isSizeValid] && [self isImageValid:image]) {
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


-(void)notifyObserverWithProcessedData:(UIImage *)data {
    NSDictionary *userInfo = @{@"image" : data };
    [[NSNotificationCenter defaultCenter] postNotificationName:PMOThumbnailImageGenerated
                                                        object:self
                                                      userInfo:userInfo];
}

@end
