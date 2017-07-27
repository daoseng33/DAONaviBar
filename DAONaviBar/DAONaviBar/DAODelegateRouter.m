//
//  DAODelegateRouter.m
//  DAONaviBar
//
//  Created by daoseng on 2017/7/27.
//  Copyright © 2017年 LikeABossApp. All rights reserved.
//

#import "DAODelegateRouter.h"

@implementation DAODelegateRouter

- (instancetype)initWithCurrentViewDelegate:(id)currentViewDelegate superViewDelegate:(id)superViewDelegate {
    self = [super init];
    
    if (self) {
        self.currentViewDelegate = currentViewDelegate;
        self.superViewDelegate = superViewDelegate;
    }
    
    return self;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL aSelector = [anInvocation selector];
    if([self.currentViewDelegate respondsToSelector:aSelector]) {
        [anInvocation invokeWithTarget:self.currentViewDelegate];
    }
    if([self.superViewDelegate respondsToSelector:aSelector]) {
        [anInvocation invokeWithTarget:self.superViewDelegate];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *currentSignature = [(NSObject *)self.currentViewDelegate methodSignatureForSelector:aSelector];
    NSMethodSignature *superSignature = [(NSObject *)self.superViewDelegate methodSignatureForSelector:aSelector];
    
    if(currentSignature) {
        return currentSignature;
    }
    else if(superSignature) {
        return superSignature;
    }
    
    return nil;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if([self.currentViewDelegate respondsToSelector:aSelector] || [self.superViewDelegate respondsToSelector:aSelector]) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
