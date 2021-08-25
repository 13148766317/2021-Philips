//
//  PLPProductionManager.m
//  2021-Philips
//
//  Created by Apple on 2021/5/13.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//
#import "KDSHttpManager+Product.h"

#import "PLPProductListManager.h"

@interface PLPProductListManager ()
//保存产品列表
@property (nonatomic, strong) NSMutableArray <PLPProductInfo *>*productList;
//加载本地数据开关
@property (nonatomic, assign) BOOL enableLocalData;
@end

@implementation PLPProductListManager


+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static PLPProductListManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[PLPProductListManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.enableLocalData = YES;
        [self loadLocalData];
    }
    return self;
}

- (NSMutableArray<PLPProductInfo *> *)productList {
    if (!_productList) {
        self.productList = [[NSMutableArray alloc] init];
    }
    return _productList;
}

//加载本地数据

-(void) loadLocalData {
    if (self.enableLocalData) {
        PLPProductInfo *productInfo1 = [[PLPProductInfo alloc] initWithDictionary:@{@"_id":@"1",@"developmentModel": @"DDL708V-5HW",@"productModel":@"k1001",@"deviceListUrl":@"philips_home_scan_img_lock"}];
        PLPProductInfo *productInfo2 = [[PLPProductInfo alloc] initWithDictionary:@{@"_id":@"2",@"developmentModel": @"DDL708VP-5HW",@"productModel":@"k1001",@"deviceListUrl":@"philips_home_scan_img_lock"}];
        PLPProductInfo *productInfo3 = [[PLPProductInfo alloc] initWithDictionary:@{@"_id":@"3",@"developmentModel": @"DDL7085HW",@"productModel":@"k1001",@"deviceListUrl":@"philips_home_scan_img_lock"}];
        PLPProductInfo *productInfo4 = [[PLPProductInfo alloc] initWithDictionary:@{@"_id":@"4",@"developmentModel": @"DDL708V-8HW",@"productModel":@"k1001",@"deviceListUrl":@"philips_home_scan_img_lock"}];
        PLPProductInfo *productInfo5 = [[PLPProductInfo alloc] initWithDictionary:@{@"_id":@"5",@"developmentModel": @"DDL708VP-8HW",@"productModel":@"k1001",@"deviceListUrl":@"philips_home_scan_img_lock"}];
        PLPProductInfo *productInfo6 = [[PLPProductInfo alloc] initWithDictionary:@{@"_id":@"6",@"developmentModel": @"DDL7088HW",@"productModel":@"k1001",@"deviceListUrl":@"philips_home_scan_img_lock"}];
        
        //PLPProductInfo *productInfo2 = [[PLPProductInfo alloc] initWithDictionary:@{@"_id":@"2",@"developmentModel": @"k20",@"productModel":@"k20"}];
        //PLPProductInfo *productInfo3 = [[PLPProductInfo alloc] initWithDictionary:@{@"_id":@"3",@"developmentModel": @"k30",@"productModel":@"k30"}];
        //PLPProductInfo *productInfo4 = [[PLPProductInfo alloc] initWithDictionary:@{@"_id":@"4",@"developmentModel": @"k40",@"productModel":@"k30"}];
        //PLPProductInfo *productInfo5 = [[PLPProductInfo alloc] initWithDictionary:@{@"_id":@"5",@"developmentModel": @"测试k40",@"productModel":@"k30"}];
        //PLPProductInfo *productInfo6 = [[PLPProductInfo alloc] initWithDictionary:@{@"_id":@"6",@"developmentModel": @"k42",@"productModel":@"k30"}];
        //PLPProductInfo *productInfo7 = [[PLPProductInfo alloc] initWithDictionary:@{@"_id":@"7",@"developmentModel": @"k41",@"productModel":@"k30"}];
        
        [self.productList addObject:productInfo1];
        [self.productList addObject:productInfo2];
        [self.productList addObject:productInfo3];
        [self.productList addObject:productInfo4];
        [self.productList addObject:productInfo5];
        [self.productList addObject:productInfo6];
    }
}
//从服务器请求产品列表
-(void) requestProductList {
    //todo 
//    __weak __typeof(self)weakSelf = self;
//    [[KDSHttpManager sharedManager] getProductionListSuccess:^(NSArray<PLPProductInfo *> * _Nonnull productList) {
//        [weakSelf.productList removeAllObjects];
//        [weakSelf.productList addObjectsFromArray:productList];
//        } error:^(NSError * _Nonnull error) {
//
//        } failure:^(NSError * _Nonnull error) {
//
//        }];
}

