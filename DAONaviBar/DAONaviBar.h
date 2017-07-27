//
//  DAONaviBar.h
//  AlleyStore
//
//  Created by daoseng on 2017/7/26.
//  Copyright © 2017年 LikeABossApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAONaviBar : NSObject

+ (instancetype)sharedInstance;

- (void)setupWithController:(UIViewController *)vc scrollView:(UIScrollView *)scrollView;

@end
