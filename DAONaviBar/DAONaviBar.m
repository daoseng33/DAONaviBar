//
//  DAONaviBar.m
//  AlleyStore
//
//  Created by daoseng on 2017/7/26.
//  Copyright © 2017年 LikeABossApp.All rights reserved.
//

#import "DAONaviBar.h"
#import "HTDelegateProxy.h"

static CGFloat foldNaviHeight = 24.0;
static CGFloat expandNaviHeight = 44.0;

@interface DAONaviBar () <UIScrollViewDelegate>

@property (weak, nonatomic) UIViewController *vc;
@property (weak, nonatomic) UIWindow *statusBarWindow;
@property (strong, nonatomic) UIView *cloneBackView;

@property (nonatomic) CGFloat previousScrollViewYOffset;
@property (nonatomic) CGRect originalBackButtonFrame;
@property (assign, nonatomic) BOOL isScrollAnimating;
@property (strong, nonatomic) HTDelegateProxy *delegateProxy;

@end

@implementation DAONaviBar

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.isDragging) {
        CGFloat scrollHeight = scrollView.frame.size.height;
        CGFloat scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom;
        CGFloat scrollOffset = scrollView.contentOffset.y;
        
        CGRect statusFrame = self.statusBarWindow.frame;
        CGFloat framePercentage = ((0 - statusFrame.origin.y) / CGRectGetHeight([UIApplication sharedApplication].statusBarFrame));
        CGFloat scrollDiff = scrollOffset - self.previousScrollViewYOffset;
        
        if (scrollOffset <= -scrollView.contentInset.top) {
            [self showStatusBar:YES completion:nil];
        }
        else if (scrollOffset + scrollHeight >= scrollContentSizeHeight) {
            [self showStatusBar:NO completion:nil];
        }
        else {
            // 滑動速度
            CGFloat velocity = 40;
            
            if (scrollDiff > velocity) {
                [self showStatusBar:NO completion:nil];
            }
            else if (scrollDiff < -velocity) {
                [self showStatusBar:YES completion:nil];
            }
        }
        
        if (!self.isScrollAnimating) {
            // 數值越大滑動效果越慢
            CGFloat velocityLevel = 6.0;
            
            statusFrame.origin.y = MIN(0, MAX(-CGRectGetHeight([UIApplication sharedApplication].statusBarFrame), statusFrame.origin.y - (scrollDiff / velocityLevel)));
            self.statusBarWindow.frame = statusFrame;

            CGRect frame = self.vc.navigationController.navigationBar.frame;
            frame.origin.y = MIN(CGRectGetHeight([UIApplication sharedApplication].statusBarFrame), MAX(0, frame.origin.y - (scrollDiff / velocityLevel)));
            frame.size.height = MIN(expandNaviHeight, MAX(foldNaviHeight, frame.size.height - (scrollDiff / velocityLevel)));
            [self.vc.navigationController.navigationBar setFrame:frame];
            
            [self updateBarButtonItems:framePercentage];
            [self updateStatusBar:framePercentage];
        }
        
        self.previousScrollViewYOffset = scrollOffset;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self stoppedScrolling];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self stoppedScrolling];
    }
}

#pragma - animation

- (void)stoppedScrolling {
    [self showStatusBar:self.statusBarWindow.frame.origin.y >= 0 - (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) / 2) completion:nil];
}

- (void)showStatusBar:(BOOL)show completion:(void (^ __nullable)(void))completion {
    self.isScrollAnimating = YES;
    
    CGRect statusFrame = self.statusBarWindow.frame;
    statusFrame.origin.y = show ? 0 : -CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    
    CGRect frame = self.vc.navigationController.navigationBar.frame;
    frame.origin.y = show ? CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) : 0;
    frame.size.height = show ? expandNaviHeight : foldNaviHeight;
    
    CGFloat percentage = show ? 0 : 1;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.statusBarWindow.frame = statusFrame;
        self.vc.navigationController.navigationBar.frame = frame;
        [self updateStatusBar:percentage];
        [self updateBarButtonItems:percentage];
    } completion:^(BOOL finished) {
        self.isScrollAnimating = NO;
        if(completion) {
            completion();
        }
    }];
}

