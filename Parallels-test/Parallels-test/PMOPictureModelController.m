//
//  PMOPictureModelController.m
//  Parallels-test
//
//  Created by Peter Molnar on 28/04/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMOPictureModelController.h"
#import "PMOPictureDownloaderWithQueues.h"


@interface PMOPictureModelController()

@property (strong, nonatomic) NSMutableArray *pictures;


@end

@implementation PMOPictureModelController


-(void)observerForDownloadNotification: (NSNotification *) notification {
    
    // Update the model with KVO compliant mode
    [self.picture setValue:[UIImage imageWithData:[notification.userInfo valueForKey:@"data"]]
                    forKey:@"image"];
    
    [self createThumbnailImageFromImage:self.picture.image];
}

-(void)observerForImageTransformationNotification: (NSNotification *) notification {
    
    // Update the model with KVO compliant mode
    [self.picture setValue:[UIImage imageWithData:[notification.userInfo valueForKey:@"data"]]
                    forKey:@"thumbnailImage"];
    
    
}


- (void)createPictureFromDictionary:(NSDictionary *)pictureDetails baseURLAsStringForImage:(NSString *)baseURLAsString {
    
    self.picture = [self setupPictureDetailsFromDictionary:pictureDetails
                                   baseURLAsStringForImage:baseURLAsString];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(observerForDownloadNotification:)
                                                 name:PMOPictureDownloaderImageDidDownloaded
                                               object:nil];
    PMOPictureDownloaderWithQueues *downloader = [[PMOPictureDownloaderWithQueues alloc] init];
    
    // Start to download the image
    [downloader setQueues:self.downloadQueues];
    [downloader downloadDataFromURL:self.picture.imageURL];
    
    
}

- (NSString *)updateURLAsStringWithTrailingHash:(NSString *)URLstring {
    
    // Check if the URL ends with slash (/) character.
    if (![[URLstring substringFromIndex:[URLstring length]-1] isEqual:@"/"]) {
        URLstring= [URLstring stringByAppendingString:@"/"];
    }
    return URLstring;
}

-(PMOPicture *)setupPictureDetailsFromDictionary:(NSDictionary *)pictureDetails  baseURLAsStringForImage:(NSString *)baseURLAsString {
    
    PMOPicture *picture = [[PMOPicture alloc] init];
    [picture setImageDescription:[pictureDetails objectForKey:@"description"]];
    [picture setImageFileName:[pictureDetails objectForKey:@"image"]];
    [picture setImageTitle:[pictureDetails objectForKey:@"name"]];
    [picture setImageURL:[NSURL URLWithString:[[self updateURLAsStringWithTrailingHash:baseURLAsString] stringByAppendingString:picture.imageFileName]]];
    
    return picture;
}

-(void) createThumbnailImageFromImage:(UIImage *)image {
    // Add an observer
    // call the class to make the transform
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:PMODataDownloaderDidDownloadEnded
                                                  object:nil];
}

@end
