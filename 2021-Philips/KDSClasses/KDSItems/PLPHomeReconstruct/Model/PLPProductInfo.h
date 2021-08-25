#import <UIKit/UIKit.h>
#import "PLPProductInfoProtocol.h"
#import "PLPCellDataProtocol.h"
@interface PLPProductInfo : NSObject <PLPProductInfoProtocol>

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * adminUrl;
@property (nonatomic, strong) NSString * adminUrl1x;
@property (nonatomic, strong) NSString * adminUrl2x;
@property (nonatomic, strong) NSString * adminUrl3x;
@property (nonatomic, strong) NSString * authUrl;
@property (nonatomic, strong) NSString * authUrl1x;
@property (nonatomic, strong) NSString * authUrl2x;
@property (nonatomic, strong) NSString * authUrl3x;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * developmentModel;
@property (nonatomic, strong) NSString * deviceListUrl;
@property (nonatomic, strong) NSString * deviceListUrl1x;
@property (nonatomic, strong) NSString * deviceListUrl2x;
@property (nonatomic, strong) NSString * deviceListUrl3x;
@property (nonatomic, strong) NSString * productModel;
@property (nonatomic, strong) NSString * snHead;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
