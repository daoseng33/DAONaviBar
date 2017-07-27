//
//  DAODelegateRouter.h
//  DAONaviBar
//
//  Created by daoseng on 2017/7/27.
//  Copyright © 2017年 LikeABossApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAODelegateRouter : NSObject

@property (weak, nonatomic) id<UIScrollViewDelegate> currentViewDelegate;
@property (weak, nonatomic) id<UIScrollViewDelegate> superViewDelegate;

- (instancetype)initWithCurrentViewDelegate:(id)currentViewDelegate superViewDelegate:(id)superViewDelegate;

@end
