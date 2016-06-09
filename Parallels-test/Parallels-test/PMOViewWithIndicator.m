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
@property (weak, nonatomic)UIActivityIndicatorView *loadingActivity;
@property (unsafe_unretained, nonatomic) BOOL isSpinnerOn;

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
        self.isSpinnerOn = true;
        self.loadingActivity = [self addSpinnerToView:self];
        
        [self setNeedsDisplay];
    }];
}

-(void)stopSpinner {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.loadingActivity stopAnimating];
        [self.loadingActivity removeFromSuperview];
        self.isSpinnerOn = false;
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

#pragma mark - Error message display
- (void)displayErrorMessage:(NSError *)error {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self stopSpinner];
        
        UILabel *errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        errorLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        errorLabel.center = self.center;
        errorLabel.textAlignment = NSTextAlignmentCenter;
        
        errorLabel.text = [error localizedDescription];
        
        [self addSubview:errorLabel];
    }];
}

#pragma mark - Notification actions
- (void)didReceiveDownloadErrorNotification:(NSNotification *)notification  {
    NSError *error = [notification.userInfo objectForKey:@"error"];
    [self displayErrorMessage:error];
}


@end
