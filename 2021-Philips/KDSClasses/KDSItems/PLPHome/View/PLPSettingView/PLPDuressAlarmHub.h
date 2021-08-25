//
//  PLPDuressAlarmHub.h
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/5/20.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PLPDuressAlarmHubDelegate <NSObject>

-(void) removeDuressAlarmHub;

@end

@interface PLPDuressAlarmHub : UIView

@property (nonatomic, strong) id<PLPDuressAlarmHubDelegate>duressAlarmHubDelegate;

@end

NS_ASSUME_NONNULL_END
