//
//  PMOViewWithIndicator.m
//  Parallels-test
//
//  Created by Peter Molnar on 27/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMOViewWithIndicator.h"
#import "PMODataDownloadNotifications.h"


@interface PMOViewWithIndicator()
@property (strong, nonatomic)UIActivityIndicatorView *loadingActivity;
@property (strong, nonatomic)UILabel *displayLabel;
@end

@implementation PMOViewWithIndicator

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveDownloadErrorNotification:) name:PMODataDownloaderError
                                                   object:nil];
    }
    
    return self;
}

#pragma mark - Spinner and ON/OFF
- (void)startSpinner {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (!self.loadingActivity) {
            self.loadingActivity = [self addSpinnerToView:self];
        } else {
            self.loadingActivity.hidden = false;
            [self.loadingActivity startAnimating];
        }
        
        [self setNeedsDisplay];
    }];
}

- (void)stopSpinner {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.loadingActivity stopAnimating];
        self.loadingActivity.hidden = true;
        [self setNeedsDisplay];
    }];
}

- (UIActivityIndicatorView *)addSpinnerToView:(UIView *)parentView {
    UIActivityIndicatorView *loadingActivity;
    
    if (self.bounds.size.width > [UIScreen mainScreen].bounds.size.width/2) {
        loadingActivity = [[UIActivityIndicatorView alloc]
                           initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    } else {
        loadingActivity = [[UIActivityIndicatorView alloc]
                           initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
    }
    [loadingActivity setColor:[UIColor blackColor]];
    [parentView addSubview:loadingActivity];
    [parentView bringSubviewToFront:loadingActivity];
    loadingActivity.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    loadingActivity.center = parentView.center;
    [loadingActivity startAnimating];
    
    return loadingActivity;
}

#pragma mark - Helpers

- (void)displayMessage:(NSString *)message {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self stopSpinner];
        
        UILabel *displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        displayLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        displayLabel.center = self.center;
        displayLabel.textAlignment = NSTextAlignmentCenter;
        
        displayLabel.text = message;
        self.displayLabel = displayLabel;
        [self addSubview:self.displayLabel];
    }];
    
}


#pragma mark - Error message display
- (void)displayErrorMessage:(NSError *)error {
    [self displayMessage:[error localizedDescription]];
}

#pragma mark - Display an initial message
- (void)displayInitialMessage:(NSString *)initialMessage {
    [self displayMessage:initialMessage];
    
}

- (void)hideMessageLabel {
    if (self.displayLabel) {
        [self.displayLabel removeFromSuperview];
    }
}

#pragma mark - Notification actions
- (void)didReceiveDownloadErrorNotification:(NSNotification *)notification  {
    NSError *error = [notification.userInfo objectForKey:@"error"];
    [self displayErrorMessage:error];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
