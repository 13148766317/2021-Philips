//
//  PLPDeviceBaseCell.m
//  Pages
//
//  Created by Apple on 2021/5/19.
//

#import "PLPDeviceBaseCell.h"

@implementation PLPDeviceBaseCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configure];
}

-(void) configure {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDevice:(id)device {
    _device = device;
    self.deviceView.device = device;
}

-(void) updateUI {
    [self.deviceView updateUI];
}
@end
