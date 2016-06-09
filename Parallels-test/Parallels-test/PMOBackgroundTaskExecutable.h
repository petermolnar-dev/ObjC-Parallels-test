//
//  PMOBackgroundTaskExecutable.h
//  Parallels-test
//
//  Created by Peter Molnar on 15/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//
#import "PMOExecutionNotifier.h"

@protocol PMOBackgroundTaskExecutable <PMOExecutionNotifier>

- (void) processData:(id)data withOptions:(id)options;

@end