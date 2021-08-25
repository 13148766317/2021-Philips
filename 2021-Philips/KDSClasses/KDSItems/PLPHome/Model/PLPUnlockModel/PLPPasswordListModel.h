//
//  PLPPasswordListModel.h
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/5/13.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PLPPasswordListModel : NSObject

//密码名称
@property (nonatomic, strong) NSString *passwordNickName;

//密码创建时间
@property (nonatomic, assign) NSTimeInterval passwordcreateTime;

//密码类型
@property (nonatomic, assign) NSInteger passwordType;

//密码编号
@property (nonatomic, strong) NSString *passwordNum;

//是否被选中状态
@property (nonatomic, assign) BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
