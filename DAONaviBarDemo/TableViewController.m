//
//  TableViewController.m
//  DAONaviBar
//
//  Created by daoseng on 2017/7/26.
//  Copyright © 2017年 LikeABossApp. All rights reserved.
//

#import "TableViewController.h"
#import "WebViewController.h"
#import "DAONaviBar.h"

typedef NS_ENUM (NSInteger, NaviBarType) {
    NaviBarTypeOriginal = 0,
    NaviBarTypeShowTitle,
    NaviBarTypeHideTitle
};

@interface TableViewController ()

@end

@implementation TableViewController

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    switch ((NaviBarType)indexPath.row) {
        case NaviBarTypeOriginal:
            cell.textLabel.text = @"original navi bar";
            break;
            
        case NaviBarTypeShowTitle:
            cell.textLabel.text = @"smooooth navi bar - show title";
            break;
            
        case NaviBarTypeHideTitle:
            cell.textLabel.text = @"smooooth navi bar - hide title";
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WebViewController *vc = [WebViewController new];
    vc.url = @"http://apple.com";
    switch ((NaviBarType)indexPath.row) {
        case NaviBarTypeOriginal: {
            vc.title = @"Original navi";
            vc.isOriginal = YES;
            break;
        }
            
        case NaviBarTypeShowTitle: {
            vc.title = @"smooooth navi";
            vc.isOriginal = NO;
            vc.hideTitle = NO;
            break;
        }
            
        case NaviBarTypeHideTitle: {
            vc.title = @"smooooth navi";
            vc.isOriginal = NO;
            vc.hideTitle = YES;
        }
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
