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

@interface PMOPictureStorageModellController()

@property (strong, nonatomic) NSMutableArray *pictures;

@end

@implementation PMOPictureStorageModellController

-(void)setupFromJSONFileatURL:(NSURL *)url {
    
    [self addObserversForDownloadData];
    PMODataDownloader *downloader = [[PMODataDownloader alloc] init];
    [downloader downloadDataFromURL:url];
    
}


-(NSArray *)pictureList {
   return [NSArray arrayWithArray:self.pictures];
}

- (PMOPictureModelController *)pictureModelAtIndex:(NSUInteger)index {
    return [self.pictures objectAtIndex:index];
}

- (NSUInteger)countOfPictures {
    return [self.pictureList count];
}

- (void)addObserversForDownloadData {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDownloadNotification:)
                                                 name:PMODataDownloaderDidDownloadEnded
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDownloadFailureNotification:)
                                                 name:PMODataDownloaderError
                                               object:nil];

}

-(void)removeObserversForDownloadData {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:PMODataDownloaderDidDownloadEnded
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:PMODataDownloaderError
                                                  object:nil];
}

-(void)didReceiveDownloadNotification:(NSNotification *) notification {

    [self removeObserversForDownloadData];
    
    NSData *jsonData =[notification.userInfo objectForKey:@"data"];
    if (jsonData) {
        [self parseData:jsonData];
    } else {
        NSLog(@"Error retreiving JSON Data");
    }
}

-(void)didReceiveDownloadFailureNotification:(NSNotification *) notification {
    NSError *downloadError = [notification.userInfo objectForKey:@"error"];
    NSLog(@"Error while retrieveing the data: %@", [downloadError localizedDescription]);
    
}


-(void)didReceiveJSONParserNotification:(NSNotification *) notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:PMOPictureJSONParsed
                                                  object:nil];
    // Make the count of the list KVO compliant
    [self willChangeValueForKey:@"countOfPictures"];
    self.pictures = [notification.userInfo objectForKey:@"json"];
    [self didChangeValueForKey:@"countOfPictures"];
}


-(void)parseData:(NSData *)data {
    
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(didReceiveJSONParserNotification:)
                                                         name:PMOPictureJSONParsed
                                                       object:nil];

            PMOPictureJSONParser *parser = [[PMOPictureJSONParser alloc] init];
            [parser processData:data withOptions:nil];
    
}


@end
