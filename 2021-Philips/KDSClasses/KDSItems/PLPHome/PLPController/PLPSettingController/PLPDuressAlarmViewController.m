//
//  PLPDuressAlarmViewController.m
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/5/12.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPDuressAlarmViewController.h"
#import "PLPDuressAlarmCell.h"
#import "PLPDuressPasswordViewController.h"

@interface PLPDuressAlarmViewController ()<UITableViewDelegate,UITableViewDataSource>

//开锁方式主UITableView
@property (nonatomic, strong) UITableView *tableView;

//数据源
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation PLPDuressAlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化主视图
    [self setupMainView];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

#pragma mark - 初始化主界面
-(void) setupMainView{
    
    self.navigationTitleLabel.text = @"胁迫报警";
    self.view.backgroundColor = KDSRGBColor(248, 248, 248);
    
    //初始化UITableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, kScreenWidth, kScreenHeight-15) style:UITableViewStylePlain];
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
    
    return 65;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"PLPDuressAlarmCell";
    PLPDuressAlarmCell *cell = (PLPDuressAlarmCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"PLPDuressAlarmCell" owner:nil options:nil];
        cell = [nibArr objectAtIndex:0];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    cell.markImageView.hidden = YES;
    [cell.alarmSwitch addTarget:self action:@selector(duressAlarmSwitch:) forControlEvents:UIControlEventValueChanged];
    cell.titleLabel.text = self.dataArr[indexPath.row];
    cell.subtitleLabel.text = @"开启后，输入指纹APP实时接收报警信息";
    
    return cell;
}

#pragma mark - UITableView 点击代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PLPDuressPasswordViewController *passwordVC = [PLPDuressPasswordViewController new];
    self.lock = passwordVC.lock;
    [self.navigationController pushViewController:passwordVC animated:YES];
}

#pragma mark - 胁迫密码开关
-(void) duressAlarmSwitch:(UISwitch *)btn{
    
    
}

#pragma mark - 懒加载

-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@"胁迫报警"];
    }
    
    return _dataArr;
}


@end
