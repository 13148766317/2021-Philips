//
//  PLPProductListManager.h
//  2021-Philips
//
//  Created by Apple on 2021/5/13.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PLPProductInfo.h"
NS_ASSUME_NONNULL_BEGIN




@interface PLPProductListManager : NSObject

+ (instancetype)sharedInstance;

//产品类别与标题
+ (NSDictionary<NSNumber *,NSString *> *) categoryTitles;

//产品类别与标题
+ (NSArray<NSString*> *) titlesForCategorys:(NSArray <NSNumber *>*) categorys;

//todo 优化到同步/加载分类去实现
//从服务器请求产品列表
-(void) requestProductList;

//关键字查找指定类别产品列表
-(NSArray <PLPProductInfo *> *) searchProductList:(PLPProductCategory ) category keyword:(NSString * _Nullable) keyword;

//指定类别产品列表
-(NSArray <PLPProductInfo *> *) searchProductList:(PLPProductCategory ) category;

//产品信息
-(PLPProductInfo *) productInfoWithPid:(NSString *) pid;

//产品所有类别
-(NSArray <NSNumber *> *) productCategorys;

@end

NS_ASSUME_NONNULL_END
