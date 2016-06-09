//
//  PMOImageViewScrollViewFactory.m
//  Parallels-test
//
//  Created by Peter Molnar on 09/06/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMOImageViewScrollViewFactory.h"

@implementation PMOImageViewScrollViewFactory

+ (UIScrollView *)scrollviewFactoryWithParentView:(UIView *)parentView {
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,0,parentView.frame.size.height,parentView.frame.size.height)];
    scrollView.showsVerticalScrollIndicator=YES;
    scrollView.scrollEnabled=YES;
    scrollView.userInteractionEnabled=YES;
    scrollView.zoomScale = 1.0;
    scrollView.minimumZoomScale = 0.02;
    scrollView.maximumZoomScale = 2.0;
    [parentView addSubview:scrollView];
    return scrollView;
    
}
@end