//关键字查找指定类别产品列表
-(NSArray <PLPProductInfo *> *) searchProductList:(PLPProductCategory ) category keyword:(NSString * _Nullable) keyword {
    
    NSArray<PLPProductInfo *> *productList = [self searchProductList:category];
    if (!keyword) {
        return productList;
    }else {
        NSMutableArray *result = [[NSMutableArray alloc] init];
        
        for (NSUInteger i=0; i<productList.count; i++) {
            PLPProductInfo *product = productList[i];
            //todo 修改查找字段
            if ([[[product plpSearchText] lowercaseString]  containsString:[keyword lowercaseString]]) {
                [result addObject:product];
            }
        }
        return result.count ? result : nil;
    }
}

//指定类别产品列表
-(NSArray <PLPProductInfo *> *) searchProductList:(PLPProductCategory ) category{
    NSMutableArray *result;
    
    if (category == PLPProductCategoryAll ) {
        return [self.productList copy];
    }else {

        result = [[NSMutableArray alloc] init];
        for (NSUInteger i=0; i< self.productList.count; i++) {
            
            if (category & [self.productList[i] plpProductCategory] || category == [self.productList[i] plpProductCategory] ) {
                [result addObject:self.productList[i]];
            }
        }
    }
    return result.count ? result : nil;
}



//产品所有类别
-(NSArray <NSNumber *> *) productCategorys {
    
    NSMutableDictionary *productListDict = [[NSMutableDictionary alloc] init];
    NSArray *productList = [self searchProductList:PLPProductCategoryAll];
    for (NSUInteger i=0; i<productList.count; i++) {
        PLPProductInfo *product = productList[i];
        NSMutableArray
        *list;
        NSNumber *key = @([product plpProductCategory]);
        if ([productListDict objectForKey:key]) {
            list = [productListDict objectForKey:@([product plpProductCategory])];
            
        }else {
            list = [[NSMutableArray alloc] init];
            [productListDict setObject:list forKey:key];
        }
        
        [list addObject:product];
    }
    return [productListDict allKeys];
}

//产品信息
-(PLPProductInfo *) productInfoWithPid:(NSString *) pid {
    __block PLPProductInfo *result;
    [self.productList enumerateObjectsUsingBlock:^(PLPProductInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj plpProductId] isEqualToString:pid]) {
            result = obj;
            *stop = YES;
        }
        
    }];
    return result;
}
//产品类别与标题
+ (NSDictionary<NSNumber *,NSString *> *) categoryTitles {
    return @{@(PLPProductCategoryAll):NSLocalizedString(@"所有产品", nil),
             @(PLPProductCategoryWiFiSmartLock) : NSLocalizedString(@"智能锁", nil)
             //@(PLPProductCategorySmartHanger) : NSLocalizedString(@"晾衣机", nil),
             //@(PLPProductCategoryDoorbell) : NSLocalizedString(@"门铃", nil),
             //@(PLPProductCategoryNotDefined) : NSLocalizedString(@"没有分类", nil)
    };
}

//产品类别与标题
+ (NSArray<NSString*> *) titlesForCategorys:(NSArray <NSNumber *>*) categorys {
    __block NSMutableArray *titles = [[NSMutableArray alloc] init];
    [categorys enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = [[PLPProductListManager categoryTitles] objectForKey:obj];
        [titles addObject: title ? title : NSLocalizedString(@"没有分类", nil)];
    }];
    return titles.count ? titles : nil;
    
}
@end
