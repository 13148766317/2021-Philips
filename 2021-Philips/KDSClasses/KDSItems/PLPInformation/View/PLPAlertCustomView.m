//
//  PLPAlertCustomView.m
//  2021-Philips
//
//  Created by zhaoxueping on 2021/5/20.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPAlertCustomView.h"

@interface PLPAlertCustomView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIWindow *contentView;
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation PLPAlertCustomView

- (instancetype)init
{
    if (self = [super init]) {
        self.type = NKAlertViewTypeBottom;
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.alpha = 0;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [self setContentView:self.contentView];
    }
    return self;
}

- (void)show
{
    if (self.type == NKAlertViewTypeBottom) {
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 1.0;
            self.contentView.transform = CGAffineTransformMakeTranslation(0, -self.contentView.bounds.size.height);
        } completion:nil];
    }else
    {
        self.alpha = 1.0;
        CAKeyframeAnimation * animation;
        animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.duration = 0.30;
        animation.removedOnCompletion = YES;
        animation.fillMode = kCAFillModeForwards;
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        animation.values = values;
        [_contentView.layer addAnimation:animation forKey:nil];
    }
}

- (void)hide
{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
        self.contentView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - set
- (void)setType:(NKAlertViewType)type
{
    _type = type;
    if (self.contentView && _type == NKAlertViewTypeBottom) {
        _contentView.frame = CGRectMake((CGRectGetMaxX(self.frame) - CGRectGetWidth(_contentView.frame)) * 0.5, CGRectGetMaxY(self.frame), CGRectGetWidth(_contentView.frame), CGRectGetHeight(_contentView.frame));
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = _contentView.bounds;
        shapeLayer.path = path.CGPath;
        _contentView.layer.mask = shapeLayer;
    }
}

- (void)setContentView:(UIWindow *)contentView
{
    _contentView = contentView;
    if (self.type == NKAlertViewTypeBottom) {
        _contentView.frame = CGRectMake((CGRectGetMaxX(self.frame) - CGRectGetWidth(_contentView.frame)) * 0.5, CGRectGetMaxY(self.frame), CGRectGetWidth(_contentView.frame), CGRectGetHeight(_contentView.frame));
        /*
         利用贝塞尔曲线为contentView的左上角、右上角设置圆角；
         如果不需要可以注释下边代码
         */
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = _contentView.bounds;
        shapeLayer.path = path.CGPath;
        _contentView.layer.mask = shapeLayer;
        [self layoutAllSubviews];
    }else
    {
        _contentView.frame = CGRectMake(0, 0, KDSScreenWidth, KDSScreenHeight);
    }
    [self addSubview:_contentView];
}


- (void)layoutAllSubviews{
        
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, kNavBarHeight+kStatusBarHeight, KDSScreenWidth-40, 220) style:UITableViewStylePlain];
    self.tableView.rowHeight = 60;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.layer.cornerRadius = 5;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.tableView];
    
    UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setImage:[UIImage imageNamed:@"philips_message_icon_close"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancleBtn];
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40);
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-kBottomSafeHeight);
    }];
    
}

- (void)cancleBtnClick:(UIButton *)sender
{
    [self hide];
}

#pragma mark --UITabbleviewDelegate 代理


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.devArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseId = NSStringFromClass([self class]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseId];
    }
    KDSLock * lock = self.devArr[indexPath.row];
    cell.textLabel.text = lock.wifiDevice.lockNickname ?: lock.wifiDevice.wifiSN;
    cell.textLabel.textColor = UIColor.blackColor;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell= [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"-----%@------",cell.textLabel.text);
    self.currentDevString = cell.textLabel.text;
    KDSLock * lock = self.devArr[indexPath.row];
    self.cellClickBlock(lock);
    [self hide];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KDSScreenWidth, 60)];
    headerView.backgroundColor = UIColor.whiteColor;
    headerView.userInteractionEnabled = YES;
    ///显示设备标题的lb：智能锁
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 200, 30)];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    titleLabel.text = @"智能锁";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = KDSRGBColor(51, 51, 51);
    titleLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:titleLabel];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 50;
}



@end
