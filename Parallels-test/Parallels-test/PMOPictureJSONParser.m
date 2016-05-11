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

-(void)downloadDataFromURL:(NSURL *)url {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(observerForDowloadedData:)
                                                 name:PMODataDownloaderDidDownloadEnded
                                               object:nil];
    PMODataDownloader *downloader = [[PMODataDownloader alloc] init];
    [downloader downloadDataFromURL:url];
    
}


-(void)parseData:(NSData *)data {
    NSOperationQueue *opQueue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *parsingOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSArray *JSONData = [NSJSONSerialization JSONObjectWithData:data
                                                           options:0
                                                             error:nil];
        [self notifyObserversWithParsedData:JSONData];
    }];
    
    [opQueue addOperation:parsingOperation];
}

-(void)observerForDowloadedData:(NSData *)data {

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:PMODataDownloaderDidDownloadEnded
                                                      object:nil];
    
    [self parseData:data];
}

-(void)notifyObserversWithParsedData:(NSArray *)data {
    NSDictionary *userInfo = @{@"data" : data };
    [[NSNotificationCenter defaultCenter] postNotificationName:PMOPictureJSONParsed
                                                        object:self
                                                      userInfo:userInfo];
}
@end
