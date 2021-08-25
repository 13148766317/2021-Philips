//
//  PLPUnlockModelViewController.m
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/4/28.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPUnlockModelViewController.h"
#import "PLPUnlockModelCell.h"
#import "PLPPermanentPasswordViewController.h"
#import "KDSWifiLockPwdShareVC.h"
#import "KDSHttpManager+WifiLock.h"

@interface PLPUnlockModelViewController ()<UITableViewDelegate,UITableViewDataSource>

//开锁方式主UITableView
@property (nonatomic, strong) UITableView *tableView;

//标题数组
@property (nonatomic, strong) NSArray *titleArr;

@end

@implementation PLPUnlockModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化主视图
    [self setupMainView];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

#pragma mark - 初始化主视图
- (void) setupMainView{
    
    self.navigationTitleLabel.text = Localized(@"UnlockModel_HeadTitle");
    
    //初始化UITableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, kScreenWidth, kScreenHeight-15) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = KDSRGBColor(248, 248, 248);
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.01;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    
    return self.titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.titleArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"PLPUnlockModelCell";
    PLPUnlockModelCell *cell = (PLPUnlockModelCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"PLPUnlockModelCell" owner:nil options:nil];
        cell = [nibArr objectAtIndex:0];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    cell.headTitleLabel.text = [self.titleArr[indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableView 点击代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        //临时密码
        KDSWifiLockPwdShareVC * vc = [KDSWifiLockPwdShareVC new];
        vc.lock = self.lock;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        PLPPermanentPasswordViewController * permanentPasswordVC = [PLPPermanentPasswordViewController new];
        if (indexPath.row == 0) {
            permanentPasswordVC.keyType = KDSBleKeyTypePIN;//密码
        }else if (indexPath.row == 1){
            permanentPasswordVC.keyType = KDSBleKeyTypeFingerprint;//指纹
        }else{
            permanentPasswordVC.keyType = KDSBleKeyTypeRFID;//卡片
        }
        permanentPasswordVC.lock = self.lock;
        [self.navigationController pushViewController:permanentPasswordVC animated:YES];
    }
}

#pragma mark - 懒加载

-(NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[@[Localized(@"MessageRecord_Password"),Localized(@"MessageRecord_Fingerprint"),Localized(@"MessageRecord_Card")],@[Localized(@"UnlockModel_Temporary_Pwd")]];
    }
    
    return _titleArr;
}

@end
