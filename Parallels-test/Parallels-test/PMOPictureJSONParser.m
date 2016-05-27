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

// Main data processing method
-(void)processData:(id)data withOptions:(NSDictionary *)options {
    NSOperationQueue *opQueue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *parsingOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSError *jsonError;
        NSArray *JSONData = [NSJSONSerialization JSONObjectWithData:data
                                                            options:0
                                                              error:&jsonError];
        
        [self notifyObserverWithProcessedData:JSONData];
        
    }];
    
    [opQueue addOperation:parsingOperation];

}


-(void)notifyObserverWithProcessedData:(id)data {
    NSDictionary *userInfo = @{@"json" : data };
    [[NSNotificationCenter defaultCenter] postNotificationName:PMOPictureJSONParsed
                                                        object:self
                                                      userInfo:userInfo];
}



@end
