//
//  PLPMineVC.m
//  2021-Philips
//
//  Created by Apple on 2021/5/6.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPMineVC.h"
#import "PLPFormUtils.h"
#import "PLPMsgHeaderView.h"
#import "KDSUserCenterVC.h"
#import "KDSDBManager.h"
#import "KDSHttpManager+User.h"
#import "PLPSecuritySettingVC.h"
#import "PLPAboutVC.h"
#import "PLPContactUsVC.h"
#import "KDSUserFeedbackVC.h"
#import "KDSFAQViewController.h"
#import "MineCell.h"
//#import "KDSFAQ2ViewController.h"  //[@"门锁问题",@"晾衣机问题"]

@interface PLPMineVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)PLPMsgHeaderView * heardView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray * titleArr;
@property(nonatomic,strong)NSArray * titleImgArr;

@end

@implementation PLPMineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.right.bottom.equalTo(self.view);
    }];
    self.tableView.backgroundColor = [PLPFormUtils tableViewBackgroudColor];
    self.heardView.frame = CGRectMake(0, 0, 0, 140+kStatusBarHeight);
    self.tableView.tableHeaderView = self.heardView;
    self.titleArr = @[@"系统设置",@"常见问题",@"用户反馈",@"关于我们"];
    self.titleImgArr = @[@"philips_mine_icon_setting",@"philips_mine_icon_problem",@"philips_mine_icon_feedback",@"philips_mine_icon_about"];
    [self getUserNickname];
    [self getUserAvatar];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ///设置头像--昵称
    KDSUserManager *userMgr = [KDSUserManager sharedManager];
    userMgr.userNickname = [[KDSDBManager sharedManager] queryUserNickname];
    NSString * tempStr = userMgr.userNickname ?: userMgr.user.name;
    if (tempStr.length > 10) {
       tempStr  =  [NSString stringWithFormat:@"%@...",[tempStr substringToIndex:10]];
    }
    self.heardView.nickNameLabel.text  = tempStr;
    NSString *account = userMgr.user.name;
    BOOL isMail = [KDSTool isValidateEmail:account];
    NSString  * repStr = isMail ? account : [account stringByReplacingCharactersInRange:NSMakeRange(0, KDSTool.crc.length) withString:@""];
    account =  [repStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.heardView.accountLabel.text = [NSString stringWithFormat:@"%@%@",Localized(@"accountNumber"),account];
    KDSDBManager *dbMgr = [KDSDBManager sharedManager];
    NSData *imgData = [dbMgr queryUserAvatarData];
    if (!imgData) [self getUserAvatar];
    UIImage *img = imgData ? [[UIImage alloc] initWithData:imgData] : [UIImage imageNamed:@"philips_mine_img_profile"];
    self.heardView.heardImageView.image = img;
}

//获取用户昵称，刷新界面和更新数据库。
- (void) getUserNickname
{
    KDSUserManager *userMgr = [KDSUserManager sharedManager];
    KDSDBManager *dbMgr = [KDSDBManager sharedManager];
    NSString *account = userMgr.user.name;
    BOOL isMail = [KDSTool isValidateEmail:account];
    NSString  * repStr = isMail ? account : [account stringByReplacingCharactersInRange:NSMakeRange(0, KDSTool.crc.length) withString:@""];
    account =  [repStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    [[KDSHttpManager sharedManager] getUserNicknameWithUid:userMgr.user.uid success:^(NSString * _Nullable nickname) {
        NSString * tempStr = nickname;
        if (nickname.length > 10) {
            tempStr = [NSString stringWithFormat:@"%@...",[nickname substringToIndex:10]];
        }
        !nickname ?: (void)((void)(self.heardView.nickNameLabel.text = tempStr), [dbMgr updateUserNickname:nickname]);
        self.heardView.accountLabel.text =[[NSString alloc]initWithFormat:@"%@%@",Localized(@"accountNumber"),account];
    } error:nil failure:nil];
}


//获取用户头像，刷新界面和更新数据库。
- (void) getUserAvatar
{
    KDSUserManager *userMgr = [KDSUserManager sharedManager];
    KDSDBManager *dbMgr = [KDSDBManager sharedManager];
    [[KDSHttpManager sharedManager] getUserAvatarImageWithUid:userMgr.user.uid success:^(UIImage * _Nullable image) {
        if (image)
        {
            self.heardView.heardImageView.image = image;
            CGImageAlphaInfo info = CGImageGetAlphaInfo(image.CGImage);
            if (info==kCGImageAlphaNone || info==kCGImageAlphaNoneSkipLast || info==kCGImageAlphaNoneSkipFirst)
            {
                [dbMgr updateUserAvatarData:UIImageJPEGRepresentation(image, 1.0)];
            }
            else
            {
                [dbMgr updateUserAvatarData:UIImagePNGRepresentation(image)];
            }
        }
    } error:nil failure:nil];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }if (section == 1) {
        return 1;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0)
    {
        cell.iconeImageView.image = [UIImage imageNamed:self.titleImgArr[indexPath.row]];
        cell.titleNameLabel.text = self.titleArr[indexPath.row];
    }
    if (indexPath.section == 1) {
        cell.iconeImageView.image =[UIImage imageNamed:@"philips_mine_icon_contact"];
        cell.titleNameLabel.text = @"联系我们";
       
    }
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0://系统设置
            {
                PLPSecuritySettingVC * securitySettingVC = [PLPSecuritySettingVC new];
                securitySettingVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:securitySettingVC animated:YES];
            }
                break;
            case 1://常见问题
            {
                KDSFAQViewController * faqVC = [KDSFAQViewController new];
                faqVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:faqVC animated:YES];
            }
                break;
            case 2://用户反馈
            {
                KDSUserFeedbackVC * userFeedbackVC = [KDSUserFeedbackVC new];
                userFeedbackVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:userFeedbackVC animated:YES];
            }
                break;
            case 3://关于我们
            {
                PLPAboutVC *vc = [[PLPAboutVC alloc] init];
                vc.title = @"关于我们";
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
    }if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            PLPContactUsVC *vc = [[PLPContactUsVC alloc] init];
            vc.title = @"联系我们";
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }

    
}

#pragma mark Lazy load

-(PLPMsgHeaderView *)heardView
{
    if (!_heardView) {
        
        _heardView = ({
             __weak typeof(self) weakSelf = self;
            PLPMsgHeaderView * h = [PLPMsgHeaderView new];
            h.backgroundColor = [UIColor whiteColor];
            h.block = ^(id _Nonnull param) {
                NSLog(@"点击了头像");
                
                KDSUserCenterVC * userCenterVC = [KDSUserCenterVC new];
                userCenterVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:userCenterVC animated:YES];
            };
            h;
        });
    }
    
    return _heardView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = ({
            UITableView * b = [UITableView new];
            b.backgroundColor = UIColor.clearColor;
            b.showsVerticalScrollIndicator = NO;
            b.showsHorizontalScrollIndicator = NO;
            b.delegate = self;
            b.dataSource = self;
            b.rowHeight = 56;
            b.separatorStyle = UITableViewCellSeparatorStyleNone;
            [b registerNib:[UINib nibWithNibName:@"MineCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MineCell"];
            b;
        });
    }
    return _tableView;
}

@end
