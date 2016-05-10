//
//  PMOThumbnailCreator.m
//  Parallels-test
//
//  Created by Peter Molnar on 10/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMOThumbnailCreator.h"

@implementation PMOThumbnailCreator

-(void) resizeImageWithFixedValues:(UIImage *)image size:(CGSize)size {
    NSBlockOperation *transformBlockOP =[NSBlockOperation blockOperationWithBlock:^{
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
        // draw scaled image into thumbnail context
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *newThumbnail = UIGraphicsGetImageFromCurrentImageContext();
        // pop the context
        UIGraphicsEndImageContext();
        [self notifyObserversWithTranfromedData:newThumbnail];
    }];
   
    [self.sharedQueue addOperation:transformBlockOP];
}


-(void)notifyObserversWithTranfromedData:(UIImage *)data {
    NSDictionary *userInfo = @{@"image" : data };
    [[NSNotificationCenter defaultCenter] postNotificationName:PMOThumbnailImageGenerated
                                                        object:self
                                                      userInfo:userInfo];
}

- (NSOperationQueue *)sharedQueue {
    if (!_sharedQueue) {
        // sharedQueue hasn't benn injected, create a new one
        _sharedQueue =[[NSOperationQueue alloc] init];
    }
    
    return _sharedQueue;
}
@end
