//
//	PLPResponsevvvvProductInfoList.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "PLPProductInfo.h"

NSString *const kPLPResponsevvvvProductInfoListIdField = @"_id";
NSString *const kPLPResponsevvvvProductInfoListAdminUrl = @"adminUrl";
NSString *const kPLPResponsevvvvProductInfoListAdminUrl1x = @"adminUrl@1x";
NSString *const kPLPResponsevvvvProductInfoListAdminUrl2x = @"adminUrl@2x";
NSString *const kPLPResponsevvvvProductInfoListAdminUrl3x = @"adminUrl@3x";
NSString *const kPLPResponsevvvvProductInfoListAuthUrl = @"authUrl";
NSString *const kPLPResponsevvvvProductInfoListAuthUrl1x = @"authUrl@1x";
NSString *const kPLPResponsevvvvProductInfoListAuthUrl2x = @"authUrl@2x";
NSString *const kPLPResponsevvvvProductInfoListAuthUrl3x = @"authUrl@3x";
NSString *const kPLPResponsevvvvProductInfoListCreateTime = @"createTime";
NSString *const kPLPResponsevvvvProductInfoListDevelopmentModel = @"developmentModel";
NSString *const kPLPResponsevvvvProductInfoListDeviceListUrl = @"deviceListUrl";
NSString *const kPLPResponsevvvvProductInfoListDeviceListUrl1x = @"deviceListUrl@1x";
NSString *const kPLPResponsevvvvProductInfoListDeviceListUrl2x = @"deviceListUrl@2x";
NSString *const kPLPResponsevvvvProductInfoListDeviceListUrl3x = @"deviceListUrl@3x";
NSString *const kPLPResponsevvvvProductInfoListProductModel = @"productModel";
NSString *const kPLPResponsevvvvProductInfoListSnHead = @"snHead";

@interface PLPProductInfo ()
@end
@implementation PLPProductInfo

