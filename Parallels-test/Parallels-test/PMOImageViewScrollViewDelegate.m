//
//  PMOImageViewScrollViewDelegate.m
//  Parallels-test
//
//  Created by Peter Molnar on 01/06/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMOImageViewScrollViewDelegate.h"

@implementation PMOImageViewScrollViewDelegate


- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
        scrollView.contentSize = CGSizeMake(self.scrollDestinationView.frame.size.width * scrollView.zoomScale, self.scrollDestinationView.frame.size.height * scrollView.zoomScale);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.scrollDestinationView;
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    scrollView.contentSize = CGSizeMake(self.scrollDestinationView.frame.size.width * scale, self.scrollDestinationView.frame.size.height * scale);
}
@end
