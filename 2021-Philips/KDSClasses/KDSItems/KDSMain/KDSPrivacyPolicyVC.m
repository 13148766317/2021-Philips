//
//  KDSPrivacyPolicyVC.m
//  2021-Philips
//
//  Created by zhaoxueping on 2020/8/26.
//  Copyright © 2020 com.Kaadas. All rights reserved.
//

#import "KDSPrivacyPolicyVC.h"
#import <WebKit/WebKit.h>
@interface KDSPrivacyPolicyVC ()<WKNavigationDelegate, WKUIDelegate>

@property (nonatomic,strong)  WKWebView *webView;
@property (nonatomic, assign) BOOL isLocalFile;
@property (nonatomic ,strong) NSString *privaryURl;



@end

@implementation KDSPrivacyPolicyVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationTitleLabel.text = Localized(@"privacyPolicy");
    self.view.backgroundColor = KDSRGBColor(242, 242, 242);

    [self setRightButton];

    self.webView = [WKWebView new];
    [self.view addSubview:self.webView];
    self.isLocalFile =NO;
    self.privaryURl = @"http://h5.kaadas.cc/Philips_Privacy_Policy";
    //设置自动缩放网页以适应该控件
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];

    NSString * url = self.privaryURl;
    
    if (self.isLocalFile) {
        //加载本地html
        NSURL *pathURL = [NSURL fileURLWithPath:url];
        [self.webView loadRequest:[NSURLRequest requestWithURL:pathURL]];
    }else
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        //加载指定URL对应的网页
        [self.webView loadRequest:request];
    }

}


@end
