//
//  PMOPictureJSONParser.h
//  Parallels-test
//
//  Created by Peter Molnar on 10/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import <Foundation/Foundation.h>

// String constant for the NSNotificationCenter notification
static NSString *const PMOPictureJSONParsed = @"PMOPictureJSONParsed";

@interface PMOPictureJSONParser : NSObject
-(void)downloadDataFromURL:(NSURL *)url;
@end
