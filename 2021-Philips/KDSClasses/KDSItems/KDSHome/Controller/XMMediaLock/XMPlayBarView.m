//
//  XMPlayBarView.m
//  XMDemo
//
//  Created by xunmei on 2020/9/1.
//  Copyright © 2020 TixXie. All rights reserved.
//

#import "XMPlayBarView.h"

//语音对讲声波动画
#import "CYActivityIndicatorView.h"

@interface XMPlayBarView ()
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) NSMutableArray<UIButton *> * funSetBtns;

//语音对讲声波动画
@property (nonatomic, strong) CYActivityIndicatorView *activityIndicatorView;

@end

@implementation XMPlayBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
//    if (@available(iOS 13.0, *)) {
//        UIUserInterfaceStyle mode = UITraitCollection.currentTraitCollection.userInterfaceStyle;
//        if (mode == UIUserInterfaceStyleDark) {
//            self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
//        } else if (mode == UIUserInterfaceStyleLight) {
//            self.backgroundColor = [UIColor darkGrayColor];
//        }
//    } else {
//        self.backgroundColor = [UIColor lightGrayColor];
//    }
    [self addSubview:self.stackView];
    
    NSArray *normalImageNames = @[@"philips_video_icon_mute_01",@"philips_video_icon_album",@"philips_video_icon_voice_01",@"philips_video_icon_screenshot",@"philips_video_icon_rec_01"];
    
    NSArray *selectedImageNames = @[@"philips_video_icon_mute_02",@"philips_video_icon_album",@"philips_video_icon_voice_02",@"philips_video_icon_screenshot",@"philips_video_icon_rec_02"];
    
    NSArray *buttonTitles = @[Localized(@"RealTimeVideo_Mute"),Localized(@"RealTimeVideo_Album"),Localized(@"RealTimeVideo_Talk"),Localized(@"RealTimeVideo_TakePhone"),Localized(@"RealTimeVideo_TakeVideo")];
    for (int i = 0; i < normalImageNames.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        CGFloat btnWidth = KDSScreenWidth/5;
        if (i != 2) {
            [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
            button.frame = CGRectMake(i*btnWidth, 20, btnWidth, 67);
            [button setImage:[UIImage imageNamed:normalImageNames[i]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:selectedImageNames[i]] forState:UIControlStateSelected];
        }else{
            
            // self.voiceSmallBtn 标记，对讲文字显示button
            self.voiceSmallBtn= [UIButton buttonWithType:UIButtonTypeCustom];
            self.voiceSmallBtn.frame = CGRectMake(i*btnWidth, 56, btnWidth, 15);
            [self.voiceSmallBtn setTitle:Localized(@"RealTimeVideo_Talk") forState:UIControlStateNormal];
            [self.voiceSmallBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            [self.voiceSmallBtn setTitle:Localized(@"RealTimeVideo_Taking") forState:UIControlStateSelected];
            [self.voiceSmallBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
            self.voiceSmallBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            self.voiceSmallBtn.selected = NO;
            [self addSubview:self.voiceSmallBtn];
            
            button.frame = CGRectMake(i*btnWidth  + (btnWidth - 45)/2, 5, 45, 45);
            [button setImage:[UIImage imageNamed:@"philips_video_icon_voice_01"] forState:UIControlStateNormal];
            
            //将语音对讲声波动画加载到图标上
            self.activityIndicatorView.hidden = YES;
            [button addSubview:self.activityIndicatorView];
            [self.activityIndicatorView stopAnimating];
            
            UITapGestureRecognizer *clickRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRecognizer:)];
            [self.activityIndicatorView addGestureRecognizer:clickRecognizer];
        }
        
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        if (i != 2) {
            CGFloat    space = 5;// 图片和文字的间距
            CGFloat    imageHeight = button.currentImage.size.height;
            CGFloat    imageWidth = button.currentImage.size.width;
            
            CGFloat    titleHeight = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}].height;
            CGFloat    titleWidth = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}].width;
            
            [button setImageEdgeInsets:UIEdgeInsetsMake(-(imageHeight*0.5 + space*0.5), titleWidth*0.5, imageHeight*0.5 + space*0.5, -titleWidth*0.5)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(titleHeight*0.5 + space*0.5, -imageWidth*0.5, -(titleHeight*0.5 + space*0.5), imageWidth*0.5)];
        }
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:button];
        [self.funSetBtns addObject:button];
        [self bringSubviewToFront:self.voiceSmallBtn];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat margin = 16.0;
    CGSize size = self.bounds.size;
    self.stackView.frame = CGRectMake(margin, 0, size.width - margin * 2, size.height);
    
}

- (void)setPlayBarViewButtonType:(XMPlayBarViewButtonType)type enabled:(BOOL)enabled {
    for (UIButton *button in self.funSetBtns) {
        if (button.tag == type) {
            button.enabled = enabled;
            break;
        }
    }
}

- (void)setPlayBarViewButtonType:(XMPlayBarViewButtonType)type state:(XMPlayBarViewButtonState)state {
    for (UIButton * btn in self.funSetBtns) {
        if (btn.tag == type) {
            if (state == XMPlayBarViewButtonStateSelected) {
                
                if (type == XMPlayBarViewButtonTypeTalk) {
                    
                    //视图动画加载
                    self.activityIndicatorView.hidden = NO;
                    [self.activityIndicatorView startAnimating];
                    
                    //将图片置为nil
                    [btn setImage:nil forState:UIControlStateNormal];
                }
                
                btn.selected = true;
            } else {
                
                if (type == XMPlayBarViewButtonTypeTalk) {
                    
                    self.activityIndicatorView.hidden = YES;
                    [self.activityIndicatorView stopAnimating];
                    
                    //将图片加载出来
                    [btn setImage:[UIImage imageNamed:@"philips_video_icon_voice_01"] forState:UIControlStateNormal];
                }
                
                btn.selected = false;
            }
            break;
        }
    }
}

- (void)buttonClicked:(UIButton *)button {
    if (button.tag == 2) {
        if (button.selected == YES) {
            self.voiceSmallBtn.selected = NO;
        }else{
            self.voiceSmallBtn.selected = YES;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(XMPlayBarView:buttonClicked:type:)]) {
        [self.delegate XMPlayBarView:self buttonClicked:button type:button.tag];
    }
}

#pragma mark - 语音动画手势相应事件
-(void) clickRecognizer:(UITapGestureRecognizer *)tap{
    
    UIButton *btn = (UIButton *)[self viewWithTag:2];
    [self buttonClicked:btn];
}

#pragma mark - 懒加载

- (UIStackView *)stackView {
    if (_stackView == nil) {
        _stackView = [UIStackView new];
        self.stackView.spacing = 0;
        self.stackView.axis = UILayoutConstraintAxisHorizontal;
        self.stackView.alignment = UIStackViewAlignmentCenter;
        self.stackView.distribution = UIStackViewDistributionEqualCentering;
    }
    return _stackView;
}

- (NSMutableArray<UIButton *> *)funSetBtns
{
    if (!_funSetBtns) {
        _funSetBtns = [NSMutableArray array];
    }
    return _funSetBtns;
}

-(CYActivityIndicatorView *)activityIndicatorView{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[CYActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 45, 45) type:CYActivityIndicatorTypeLineScalePulseOut color:[UIColor whiteColor]];
    }
    
    return _activityIndicatorView;
}

@end
