//
//  PLPAboutImageTextCell.h
//  2021-Philips
//
//  Created by Apple on 2021/5/7.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <XLForm/XLForm.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const XLFormRowDescriptorTypeAboutImageText;


@interface PLPAboutImageTextCell : XLFormBaseCell
@property (weak, nonatomic) IBOutlet UIImageView *ivLogo;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;

@end

NS_ASSUME_NONNULL_END
