//
//  PLPHomeNoDeviceView.h
//  2021-Philips
//
//  Created by Apple on 2021/5/31.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PLPHomeNoDeviceView : UIView
@property(nonatomic, weak) IBOutlet UILabel *labText;
@property(nonatomic, weak) IBOutlet UIButton *btnAddDevice;
@property(nonatomic, copy) void (^addDeviceBlock)(void);
-(IBAction)btnAddDeviceAction:(id)sender;
@end

NS_ASSUME_NONNULL_END
