//
//  PMOImageViewScrollViewDelegate.h
//  Parallels-test
//
//  Created by Peter Molnar on 01/06/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface PMOImageViewScrollViewDelegate : NSObject <UIScrollViewDelegate>
@property (weak, nonatomic) UIView *scrollDestinationView;
@property (weak, nonatomic) UIView *parentView;

- (UIScrollView *)scrollviewFactory;

@end