/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kPLPResponsevvvvProductInfoListIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kPLPResponsevvvvProductInfoListIdField];
	}	
	if(![dictionary[kPLPResponsevvvvProductInfoListAdminUrl] isKindOfClass:[NSNull class]]){
		self.adminUrl = dictionary[kPLPResponsevvvvProductInfoListAdminUrl];
	}	
	if(![dictionary[kPLPResponsevvvvProductInfoListAdminUrl1x] isKindOfClass:[NSNull class]]){
		self.adminUrl1x = dictionary[kPLPResponsevvvvProductInfoListAdminUrl1x];
	}	
	if(![dictionary[kPLPResponsevvvvProductInfoListAdminUrl2x] isKindOfClass:[NSNull class]]){
		self.adminUrl2x = dictionary[kPLPResponsevvvvProductInfoListAdminUrl2x];
	}	
	if(![dictionary[kPLPResponsevvvvProductInfoListAdminUrl3x] isKindOfClass:[NSNull class]]){
		self.adminUrl3x = dictionary[kPLPResponsevvvvProductInfoListAdminUrl3x];
	}	
	if(![dictionary[kPLPResponsevvvvProductInfoListAuthUrl] isKindOfClass:[NSNull class]]){
		self.authUrl = dictionary[kPLPResponsevvvvProductInfoListAuthUrl];
	}	
	if(![dictionary[kPLPResponsevvvvProductInfoListAuthUrl1x] isKindOfClass:[NSNull class]]){
		self.authUrl1x = dictionary[kPLPResponsevvvvProductInfoListAuthUrl1x];
	}	
	if(![dictionary[kPLPResponsevvvvProductInfoListAuthUrl2x] isKindOfClass:[NSNull class]]){
		self.authUrl2x = dictionary[kPLPResponsevvvvProductInfoListAuthUrl2x];
	}	
	if(![dictionary[kPLPResponsevvvvProductInfoListAuthUrl3x] isKindOfClass:[NSNull class]]){
		self.authUrl3x = dictionary[kPLPResponsevvvvProductInfoListAuthUrl3x];
	}	
	if(![dictionary[kPLPResponsevvvvProductInfoListCreateTime] isKindOfClass:[NSNull class]]){
		self.createTime = dictionary[kPLPResponsevvvvProductInfoListCreateTime];
	}	
	if(![dictionary[kPLPResponsevvvvProductInfoListDevelopmentModel] isKindOfClass:[NSNull class]]){
		self.developmentModel = dictionary[kPLPResponsevvvvProductInfoListDevelopmentModel];
	}	
	if(![dictionary[kPLPResponsevvvvProductInfoListDeviceListUrl] isKindOfClass:[NSNull class]]){
		self.deviceListUrl = dictionary[kPLPResponsevvvvProductInfoListDeviceListUrl];
	}	
	if(![dictionary[kPLPResponsevvvvProductInfoListDeviceListUrl1x] isKindOfClass:[NSNull class]]){
		self.deviceListUrl1x = dictionary[kPLPResponsevvvvProductInfoListDeviceListUrl1x];
	}	
	if(![dictionary[kPLPResponsevvvvProductInfoListDeviceListUrl2x] isKindOfClass:[NSNull class]]){
		self.deviceListUrl2x = dictionary[kPLPResponsevvvvProductInfoListDeviceListUrl2x];
	}	
	if(![dictionary[kPLPResponsevvvvProductInfoListDeviceListUrl3x] isKindOfClass:[NSNull class]]){
		self.deviceListUrl3x = dictionary[kPLPResponsevvvvProductInfoListDeviceListUrl3x];
	}	
	if(![dictionary[kPLPResponsevvvvProductInfoListProductModel] isKindOfClass:[NSNull class]]){
		self.productModel = dictionary[kPLPResponsevvvvProductInfoListProductModel];
	}	
	if(![dictionary[kPLPResponsevvvvProductInfoListSnHead] isKindOfClass:[NSNull class]]){
		self.snHead = dictionary[kPLPResponsevvvvProductInfoListSnHead];
	}	
	return self;
}
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.idField != nil){
		dictionary[kPLPResponsevvvvProductInfoListIdField] = self.idField;
	}
	if(self.adminUrl != nil){
		dictionary[kPLPResponsevvvvProductInfoListAdminUrl] = self.adminUrl;
	}
	if(self.adminUrl1x != nil){
		dictionary[kPLPResponsevvvvProductInfoListAdminUrl1x] = self.adminUrl1x;
	}
	if(self.adminUrl2x != nil){
		dictionary[kPLPResponsevvvvProductInfoListAdminUrl2x] = self.adminUrl2x;
	}
	if(self.adminUrl3x != nil){
		dictionary[kPLPResponsevvvvProductInfoListAdminUrl3x] = self.adminUrl3x;
	}
	if(self.authUrl != nil){
		dictionary[kPLPResponsevvvvProductInfoListAuthUrl] = self.authUrl;
	}
	if(self.authUrl1x != nil){
		dictionary[kPLPResponsevvvvProductInfoListAuthUrl1x] = self.authUrl1x;
	}
	if(self.authUrl2x != nil){
		dictionary[kPLPResponsevvvvProductInfoListAuthUrl2x] = self.authUrl2x;
	}
	if(self.authUrl3x != nil){
		dictionary[kPLPResponsevvvvProductInfoListAuthUrl3x] = self.authUrl3x;
	}
	if(self.createTime != nil){
		dictionary[kPLPResponsevvvvProductInfoListCreateTime] = self.createTime;
	}
	if(self.developmentModel != nil){
		dictionary[kPLPResponsevvvvProductInfoListDevelopmentModel] = self.developmentModel;
	}
	if(self.deviceListUrl != nil){
		dictionary[kPLPResponsevvvvProductInfoListDeviceListUrl] = self.deviceListUrl;
	}
	if(self.deviceListUrl1x != nil){
		dictionary[kPLPResponsevvvvProductInfoListDeviceListUrl1x] = self.deviceListUrl1x;
	}
	if(self.deviceListUrl2x != nil){
		dictionary[kPLPResponsevvvvProductInfoListDeviceListUrl2x] = self.deviceListUrl2x;
	}
	if(self.deviceListUrl3x != nil){
		dictionary[kPLPResponsevvvvProductInfoListDeviceListUrl3x] = self.deviceListUrl3x;
	}
	if(self.productModel != nil){
		dictionary[kPLPResponsevvvvProductInfoListProductModel] = self.productModel;
	}
	if(self.snHead != nil){
		dictionary[kPLPResponsevvvvProductInfoListSnHead] = self.snHead;
	}
	return dictionary;

}



