//
//  PLPDeviceBaseView+CreateFromDevice.m
//  Pages
//
//  Created by Apple on 2021/5/21.
//

#import "PLPDeviceBaseView+CreateFromDevice.h"

@implementation PLPDeviceBaseView (CreateFromDevice)
+(PLPDeviceBaseView *) createFromDevice:(id<PLPDeviceProtocol>) device viewType:(PLPProductViewType) viewType {
    
    PLPDeviceBaseView *view;
    id<PLPProductInfoProtocol> product = [device plpProduct];
    
    if (product) {
        id viewClass = [PLPConfigUtils viewClassForProductId:[product plpProductId] viewType:viewType];
        
        if (viewClass) {
            view = [[viewClass alloc] init];
        }
        
    }
    return view;
}

+(PLPDeviceBaseView *) createFromDeviceBack:(id<PLPDeviceProtocol>) device viewType:(PLPProductViewType) viewType {
    
    PLPDeviceBaseView *view;
    id<PLPProductInfoProtocol> product = [device plpProduct];
    
    if (product) {
        id viewClass = [PLPConfigUtils viewClassForProductId:[product plpProductId] viewType:viewType];
        
        if (viewClass) {
            
        }
        
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *viewClassString = viewClass;
        NSString *viewResource = nil;
        //NSBundle *bundleForCaller = [NSBundle bundleForClass:self.class];
        
        NSAssert(viewClass, @"Not defined product %@ viewType %d",[product plpDisplayName], viewType);
        
        if ([viewClass isKindOfClass:[NSString class]]) {
            if ([viewClassString rangeOfString:@"/"].location != NSNotFound) {
                NSArray *components = [viewClassString componentsSeparatedByString:@"/"];
                viewResource = [components lastObject];
                NSString *folderName = [components firstObject];
                NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:folderName];
                bundle = [NSBundle bundleWithPath:bundlePath];
            } else {
                viewResource = [viewClassString componentsSeparatedByString:@"."].lastObject;
            }
        } else {
            viewResource = [NSStringFromClass(viewClass) componentsSeparatedByString:@"."].lastObject;
        }
        
        
        
        if ([bundle pathForResource:viewResource ofType:@"nib"]) {
            view = [[bundle loadNibNamed:viewResource owner:nil options:nil] firstObject];
//        } else if ([bundleForCaller pathForResource:cellResource ofType:@"nib"]) {
//            view = [[bundleForCaller loadNibNamed:cellResource owner:nil options:nil] firstObject];
        } else {
            view = [[viewClass alloc] init];

        }
    }
    return view;
}
@end
