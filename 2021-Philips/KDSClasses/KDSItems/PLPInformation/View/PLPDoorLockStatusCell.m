//
//  PLPDoorLockStatusCell.m
//  2021-Philips
//
//  Created by zhaoxueping on 2021/5/10.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPDoorLockStatusCell.h"
#import "PLPMSGTypeModel.h"

@interface PLPDoorLockStatusCell ()

///表明是消息类型的图标
@property (weak, nonatomic) IBOutlet UIImageView *msgTypeImgView;
///表明消息类型的内容
@property (weak, nonatomic) IBOutlet UILabel *msgTypeLb;
///表明消息条数
@property (weak, nonatomic) IBOutlet UILabel *msgCountLb;

@end

@implementation PLPDoorLockStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(id)model
{
    _model = model;
    if ([model isKindOfClass:PLPMSGTypeModel.class]) {
        
        PLPMSGTypeModel * tempModel = _model;
        self.msgCountLb.textColor = KDSRGBColor(51, 51, 51);
        self.msgCountLb.font = [UIFont systemFontOfSize:15];
        NSString *str1 = [NSString stringWithFormat:@"%d%@",tempModel.msgLockCount,@"条"];
        NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc]initWithString:str1];
        NSRange range1 = [str1 rangeOfString:@"条"];
        //设置"条"之前文字的颜色
        [attributed addAttribute:NSForegroundColorAttributeName value:KDSRGBColor(51, 51, 51) range:NSMakeRange(0, range1.location)];
        //设置"条"之前文字的大小
        [attributed addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:28] range:NSMakeRange(0, range1.location)];
        self.msgCountLb.attributedText = attributed;
        
        switch (tempModel.msgType) {
            case pwdOpenLock:
                self.msgTypeImgView.image = [UIImage imageNamed:@"philips_message_icon_password"];
                self.msgTypeLb.text = @"密码开门";
                break;
            case fingerprintOpenLock:
                self.msgTypeImgView.image = [UIImage imageNamed:@"philips_message_icon_fingerprint"];
                self.msgTypeLb.text = @"指纹开门";
                break;
            case cardOpenLock:
                self.msgTypeImgView.image = [UIImage imageNamed:@"philips_message_icon_card"];
                self.msgTypeLb.text = @"卡片开门";
                break;
            case faceOpenLock:
                self.msgTypeImgView.image = [UIImage imageNamed:@"philips_message_icon_visitors"];
                self.msgTypeLb.text = @"人脸开门";
                break;
            case doorbell:
                self.msgTypeImgView.image = [UIImage imageNamed:@"philips_message_icon_visitors"];
                self.msgTypeLb.text = @"访客记录";
                break;
            
                
            default:
                break;
        }
        
    }
}

@end
