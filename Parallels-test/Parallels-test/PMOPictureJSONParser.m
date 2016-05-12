//
//  PMOPictureJSONParser.m
//  Parallels-test
//
//  Created by Peter Molnar on 10/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMOPictureJSONParser.h"
#import "PMODataDownloader.h"

@implementation PMOPictureJSONParser



-(void)parseData:(NSData *)data {
    NSOperationQueue *opQueue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *parsingOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSError *jsonError;
        NSArray *JSONData = [NSJSONSerialization JSONObjectWithData:data
                                                            options:0
                                                              error:&jsonError];
        
        [self notifyObserversWithParsedData:JSONData];
        
    }];
    
    [opQueue addOperation:parsingOperation];
}


-(void)notifyObserversWithParsedData:(NSArray *)data {
    NSDictionary *userInfo = @{@"json" : data };
    [[NSNotificationCenter defaultCenter] postNotificationName:PMOPictureJSONParsed
                                                        object:self
                                                      userInfo:userInfo];
}
@end
