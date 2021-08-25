//
//  PLPFormUtils.m
//  2021-Philips
//
//  Created by Apple on 2021/5/6.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPFormUtils.h"

#define kTableViewBackgroudColor [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0]

#define kCellBackgroudColor [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]

#define kCellAccessoryViewImageName @"philips_icon_more"

#define kCellTextColor [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]
#define kCellDetailTextColor [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]

#define kCellTextFont [UIFont systemFontOfSize:16]
#define kCellDetailTextFont [UIFont systemFontOfSize:14]

@implementation PLPFormUtils

+(UIColor *) tableViewBackgroudColor {
    return kTableViewBackgroudColor;
}
+(UIColor *) cellBackgroudColor {
    return kCellBackgroudColor;
}
+(NSString *) cellAccessoryViewImageName {
    return kCellAccessoryViewImageName;
}
+(UIColor *) cellTextColor {
    return kCellTextColor;
}
+(UIColor *) cellDetailTextColor {
    return kCellDetailTextColor;
}
+(UIFont *) cellTextFont {
    return kCellTextFont;
}
+(UIFont *) cellDetailTextFont {
    return kCellDetailTextFont;
}

+(XLFormRowDescriptor *) genRowTag:(NSString *) tag imageName:(id) imageName title:(NSString *) title  subTitle:(NSString *) subTitle  formBlock:(void (^)(XLFormRowDescriptor *))formBlock cellStyle:(UITableViewCellStyle) cellStyle enableDefaultAccessoryView:(BOOL) enableDefaultAccessoryView {
    XLFormRowDescriptor * row;
    row = [XLFormRowDescriptor formRowDescriptorWithTag:tag rowType:formBlock ? XLFormRowDescriptorTypeButton : XLFormRowDescriptorTypeInfo title:title];
    row.action.formBlock = formBlock;
    
    
    [row.cellConfig setObject:@(NSTextAlignmentNatural) forKey:@"textLabel.textAlignment"];
    
    [PLPFormUtils configCellRow:row attributedText:title];


    if (subTitle) {
        [PLPFormUtils configCellRow:row detailAttributedText:subTitle];
    }
    
    if (imageName) {
        if ([imageName isKindOfClass:[NSData class]]) {
            [row.cellConfig setObject:[[UIImage alloc] initWithData:imageName] forKey:@"imageView.image"];
        }else {
            [row.cellConfig setObject:[UIImage imageNamed:imageName] forKey:@"imageView.image"];
        }
        
    }
    
    if (formBlock && enableDefaultAccessoryView) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCellAccessoryViewImageName]];
        [row.cellConfig setObject:imageView forKey:@"accessoryView"];
    }
    
    
//    [row.cellConfig setObject:@(UITableViewCellAccessoryDisclosureIndicator) forKey:@"accessoryType"];
    
    row.cellStyle = cellStyle;
    return row;
}
+(XLFormRowDescriptor *) genRowTag:(NSString *) tag imageName:(id) imageName title:(NSString *) title  subTitle:(NSString *) subTitle  formBlock:(void (^)(XLFormRowDescriptor *))formBlock cellStyle:(UITableViewCellStyle) cellStyle {
    return [PLPFormUtils genRowTag:tag imageName:imageName title:title subTitle:subTitle formBlock:formBlock cellStyle:UITableViewCellStyleDefault enableDefaultAccessoryView:YES];

}
+(XLFormRowDescriptor *) genRowTag:(NSString *) tag imageName:(id) imageName title:(NSString *) title  subTitle:(NSString *) subTitle  formBlock:(void (^)(XLFormRowDescriptor *))formBlock {
    return [PLPFormUtils genRowTag:tag imageName:imageName title:title subTitle:subTitle formBlock:formBlock cellStyle:UITableViewCellStyleDefault];
}
+(XLFormRowDescriptor *) genRowTag:(NSString *) tag imageName:(id) imageName title:(NSString *) title formBlock:(void (^)(XLFormRowDescriptor *))formBlock {
    
    return [PLPFormUtils genRowTag:tag imageName:imageName title:title subTitle:nil formBlock:formBlock cellStyle:UITableViewCellStyleDefault];

}
+(void) configCellRow:(XLFormRowDescriptor *) row attributedText:(NSString *) text {
    [row.cellConfig setObject:[PLPFormUtils  cellAttributedText:text] forKey:@"textLabel.attributedText"];
}
+(void) configCellRow:(XLFormRowDescriptor *) row detailAttributedText:(NSString *) text {
    [row.cellConfig setObject:[PLPFormUtils cellDetailAttributedText:text] forKey:@"detailTextLabel.attributedText"];
}

+(NSAttributedString *) cellAttributedText:(NSString *) text {
    return [PLPFormUtils attributedText:text color:kCellTextColor font:kCellTextFont];
}
+(NSAttributedString *) cellDetailAttributedText:(NSString *) text {
    return [PLPFormUtils attributedText:text color:kCellDetailTextColor font:kCellDetailTextFont];
}
+(NSAttributedString *) attributedText:(NSString *) text color:(UIColor *) color font:(UIFont *) font {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text ? :@"" attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: color}];
    return string;
}
+(UIButton *) primaryButton:(NSString *) title {
    return [PLPFormUtils genButton:title titleColor:[UIColor
                                                     whiteColor] backgroudColor:[UIColor colorWithRed:0/255.0 green:102/255.0 blue:161/255.0 alpha:1.0]];
}
+(UIButton *) warningButton:(NSString *) title {
    return [PLPFormUtils genButton:title titleColor:[UIColor
                                                     whiteColor] backgroudColor:[UIColor colorWithRed:205/255.0 green:32/255.0 blue:44/255.0 alpha:1.0]];

}

+(UIButton *) genButton:(NSString *) title  titleColor:(UIColor *) titleColor backgroudColor:(UIColor *) backgroudColor {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setTitle:title forState:UIControlStateNormal];
    button
    .backgroundColor = backgroudColor;
    [button setAttributedTitle:[PLPFormUtils attributedText:title color:titleColor font:[UIFont systemFontOfSize:16.0]] forState:UIControlStateNormal];
    button.layer.cornerRadius = 4.0;
    return  button;
     
}
@end
