//
//  KDSHttpManager+Product.m
//  2021-Philips
//
//  Created by Apple on 2021/5/13.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "KDSHttpManager+Product.h"

@implementation KDSHttpManager (Product)
/**
 *@abstract 获取所有型号图片列表

 *@param success 请求成功执行的回调。
 *@param errorBlock 出错执行的回调，参数error的code是服务器返回的code，domain是服务器返回的msg。
 *@param failure 由于数据解析及网络等原因失败的回调，error是系统传递过来的。
 *@return 当前的请求任务。
 */
- (NSURLSessionDataTask *)getProductionListSuccess:(void (^)(NSArray <PLPProductInfo *> *productList))success error:(void (^)(NSError * _Nonnull))errorBlock  failure:(void (^)(NSError * _Nonnull))failure {
    return [self POST:@"production/model/list" parameters:@{} success:^(id  _Nullable responseObject) {
        NSMutableArray *productList = nil;
        if (responseObject && [responseObject isKindOfClass:[NSArray class]] ) {
            productList = [[NSMutableArray alloc] init];
            NSArray *responseObjectArray = (NSArray *) responseObject;
            for (NSUInteger i=0; i<responseObjectArray.count; i++) {
                [productList addObject:[[PLPProductInfo alloc] initWithDictionary:responseObjectArray[i]]];
            }
        }
        !success ?: success(productList);
    } error:errorBlock failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failure ?: failure(error);
    }];
}
@end
