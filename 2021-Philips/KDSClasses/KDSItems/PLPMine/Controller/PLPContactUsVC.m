//
//  PLPContactUsVC.m
//  2021-Philips
//
//  Created by Apple on 2021/5/7.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPContactUsVC.h"
#import "KDSAboutCell.h"
#import "PLPAboutHeardView.h"

@interface PLPContactUsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) PLPAboutHeardView * headerView;
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation PLPContactUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationTitleLabel.text = @"联系我们";//Localized(@"aboutKaadas");
    self.tableView = [UITableView new];
    self.headerView.frame = CGRectMake(0, 0, KDSScreenWidth,365);
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.left.mas_equalTo(self.view.mas_left).offset(15);
        make.top.mas_equalTo(self.view.mas_top).offset(15);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
        
    }];
}

-(UITableViewStyle) tableViewStyle {
    if (@available(iOS 13.0, *)) {
        return UITableViewStyleInsetGrouped;
    } else {
        return UITableViewStyleGrouped;
    }
}

#pragma mark --UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseId = NSStringFromClass([self class]);
    KDSAboutCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell)
    {
        cell = [[KDSAboutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    cell.titleLabel.text = @"售后电话";
    cell.detail.text = @"400-8828-236";
    cell.detail.textColor = KDSRGBColor(51, 51, 51);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [UIView new];
    view.backgroundColor = UIColor.clearColor;
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *number = @"400-8828-236";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", number]];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma MARK -- Loard
- (PLPAboutHeardView *)headerView
{
    if (!_headerView) {
        _headerView = ({
            PLPAboutHeardView * hV = [PLPAboutHeardView new];
            hV.backgroundColor = [UIColor whiteColor];
            hV.logoImageView.image = [UIImage imageNamed:@"philips_mine_img_code"];
            hV.titleLb.text = @"欢迎使用飞利浦智能锁，门锁售后服务及资讯，请关注【飞利浦智能锁】公众号";
            hV;
        });
    }
    
    return _headerView;
}


@end
