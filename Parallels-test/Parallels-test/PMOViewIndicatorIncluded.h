//
//  PMOViewIndicatorIncluded.h
//  Parallels-test
//
//  Created by Peter Molnar on 30/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@protocol PMOViewIndicatorIncluded <NSObject>

- (void)startSpinner;
- (void)stopSpinner;

- (UIActivityIndicatorView *)addSpinnerToView:(UIView *)parentView;
- (void)displayErrorMessage:(NSError *)error;
- (void)displayInitialMessage:(NSString *)initialMessage;
- (void)hideMessageLabel;

@end
