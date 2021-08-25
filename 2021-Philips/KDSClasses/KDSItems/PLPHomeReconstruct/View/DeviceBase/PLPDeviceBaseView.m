//
//  PLPDeviceBaseView.m
//  Pages
//
//  Created by Apple on 2021/5/19.
//

#import "PLPDeviceBaseView.h"

@implementation PLPDeviceBaseView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.labSubTitle.userInteractionEnabled = YES;
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick)];
        [self.labSubTitle addGestureRecognizer:labelTapGestureRecognizer];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

-(void) configure {
    
}

- (void)setDevice:(id<PLPDeviceProtocol>)device {
    _device = device;
    if (!device) {
        NSLog(@"error");
    }
}
-(void) updateUI {
    if (self.device) {
        /***************************显示锁图片时候赋值方式************************************/
        //[self.ivDevice setImage:[UIImage imageNamed:[self.device plpDeviceViewListImageName]]];
        /***********************************************************************************/
        self.ivDevice.image = [UIImage imageNamed:@"philips_home_icon_video_list-1"];//默认摄像头图标
        self.labName.text = [self.device
                             plpDeviceViewName];
        self.labSubTitle.text = [self.device plpDeviceViewSubTitle];
        
    }
}

/// 回调动作代理
/// @param actionType 动作类型
-(void) callbackActionDelegateWithActionType:(PLPDeviceUIActionType) actionType {
    if (self.actionDelegate && [self.actionDelegate conformsToProtocol:@protocol(PLPDeviceViewActionDelegateProtocol)]) {
        [self.actionDelegate deviceView:self actionType:actionType];
    }
}

#pragma mark ---点击事件
- (void)labelClick {
    NSLog(@"点击了lable");
}

@end
