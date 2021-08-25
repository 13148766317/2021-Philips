//
//  PLPCellProtocol.h
//  2021-Philips
//
//  Created by Apple on 2021/5/14.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PLPCellDataProtocol <NSObject>
//单元格图像
-(NSString *) plpCellImageName;
//单元格标题
-(NSString *) plpCellTitle;
//单元格子标题
-(NSString *) plpCellSubTitle;

@end

NS_ASSUME_NONNULL_END
