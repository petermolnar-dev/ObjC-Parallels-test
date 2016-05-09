//
//  PMOPicture.h
//  Parallels_test
//
//  Created by Peter Molnar on 09/02/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//
#define kBaseURLForImages [NSString stringWithFormat:@"http://93.175.29.76/web/wwdc/"]

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface PMOPicture : NSObject
@property (copy,nonatomic) NSString *imageDescription;
@property (copy,nonatomic) NSString *imageFileName;
@property (copy,nonatomic) NSString *imageTitle;
@property (copy,nonatomic) NSURL *imageURL;
@property (strong,nonatomic) UIImage *image;
@property (strong,nonatomic) UIImage *thumbnailImage;


@end
