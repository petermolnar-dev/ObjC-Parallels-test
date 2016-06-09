//
//  PMOImageViewScrollViewFactory.h
//  Parallels-test
//
//  Created by Peter Molnar on 09/06/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface PMOImageViewScrollViewFactory : NSObject

+ (UIScrollView *)scrollviewFactoryWithParentView:(UIView *)parentView;

@end
