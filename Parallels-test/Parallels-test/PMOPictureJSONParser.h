//
//  PMOPictureJSONParser.h
//  Parallels-test
//
//  Created by Peter Molnar on 10/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMOOperationWithQueue.h"
#import "PMOBackgroundTaskExecutable.h"

// JSON parser with NSOperationQueue
//

// String constant for the NSNotificationCenter notification
static NSString *const PMOPictureJSONParsed = @"PMOPictureJSONParsed";

@interface PMOPictureJSONParser : PMOOperationWithQueue <PMOBackgroundTaskExecutable>

@end