- (void)updateStatusBar:(CGFloat)percentage {
    CGFloat alpha = 1 - percentage;
    self.statusBarWindow.alpha = alpha;
}

- (void)updateBarButtonItems:(CGFloat)percentage {
    CGFloat alpha = 1 - percentage;
    
    CGRect frame = self.cloneBackView.frame;
    frame.origin.y = CGRectGetMinY(self.originalBackButtonFrame) - (CGRectGetMinY(self.originalBackButtonFrame) * percentage);
    frame.origin.x = CGRectGetMinX(self.originalBackButtonFrame) - (10 * percentage);
    frame.size.height = CGRectGetHeight(self.originalBackButtonFrame) - ((CGRectGetHeight(self.originalBackButtonFrame) - foldNaviHeight) * percentage);
    self.cloneBackView.frame = frame;
    
    for (UIView *view in self.vc.navigationController.navigationBar.subviews) {
        if (![NSStringFromClass([view class]) isEqualToString:@"UINavigationButton"] && ![NSStringFromClass([view class]) isEqualToString:@"_UINavigationBarBackIndicatorView"] && ![NSStringFromClass([view class]) isEqualToString:@"_UIBarBackground"] && ![NSStringFromClass([view class]) isEqualToString:@"_UINavigationBarBackground"] && view != self.cloneBackView) {
            view.alpha = alpha;
        }
    }
}

#pragma mark - misc

- (void)tap:(UITapGestureRecognizer *)sender {
    [self showStatusBar:YES completion:nil];
}

- (void)back:(UITapGestureRecognizer *)sender {
    [self showStatusBar:YES completion:^ {
        [self showDefaultBackButton];
        
        if ([self isModal]) {
            [self.vc dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            [self.vc.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)showDefaultBackButton {
    for (UIView *view in self.vc.navigationController.navigationBar.subviews) {
        if ([NSStringFromClass([view class]) isEqualToString:@"UINavigationButton"]) {
            view.alpha = 1.0;
            [self.cloneBackView removeFromSuperview];
        }
    }
}

- (BOOL)isModal {
    if([self.vc presentingViewController])
        return YES;
    if([[[self.vc navigationController] presentingViewController] presentedViewController] == [self.vc navigationController])
        return YES;
    if([[[self.vc tabBarController] presentingViewController] isKindOfClass:[UITabBarController class]])
        return YES;
    
    return NO;
}

#pragma mark - init values

+ (instancetype)sharedInstance {
    static DAONaviBar *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DAONaviBar alloc] init];
    });
    return instance;
}

- (void)setupWithController:(UIViewController *)vc scrollView:(UIScrollView *)scrollView {
    self.vc = vc;
    self.delegateProxy = [[HTDelegateProxy alloc] initWithDelegates:@[self, vc]];
    scrollView.delegate = (id)self.delegateProxy;
    
    [self setupInitValues];
    [self setupBackImageView];
}

- (void)setupInitValues {
    self.statusBarWindow = (UIWindow *)[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.vc.navigationController.navigationBar addGestureRecognizer:tapGR];
}

- (void)setupBackImageView {
    for (UIView *view in self.vc.navigationController.navigationBar.subviews) {
        if ([NSStringFromClass([view class]) isEqualToString:@"UINavigationButton"]) {
            self.cloneBackView = [[UIView alloc] initWithFrame:view.frame];
            self.originalBackButtonFrame = view.frame;
            
            for (UIImageView *imageView in view.subviews) {
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                UIImageView *newImageView = [[UIImageView alloc] initWithFrame:imageView.frame];
                newImageView.contentMode = UIViewContentModeScaleAspectFit;
                newImageView.image = imageView.image;
                newImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
                [self.cloneBackView addSubview:newImageView];
            }

            UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
            [self.cloneBackView addGestureRecognizer:tapGR];
            [self.vc.navigationController.navigationBar addSubview:self.cloneBackView];
            
            view.alpha = 0;
        }
    }
}

@end
