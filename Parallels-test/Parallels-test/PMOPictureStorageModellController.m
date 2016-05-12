//
//  PMOPIctureStorageModellController.m
//  Parallels-test
//
//  Created by Peter Molnar on 10/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMOPictureStorageModellController.h"
#import "PMOPictureJSONParser.h"
#import "PMODataDownloader.h"

@implementation PMOPictureStorageModellController

-(void)observerForDownloadedData:(NSNotification *) notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:PMODataDownloaderDidDownloadEnded
                                                  object:nil];
    NSData *jsonData =[notification.userInfo objectForKey:@"data"];
    [self parseData:jsonData];
}


-(void)setupFromJSONFileatURL:(NSURL *)url {
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(observerForDownloadedData:)
                                                     name:PMODataDownloaderDidDownloadEnded
                                                   object:nil];
        PMODataDownloader *downloader = [[PMODataDownloader alloc] init];
        [downloader downloadDataFromURL:url];

        


}

-(void)observerForJSONParser:(NSNotification *) notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:PMOPictureJSONParsed
                                                  object:nil];
    self.pictures = [notification.userInfo objectForKey:@"json"];
    NSLog(@"pictureList: %@", self.pictures);
}


-(void)parseData:(NSData *)data {
    
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(observerForJSONParser:)
                                                         name:PMOPictureJSONParsed
                                                       object:nil];

            PMOPictureJSONParser *parser = [[PMOPictureJSONParser alloc] init];
            [parser parseData:data];
    
}




@end
