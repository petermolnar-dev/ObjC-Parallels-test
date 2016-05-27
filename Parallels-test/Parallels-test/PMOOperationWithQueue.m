//
//  PMOOperationWithQueue.m
//  Parallels-test
//
//  Created by Peter Molnar on 16/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMOOperationWithQueue.h"

@implementation PMOOperationWithQueue


- (NSOperationQueue *)sharedQueue {
    if (!_sharedQueue) {
        _sharedQueue =[[NSOperationQueue alloc] init];
    }
    
    return _sharedQueue;
}

@end
