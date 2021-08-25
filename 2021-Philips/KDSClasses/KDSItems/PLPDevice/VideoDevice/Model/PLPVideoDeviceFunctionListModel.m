//
//  PLPVideoDeviceFunctionListModel.m
//  2021-Philips
//
//  Created by Frank Hu on 2021/4/27.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//
#import "PLPVideoDeviceFunctionListModel.h"

@implementation PLPVideoDeviceFunctionListModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _funcListArray = [[NSMutableArray alloc] init];
        //设置collectionView的功能及图片
        [_funcListArray insertObject:[NSDictionary dictionaryWithObjectsAndKeys:Localized(@"RecordMessage"),@"message",@"philips_equipment_icon_message",@"image", nil] atIndex:0];
        [_funcListArray insertObject:[NSDictionary dictionaryWithObjectsAndKeys:Localized(@"My_Album"),@"message",@"philips_equipment_icon_album",@"image", nil] atIndex:1];
        [_funcListArray insertObject:[NSDictionary dictionaryWithObjectsAndKeys:Localized(@"PasswordList"),@"message",@"philips_home_icon_psaaword",@"image", nil] atIndex:2];
        [_funcListArray insertObject:[NSDictionary dictionaryWithObjectsAndKeys:Localized(@"Device_Share"),@"message",@"philips_equipment_icon_share",@"image", nil] atIndex:3];
       
    }
    return self;
}

- (void)setModel
{
    
    
}

@end
