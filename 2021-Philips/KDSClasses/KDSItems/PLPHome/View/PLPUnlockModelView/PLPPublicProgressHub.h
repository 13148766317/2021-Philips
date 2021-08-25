//
//  PLPPublicProgressHub.h
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/5/21.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PLPPublicProgressHubDelegate <NSObject>

-(void)publicProgressHubClick:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface PLPPublicProgressHub : UIView

@property(nonatomic, strong) id<PLPPublicProgressHubDelegate>publicProgressHubDelegate;

//顶部主标题
@property (nonatomic, strong) UILabel *titleLabel;

//顶部副标题
@property (nonatomic, strong) UILabel *subTitleLabel;

//左边操作按钮
@property (nonatomic, strong) UIButton *leftButton;

//右边操作按钮
@property (nonatomic, strong) UIButton *rightButton;

//初始化
-(instancetype) initWithFrame:(CGRect)frame InformationDic:(NSDictionary *)informatioDic;

//修改右Button背景色
-(void) setRightButtonColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
