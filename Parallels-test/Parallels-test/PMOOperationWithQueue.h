//
//  PMOOperationWithQueue.h
//  Parallels-test
//
//  Created by Peter Molnar on 16/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

@import Foundation;

// Abstract class, only for inheritance
//
@interface PMOOperationWithQueue : NSObject

// GCD queue for the main operation task.
// If nothing is set up, lazily instantiated with a default queue.
@property (retain, nonatomic)NSOperationQueue *sharedQueue;

@end
