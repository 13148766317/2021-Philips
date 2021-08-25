//
//  PLPLockMsgOneCell.m
//  2021-Philips
//
//  Created by zhaoxueping on 2021/5/10.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPLockMsgOneCell.h"
#import "KDSHttpManager+WifiLock.h"

@implementation PLPLockMsgOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame{
    //frame.origin.x +=10;
    frame.origin.y += 10;
    frame.size.height -= 10;
    //frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)setLock:(KDSLock *)lock
{
    _lock = lock;
    
    [[KDSHttpManager sharedManager] getWifiLockBindedDeviceOperationCountWithUid:[KDSUserManager sharedManager].user.uid wifiSN:self.lock.wifiDevice.wifiSN index:1 success:^(int count) {
        NSString *str1 = [NSString stringWithFormat:@"%@次",@(count).stringValue];
        NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc]initWithString:str1];
        NSRange range1 = [str1 rangeOfString:@"次"];
        //设置"天"之前文字的颜色
        [attributed addAttribute:NSForegroundColorAttributeName value:KDSRGBColor(0, 102, 161) range:NSMakeRange(0, range1.location)];
        //设置"天"之前文字的大小
        [attributed addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(0, range1.location)];
        self.msgCountLb.attributedText = attributed;
    } error:nil failure:nil];
    
    NSString *str1 = [NSString stringWithFormat:@"%@天",@(floor(([[NSDate date] timeIntervalSince1970] - self.lock.wifiDevice.createTime) / 24 / 3600)).stringValue];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc]initWithString:str1];
    NSRange range1 = [str1 rangeOfString:@"天"];
    //设置"天"之前文字的颜色
    [attributed addAttribute:NSForegroundColorAttributeName value:KDSRGBColor(0, 102, 161) range:NSMakeRange(0, range1.location)];
    //设置"天"之前文字的大小
    [attributed addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(0, range1.location)];
    self.addDevTimeLb.attributedText = attributed;
}


@end
