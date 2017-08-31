//
//  WebViewController.h
//  DAONaviBar
//
//  Created by daoseng on 2017/7/26.
//  Copyright © 2017年 LikeABossApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (nonatomic) BOOL isOriginal;
@property (nonatomic) BOOL hideTitle;
@property (strong, nonatomic) NSString *url;

@end
