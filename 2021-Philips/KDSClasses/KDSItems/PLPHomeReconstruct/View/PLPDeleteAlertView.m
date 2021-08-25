//
//  PLPDeleteAlertView.m
//  2021-Philips
//
//  Created by Apple on 2021/6/28.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPDeleteAlertView.h"
#import "PLPProgressHub.h"
@interface PLPDeleteAlertView() <PLPProgressHubDelegate>

//蒙板
@property (nonatomic, strong) UIView *maskView;
//提示框
@property (nonatomic, strong) PLPProgressHub *progressHub;
@property(nonatomic, assign) BOOL isConfirmed;
@end

@implementation PLPDeleteAlertView


#pragma mark -PLPProgressHubDelegate(弹窗)
-(void) informationBtnClick:(NSInteger)index{
    
    switch (index) {
        case 10://取消
        {
            [self dismissContactView];
            self.isConfirmed =NO;
            
            break;
        }
        case 11://删除
        {
            //[self deleteBindedDevice];
            self.isConfirmed = YES;
            [self dismissContactView];
            
            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - PLPProgressHub显示视图
-(void)show{
    
    [_maskView removeFromSuperview];
    [_progressHub removeFromSuperview];
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _maskView.alpha = 0.5;
    _maskView.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    
    _progressHub = [[PLPProgressHub alloc] initWithFrame:CGRectMake(50, kScreenHeight/2 - 150/2, kScreenWidth-100, 150) Title:@"确定删除设备吗？"];
    _progressHub.backgroundColor = [UIColor whiteColor];
    _progressHub.progressHubDelegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_progressHub];
}

#pragma mark - PLPProgressHub删除视图
-(void)dismissContactView
{
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf.maskView removeFromSuperview];
        [weakSelf.progressHub removeFromSuperview];
        
        if (weakSelf.confirmedBlock) {
            weakSelf.confirmedBlock(weakSelf.isConfirmed);
        }
    }];
}
@end
