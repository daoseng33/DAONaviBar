//
//  WebViewController.m
//  DAONaviBar
//
//  Created by daoseng on 2017/7/26.
//  Copyright © 2017年 LikeABossApp. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
#import "DAONaviBar.h"

@interface WebViewController ()

@property (strong, nonatomic) WKWebView *webView;

@end

@implementation WebViewController

- (void)setupInitValues {
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupWebView {
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:theConfiguration];
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    NSURL *nsurl = [NSURL URLWithString:self.url];
    NSURLRequest *nsrequest = [NSURLRequest requestWithURL:nsurl];
    [self.webView loadRequest:nsrequest];
    [self.view addSubview:self.webView];
}

#pragma mark - setup

- (void)setupDefaultBackButton {
    UIImage *image = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)setupDAONaviBar {
    [[DAONaviBar sharedInstance] setupWithController:self scrollView:self.webView.scrollView hideTitle:self.hideTitle];
}

#pragma mark - misc

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitValues];
    [self setupWebView];
    [self setupDefaultBackButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.isOriginal) {
        [self setupDAONaviBar];
    }
}

- (void)dealloc {
    self.webView.scrollView.delegate = nil;
}

@end
