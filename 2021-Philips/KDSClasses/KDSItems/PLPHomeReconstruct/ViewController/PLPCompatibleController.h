//
//  PLPCompatibleController.h
//  2021-Philips
//
//  Created by Apple on 2021/5/28.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PLPCompatibleController : NSObject

//需要初始化
@property(nonatomic, weak) UINavigationController *navigationController;

//原有首页需要调用的
- (void)viewDidLoad;
-(void)viewWillAppear:(BOOL)animated;
-(void)viewDidAppear:(BOOL)animated;
-(void)viewDidDisappear:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
