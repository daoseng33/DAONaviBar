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

@interface TableViewController ()

@end

@implementation TableViewController

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"original navi bar";
            break;
            
        case 1:
            cell.textLabel.text = @"smooooth navi bar";
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WebViewController *vc = [WebViewController new];
    vc.url = @"http://apple.com";
    switch (indexPath.row) {
        case 0: {
            vc.title = @"Original navi";
            vc.isOriginal = YES;
            break;
        }
            
        case 1: {
            vc.title = @"Smooooth navi";
            vc.isOriginal = NO;
            break;
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
