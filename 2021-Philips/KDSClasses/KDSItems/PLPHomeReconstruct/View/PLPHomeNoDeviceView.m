//
//  PLPHomeNoDeviceView.m
//  2021-Philips
//
//  Created by Apple on 2021/5/31.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPHomeNoDeviceView.h"

@import Masonry;

@interface PLPHomeNoDeviceView()
@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation PLPHomeNoDeviceView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self configure];
//    }
//    return self;
//}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

-(void) configure {
    NSString *nibNamed = @"PLPHomeNoDeviceView";
    
    [[NSBundle mainBundle] loadNibNamed:nibNamed owner:self options:nil];
    __weak __typeof(self)weakSelf = self;
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(weakSelf);

    }];
    self.btnAddDevice.layer.cornerRadius = 3.0;
}

-(IBAction)btnAddDeviceAction:(id)sender {
    if (self.addDeviceBlock) {
        self.addDeviceBlock();
    }
}

@end
