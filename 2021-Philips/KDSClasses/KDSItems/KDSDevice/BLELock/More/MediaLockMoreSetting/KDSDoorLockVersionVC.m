//
//  KDSDoorLockVersionVC.m
//  2021-Philips
//
//  Created by zhaoxueping on 2020/9/17.
//  Copyright © 2020 com.Kaadas. All rights reserved.
//

#import "KDSDoorLockVersionVC.h"
#import "MBProgressHUD+MJ.h"
#import "KDSLockMoreSettingCell.h"
#import "KDSAllPhotoShowImgModel.h"

@interface KDSDoorLockVersionVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) NSArray *titles;
@end

@implementation KDSDoorLockVersionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationTitleLabel.text = @"门锁版本";
    self.tableView.rowHeight = 60;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.titles = @[@"固件版本",@"硬件版本"];
    self.titles = @[@"固件版本"];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseId = NSStringFromClass([self class]);
    KDSLockMoreSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell)
    {
        cell = [[KDSLockMoreSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    NSArray * detailTitles = @[self.lock.wifiDevice.lockFirmwareVersion ?: @"",self.lock.wifiDevice.wifiVersion ?: @""];
    cell.title = self.titles[indexPath.row];
    cell.subtitle = detailTitles[indexPath.row];
    cell.hideSeparator = indexPath.row == self.titles.count - 1;
    cell.clipsToBounds = YES;
    cell.hideSwitch = YES;
    cell.hideArrow = YES;
     
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        //门锁版本
    }else if (indexPath.row == 3){
        //摄像头版本
    }
}

@end
