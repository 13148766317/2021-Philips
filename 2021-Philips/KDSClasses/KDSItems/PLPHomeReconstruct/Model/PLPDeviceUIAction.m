//
//  PLPDeviceUIAction.m
//  Pages
//
//  Created by Apple on 2021/5/26.
//

#import "PLPDeviceUIAction.h"

@implementation PLPDeviceUIAction

#pragma mark - PLPCellDataProtocol
//单元格图像
-(NSString *) plpCellImageName {
    return self.imageName;
}
//单元格标题
-(NSString *) plpCellTitle {
    return self.title;
}
//单元格子标题
-(NSString *) plpCellSubTitle {
    return nil;
}

@end
