//
//  PLPDeviceUIAction.h
//  Pages
//
//  Created by Apple on 2021/5/26.
//

#import <Foundation/Foundation.h>
#import "PLPCellDataProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface PLPDeviceUIAction : NSObject <PLPCellDataProtocol>

@property(nonatomic, strong)  NSString *title;
@property(nonatomic, strong) NSString *imageName;
@property(nonatomic, assign) NSUInteger actionType;

@end

NS_ASSUME_NONNULL_END
