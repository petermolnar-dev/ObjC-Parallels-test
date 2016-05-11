//
//  PMOPIctureStorageModellController.m
//  Parallels-test
//
//  Created by Peter Molnar on 10/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMOPictureStorageModellController.h"
#import "PMOPictureJSONParser.h"

@implementation PMOPictureStorageModellController

-(instancetype)initFromJSONFileatURL:(NSURL *)url {
    
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(observerForJSONParser:)
                                                     name:PMOPictureJSONParsed
                                                   object:nil];
        
        PMOPictureJSONParser *parser = [[PMOPictureJSONParser alloc] init];
        [parser downloadDataFromURL:url];
    }
    
    return self;
}

-(void)observerForJSONParser:(NSDictionary *) userInfo {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:PMOPictureJSONParsed
                                                  object:nil];
    NSLog(@"UserInfo: %@", userInfo);
}

@end
