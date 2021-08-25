//
//  PLPFormUtils.h
//  2021-Philips
//
//  Created by Apple on 2021/5/6.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <XLForm/XLForm.h>
NS_ASSUME_NONNULL_BEGIN

@interface PLPFormUtils : NSObject

//表格背景色
+(UIColor *) tableViewBackgroudColor;
//单元格背景色
+(UIColor *) cellBackgroudColor;
//单元格更多图片名
+(NSString *) cellAccessoryViewImageName;
//单元格主标题文字色
+(UIColor *) cellTextColor;
//单元格子标题文字色
+(UIColor *) cellDetailTextColor;
//单元格主标题文字大小
+(UIFont *) cellTextFont;
//单元格子标题文字大小
+(UIFont *) cellDetailTextFont;

//生成单元格
+(XLFormRowDescriptor *) genRowTag:(NSString *) tag imageName:(id) imageName title:(NSString *) title  subTitle:(NSString *) subTitle  formBlock:(void (^)(XLFormRowDescriptor *))formBlock cellStyle:(UITableViewCellStyle) cellStyle enableDefaultAccessoryView:(BOOL) enableDefaultAccessoryView;

//生成单元格
+(XLFormRowDescriptor *) genRowTag:(NSString *) tag imageName:(id) imageName title:(NSString *) title  subTitle:(NSString *) subTitle  formBlock:(void (^)(XLFormRowDescriptor *))formBlock cellStyle:(UITableViewCellStyle) cellStyle;
//生成单元格
+(XLFormRowDescriptor *) genRowTag:(NSString *) tag imageName:(id) imageName title:(NSString *) title  subTitle:(NSString *) subTitle  formBlock:(void (^)(XLFormRowDescriptor *))formBlock;
//生成单元格
+(XLFormRowDescriptor *) genRowTag:(NSString *) tag imageName:(id) imageName title:(NSString *) title formBlock:(void (^)(XLFormRowDescriptor *))formBlock;



//配置单元格主标题文字大小与颜色
+(void) configCellRow:(XLFormRowDescriptor *) row attributedText:(NSString *) text;
//配置单元格子标题文字大小与颜色
+(void) configCellRow:(XLFormRowDescriptor *) row detailAttributedText:(NSString *) text;

//生成单元格标题文字属性
+(NSAttributedString *) cellAttributedText:(NSString *) text;
//生成单元格子标题文字属性
+(NSAttributedString *) cellDetailAttributedText:(NSString *) text;
//生成文字属性
+(NSAttributedString *) attributedText:(NSString *) text color:(UIColor *) color font:(UIFont *) font;
//生成基本按钮
+(UIButton *) primaryButton:(NSString *) title;
//生成警告按钮
+(UIButton *) warningButton:(NSString *) title;
@end

NS_ASSUME_NONNULL_END
