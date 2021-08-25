//
//  PLPProgressHub.h
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/4/29.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PLPProgressHubDelegate <NSObject>

//取消，删除点击事件
-(void) informationBtnClick:(NSInteger) index;

@end

@interface PLPProgressHub : UIView

//声明代理
@property (nonatomic, weak)id<PLPProgressHubDelegate>progressHubDelegate;

//是否删除提示语
@property (nonatomic, strong) UILabel *midleTitleLabel;


-(instancetype) initWithFrame:(CGRect)frame Title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