/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	if(self.idField != nil){
		[aCoder encodeObject:self.idField forKey:kPLPResponsevvvvProductInfoListIdField];
	}
	if(self.adminUrl != nil){
		[aCoder encodeObject:self.adminUrl forKey:kPLPResponsevvvvProductInfoListAdminUrl];
	}
	if(self.adminUrl1x != nil){
		[aCoder encodeObject:self.adminUrl1x forKey:kPLPResponsevvvvProductInfoListAdminUrl1x];
	}
	if(self.adminUrl2x != nil){
		[aCoder encodeObject:self.adminUrl2x forKey:kPLPResponsevvvvProductInfoListAdminUrl2x];
	}
	if(self.adminUrl3x != nil){
		[aCoder encodeObject:self.adminUrl3x forKey:kPLPResponsevvvvProductInfoListAdminUrl3x];
	}
	if(self.authUrl != nil){
		[aCoder encodeObject:self.authUrl forKey:kPLPResponsevvvvProductInfoListAuthUrl];
	}
	if(self.authUrl1x != nil){
		[aCoder encodeObject:self.authUrl1x forKey:kPLPResponsevvvvProductInfoListAuthUrl1x];
	}
	if(self.authUrl2x != nil){
		[aCoder encodeObject:self.authUrl2x forKey:kPLPResponsevvvvProductInfoListAuthUrl2x];
	}
	if(self.authUrl3x != nil){
		[aCoder encodeObject:self.authUrl3x forKey:kPLPResponsevvvvProductInfoListAuthUrl3x];
	}
	if(self.createTime != nil){
		[aCoder encodeObject:self.createTime forKey:kPLPResponsevvvvProductInfoListCreateTime];
	}
	if(self.developmentModel != nil){
		[aCoder encodeObject:self.developmentModel forKey:kPLPResponsevvvvProductInfoListDevelopmentModel];
	}
	if(self.deviceListUrl != nil){
		[aCoder encodeObject:self.deviceListUrl forKey:kPLPResponsevvvvProductInfoListDeviceListUrl];
	}
	if(self.deviceListUrl1x != nil){
		[aCoder encodeObject:self.deviceListUrl1x forKey:kPLPResponsevvvvProductInfoListDeviceListUrl1x];
	}
	if(self.deviceListUrl2x != nil){
		[aCoder encodeObject:self.deviceListUrl2x forKey:kPLPResponsevvvvProductInfoListDeviceListUrl2x];
	}
	if(self.deviceListUrl3x != nil){
		[aCoder encodeObject:self.deviceListUrl3x forKey:kPLPResponsevvvvProductInfoListDeviceListUrl3x];
	}
	if(self.productModel != nil){
		[aCoder encodeObject:self.productModel forKey:kPLPResponsevvvvProductInfoListProductModel];
	}
	if(self.snHead != nil){
		[aCoder encodeObject:self.snHead forKey:kPLPResponsevvvvProductInfoListSnHead];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.idField = [aDecoder decodeObjectForKey:kPLPResponsevvvvProductInfoListIdField];
	self.adminUrl = [aDecoder decodeObjectForKey:kPLPResponsevvvvProductInfoListAdminUrl];
	self.adminUrl1x = [aDecoder decodeObjectForKey:kPLPResponsevvvvProductInfoListAdminUrl1x];
	self.adminUrl2x = [aDecoder decodeObjectForKey:kPLPResponsevvvvProductInfoListAdminUrl2x];
	self.adminUrl3x = [aDecoder decodeObjectForKey:kPLPResponsevvvvProductInfoListAdminUrl3x];
	self.authUrl = [aDecoder decodeObjectForKey:kPLPResponsevvvvProductInfoListAuthUrl];
	self.authUrl1x = [aDecoder decodeObjectForKey:kPLPResponsevvvvProductInfoListAuthUrl1x];
	self.authUrl2x = [aDecoder decodeObjectForKey:kPLPResponsevvvvProductInfoListAuthUrl2x];
	self.authUrl3x = [aDecoder decodeObjectForKey:kPLPResponsevvvvProductInfoListAuthUrl3x];
	self.createTime = [aDecoder decodeObjectForKey:kPLPResponsevvvvProductInfoListCreateTime];
	self.developmentModel = [aDecoder decodeObjectForKey:kPLPResponsevvvvProductInfoListDevelopmentModel];
	self.deviceListUrl = [aDecoder decodeObjectForKey:kPLPResponsevvvvProductInfoListDeviceListUrl];
	self.deviceListUrl1x = [aDecoder decodeObjectForKey:kPLPResponsevvvvProductInfoListDeviceListUrl1x];
	self.deviceListUrl2x = [aDecoder decodeObjectForKey:kPLPResponsevvvvProductInfoListDeviceListUrl2x];
	self.deviceListUrl3x = [aDecoder decodeObjectForKey:kPLPResponsevvvvProductInfoListDeviceListUrl3x];
	self.productModel = [aDecoder decodeObjectForKey:kPLPResponsevvvvProductInfoListProductModel];
	self.snHead = [aDecoder decodeObjectForKey:kPLPResponsevvvvProductInfoListSnHead];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	PLPProductInfo *copy = [PLPProductInfo new];

	copy.idField = [self.idField copy];
	copy.adminUrl = [self.adminUrl copy];
	copy.adminUrl1x = [self.adminUrl1x copy];
	copy.adminUrl2x = [self.adminUrl2x copy];
	copy.adminUrl3x = [self.adminUrl3x copy];
	copy.authUrl = [self.authUrl copy];
	copy.authUrl1x = [self.authUrl1x copy];
	copy.authUrl2x = [self.authUrl2x copy];
	copy.authUrl3x = [self.authUrl3x copy];
	copy.createTime = [self.createTime copy];
	copy.developmentModel = [self.developmentModel copy];
	copy.deviceListUrl = [self.deviceListUrl copy];
	copy.deviceListUrl1x = [self.deviceListUrl1x copy];
	copy.deviceListUrl2x = [self.deviceListUrl2x copy];
	copy.deviceListUrl3x = [self.deviceListUrl3x copy];
	copy.productModel = [self.productModel copy];
	copy.snHead = [self.snHead copy];

	return copy;
}

