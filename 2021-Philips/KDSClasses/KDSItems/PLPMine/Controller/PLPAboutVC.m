//
//  PLPAboutVC.m
//  2021-Philips
//
//  Created by Apple on 2021/5/7.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPAboutVC.h"
#import "PLPAboutHeardView.h"
#import "KDSPrivacyPolicyVC.h"
#import "KDSUserAgreementVC.h"

@interface PLPAboutVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic, strong) PLPAboutHeardView * headerView;
@property (nonatomic, strong) NSArray * titleStrArr;

@end

@implementation PLPAboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationTitleLabel.text = Localized(@"aboutKaadas");
    self.titleStrArr = @[@"版本号 1.0.0",@"https://www.philips.com.cn/",@"使用条款",@"隐私政策"];
    self.tableView = [UITableView new];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
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
    return self.titleStrArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"版本号", nil),[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
        cell.textLabel.textColor = KDSRGBColor(51, 51, 51);
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        cell.accessoryType=UITableViewCellAccessoryNone;
    }else{
        cell.textLabel.text = self.titleStrArr[indexPath.row];
        cell.textLabel.textColor = KDSRGBColor(0, 102, 161);
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        NSURL *url = [NSURL URLWithString:[@"http://" stringByAppendingString:@"https://www.philips.com.cn/"]];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
    }else if (indexPath.row == 2){
        ///使用条款
        KDSUserAgreementVC *vc = [KDSUserAgreementVC new];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 3){
        ///隐私政策
        KDSPrivacyPolicyVC * vc = [KDSPrivacyPolicyVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma MARK -- Loard
- (PLPAboutHeardView *)headerView
{
    if (!_headerView) {
        _headerView = ({
            PLPAboutHeardView * hV = [[PLPAboutHeardView alloc] initWithFrame:CGRectMake(0, 0, KDSScreenWidth,270)];
            hV.backgroundColor = [UIColor whiteColor];
            hV.logoImageView.image = [UIImage imageNamed:@"philips_Mine_logo"];
            hV.titleLb.text = @"Philips EasyKey+";
            hV.titleLb.textAlignment = NSTextAlignmentCenter;
            hV.titleLb.font = [UIFont systemFontOfSize:18];
            hV.titleLb.textColor = UIColor.blackColor;
            [hV.logoImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@50);
                make.height.equalTo(@64);
            }];
            [hV.titleLb mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(hV.logoImageView.mas_bottom).offset(60);
            }];
            
            hV;
        });
    }
    
    return _headerView;
}


@end
