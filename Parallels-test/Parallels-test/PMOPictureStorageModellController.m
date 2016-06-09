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
#import "PMOPictureModellControllerFactory.h"

@interface PMOPictureStorageModellController()

@property (strong, nonatomic) NSMutableArray *pictures;

@end

@implementation PMOPictureStorageModellController

#pragma mark - Accessors
- (NSMutableArray *)pictures {
    if (!_pictures) {
        _pictures = [[NSMutableArray alloc] init];
    }
    
    return _pictures;
}


#pragma mark - Public API
- (void)setupFromJSONFileatURL:(NSURL *)url baseURLStringForImages:(NSString *)baseURLString {
    
    [self addObserversForDownloadData];
    self.baseURLAsString = [PMOPictureModellControllerFactory updateURLAsStringWithTrailingHash:baseURLString];
    PMODataDownloader *downloader = [[PMODataDownloader alloc] init];
    [downloader downloadDataFromURL:url];
    
}


- (NSArray *)pictureList {
   return [NSArray arrayWithArray:self.pictures];
}

- (PMOPictureModellController *)pictureModellAtIndex:(NSUInteger)index {
    return [self.pictures objectAtIndex:index];
}

- (NSUInteger)countOfPictures {
    return [self.pictureList count];
}


#pragma mark - Observer functions
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

- (void)removeObserversForDownloadData {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:PMODataDownloaderDidDownloadEnded
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:PMODataDownloaderError
                                                  object:nil];
}

- (void)didReceiveDownloadNotification:(NSNotification *) notification {

    [self removeObserversForDownloadData];
    
    NSData *jsonData =[notification.userInfo objectForKey:@"data"];
    if (jsonData) {
        [self parseData:jsonData];
    } else {
        NSLog(@"Error retreiving JSON Data");
    }
}

#pragma mark - Observer triggers
-(void)didReceiveDownloadFailureNotification:(NSNotification *) notification {
    NSError *downloadError = [notification.userInfo objectForKey:@"error"];
    NSLog(@"Error while retrieveing the data: %@", [downloadError localizedDescription]);
    
}


- (void)didReceiveJSONParserNotification:(NSNotification *) notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:PMOPictureJSONParsed
                                                  object:nil];
    // Make the count of the list KVO compliant
    [self willChangeValueForKey:@"countOfPictures"];
    NSArray *pictureDetails = [notification.userInfo objectForKey:@"json"];
    for (NSDictionary *currentPictureDetails in pictureDetails) {
        PMOPictureModellController *currentController = [PMOPictureModellControllerFactory modellControllerFromDictionary:currentPictureDetails
                                                                                              baseURLAsStringForImage:self.baseURLAsString];
        [self.pictures addObject:currentController];
    }
    [self didChangeValueForKey:@"countOfPictures"];
}

#pragma  mark - Helper functions
- (void)parseData:(NSData *)data {
    
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(didReceiveJSONParserNotification:)
                                                         name:PMOPictureJSONParsed
                                                       object:nil];

            PMOPictureJSONParser *parser = [[PMOPictureJSONParser alloc] init];
            [parser processData:data withOptions:nil];
}


@end
