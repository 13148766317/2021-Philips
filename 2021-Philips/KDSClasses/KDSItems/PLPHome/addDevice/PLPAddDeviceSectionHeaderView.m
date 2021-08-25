//
//  PLPAddDeviceSectionHeaderView.m
//  2021-Philips
//
//  Created by Apple on 2021/5/14.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPAddDeviceSectionHeaderView.h"

@interface PLPAddDeviceSectionHeaderView ()

@property (strong, nonatomic) IBOutlet UIView *subContentView;

@end
@implementation PLPAddDeviceSectionHeaderView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"PLPAddDeviceSectionHeaderView" owner:self options:nil];
        
        [self addSubview:self.subContentView];
        
        self.subContentView.frame = self.bounds;
        
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"PLPAddDeviceSectionHeaderView" owner:self options:nil];
        
        [self addSubview:self.subContentView];
        
        self.subContentView.frame = self.bounds;
    
    }
    
    return self;
}

@end