#pragma mark - PLPProductInfoProtocol
//产品id
-(NSString *) plpProductId {
    return self.idField;
}
//用于添加设备显示的产品名称
-(NSString *) plpDisplayName {
    return self.developmentModel;
}
//返回查找产品字符串
-(NSString *) plpSearchText {
    return self.developmentModel;
}
//用于添加产品显示图片
-(NSString *) plpAddDeviceImage {
    return self.deviceListUrl ?: @"philips_home_scan_img_lock";
}
//用于设备列表显示图片
-(NSString *) plpDeviceListImage {
    return self.deviceListUrl ?: @"philips_home_icon_video_list";
}
//用于设备卡片显示图片
-(NSString *) plpDeviceCardImage {
    return self.deviceListUrl ? : @"philips_home_icon_video_card";
}
//todo根据产品型号，确定产品类别
//产品类别
-(PLPProductCategory) plpProductCategory {
    PLPProductCategory result = PLPProductCategoryNotDefined;
    if ([self.productModel isEqualToString:@"k1001"]) {
        result= PLPProductCategoryWiFiSmartLock;
    }else if ([self.productModel isEqualToString:@"k20"]){
        result = PLPProductCategorySmartHanger;
    }else if ([self.productModel isEqualToString:@"k30"]){
        result = PLPProductCategoryDoorbell;
    }
    return result;
}

#pragma mark - PLPCellProtocol
//单元格图像
-(NSString *) plpCellImageName {
    return [self plpAddDeviceImage];
}
//单元格标题
-(NSString *) plpCellTitle {
    return [self plpDisplayName];
}
//单元格子标题
-(NSString *) plpCellSubTitle {
    return nil;
}
@end
