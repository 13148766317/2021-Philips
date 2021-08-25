//
//  KDSHttpManager+Login.m
//  xiaokaizhineng
//
//  Created by orange on 2019/1/22.
//  Copyright © 2019年 shenzhen kaadas intelligent technology. All rights reserved.
//
#import "KDSHttpManager+Login.h"
@implementation KDSHttpManager (Login)

- (NSURLSessionDataTask *)getCaptchaWithEmail:(NSString *)email success:(void (^)(void))success error:(void (^)(NSError *_Nonnull))errorBlock failure:(void (^)(NSError *_Nonnull))failure
{
    email = email ? : @"";
    // json
    NSDictionary *jsonStr = @{ @"mail": email, @"world": @1 };
    return [self POST:@"mail/sendemailtoken" parameters:jsonStr success:^(id _Nullable responseObject) {
        !success ? : success();
    } error:errorBlock failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        !failure ? : failure(error);
    }];
}

- (NSURLSessionDataTask *)getCaptchaWithTel:(NSString *)tel crc:(NSString *)crc success:(void (^)(void))success error:(void (^)(NSError *_Nonnull))errorBlock failure:(void (^)(NSError *_Nonnull))failure
{
    tel = tel ? : @""; crc = crc ? : @"";
    return [self POST:@"sms/sendSmsTokenByTX" parameters:@{ @"tel": tel, @"code": crc } success:^(id _Nullable responseObject) {
        !success ? : success();
    } error:errorBlock failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        !failure ? : failure(error);
    }];
}

- (NSURLSessionDataTask *)signup:(int)source username:(NSString *)name captcha:(NSString *)captcha password:(NSString *)pwd success:(void (^)(void))success error:(void (^)(NSError *_Nonnull))errorBlock failure:(void (^)(NSError *_Nonnull))failure
{
    name = name ? : @""; captcha = captcha ? : @""; pwd = pwd ? : @"";
    NSString *url = source == 1 ? @"user/reg/putuserbytel" : @"user/reg/putuserbyemail";
    NSDictionary *params = @{ @"name": name, @"tokens": captcha, @"password": pwd };
    return [self POST:url parameters:params success:^(id _Nullable responseObject) {
        !success ? : success();
    } error:errorBlock failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        !failure ? : failure(error);
    }];
}

- (NSURLSessionDataTask *)forgotPwd:(int)source name:(NSString *)name captcha:(NSString *)captcha newPwd:(NSString *)pwd success:(void (^)(void))success error:(void (^)(NSError *_Nonnull))errorBlock failure:(void (^)(NSError *_Nonnull))failure
{
    name = name ? : @""; captcha = captcha ? : @""; pwd = pwd ? : @"";
    return [self POST:@"user/edit/forgetPwd" parameters:@{ @"type": @(source), @"name": name, @"tokens": captcha, @"pwd": pwd } success:^(id _Nullable responseObject) {
        !success ? : success();
    } error:errorBlock failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        !failure ? : failure(error);
    }];
}

- (NSURLSessionDataTask *)updatePwd:(NSString *)name oldPwd:(NSString *)oldPwd newPwd:(NSString *)newPwd success:(void (^)(void))success error:(void (^)(NSError *_Nonnull))errorBlock failure:(void (^)(NSError *_Nonnull))failure
{
    name = name ? : @""; oldPwd = oldPwd ? : @""; newPwd = newPwd ? : @"";
    return [self POST:@"user/edit/postUserPwd" parameters:@{ @"uid": name, @"oldpwd": oldPwd, @"newpwd": newPwd } success:^(id _Nullable responseObject) {
        !success ? : success();
    } error:errorBlock failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        !failure ? : failure(error);
    }];
}

- (NSURLSessionDataTask *)login:(int)source username:(NSString *)name password:(NSString *)pwd success:(void (^)(KDSUser *_Nonnull))success error:(void (^)(NSError *_Nonnull))errorBlock failure:(void (^)(NSError *_Nonnull))failure
{
    name = name ? : @""; pwd = pwd ? : @"";
    NSString *url = source == 1 ? @"user/login/getuserbytel" : @"user/login/getuserbymail";
    NSDictionary *params = @{ (source == 1 ? @"tel" : @"mail"): name, @"password": pwd };

    return [self POST:url parameters:params success:^(id _Nullable responseObject) {
        if (![responseObject isKindOfClass:NSDictionary.class]) {
            !errorBlock ? : errorBlock([NSError errorWithDomain:@"返回参数不正确" code:9999 userInfo:nil]);
            return;
        }
        //成功服务器共返回4个键值对，meUsername 、 mePwd 、 uid 、 token，所有值都是哈希过的。
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
//        NSLog(@"--{Kaadas}--dict===%@",dict);

        for (NSString *key in dict.allKeys) {
            if (![dict[key] isKindOfClass:NSString.class]) dict[key] = nil;
        }
        KDSUser *user = [[KDSUser alloc] init];
        user.name = name;
        user.username = dict[@"meUsername"];
        user.uid = dict[@"uid"];
        user.password = dict[@"mePwd"];
        user.token = dict[@"token"];
        self.token = dict[@"token"];
        //商城token
//        if(dict[@"storeToken"]){
//            [userDefaults setObject:dict[@"storeToken"] forKey:USER_TOKEN];
//            [userDefaults synchronize];
//        }

        !success ? : success(user);
    } error:errorBlock failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        !failure ? : failure(error);
    }];
}

- (NSURLSessionDataTask *)logout:(int)source username:(NSString *)name uid:(NSString *)uid success:(void (^)(void))success error:(void (^)(NSError *_Nonnull))errorBlock failure:(void (^)(NSError *_Nonnull))failure
{
    return [self POST:@"/user/logout" parameters:nil success:^(id _Nullable responseObject) {
        !success ? : success();
    } error:errorBlock failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        !failure ? : failure(error);
    }];
}

// 获取微信用户绑定的手机号
- (NSURLSessionDataTask *)getTelByOpenId:(NSString *)openId success:(void (^)(NSString *_Nonnull))success error:(void (^)(NSError *_Nonnull))errorBlock failure:(void (^)(NSError *_Nonnull))failure
{
    NSDictionary *params = @{ @"openId": openId };

    return [self POST:@"user/wechat/getTelByOpenId" parameters:params success:^(id _Nullable responseObject) {
        if (![responseObject isKindOfClass:NSDictionary.class]) {
            !errorBlock ? : errorBlock([NSError errorWithDomain:@"返回参数不正确" code:9999 userInfo:nil]);
            return;
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
//        NSLog(@"--{Kaadas}--dict===%@",dict);
        NSString *tel = dict[@"tel"];
        !success ? : success(tel);
    } error:errorBlock failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        !failure ? : failure(error);
    }];
}

//注册微信 openid   绑定手机
- (NSURLSessionDataTask *)putUserByOpenId:(NSString *)openId tel:(NSString *)tel tokens:(NSString *)tokens success:(void (^)(KDSUser *_Nonnull))success error:(void (^)(NSError *_Nonnull))errorBlock failure:(void (^)(NSError *_Nonnull))failure
{
    NSDictionary *params = @{@"openId" : openId , @"tel" : tel, @"tokens": tokens };

    return [self POST:@"user/wechat/putUserByOpenId" parameters:params success:^(id _Nullable responseObject) {
        if (![responseObject isKindOfClass:NSDictionary.class]) {
            !errorBlock ? : errorBlock([NSError errorWithDomain:@"返回参数不正确" code:9999 userInfo:nil]);
            return;
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
//        NSLog(@"--{Kaadas}--dict===%@",dict);
        for (NSString *key in dict.allKeys) {
            if (![dict[key] isKindOfClass:NSString.class]) dict[key] = nil;
        }
        KDSUser *user = [[KDSUser alloc] init];
        user.uid = dict[@"uid"];
        user.token = dict[@"token"];
        self.token = dict[@"token"];
        !success ? : success(user);
    } error:errorBlock failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        !failure ? : failure(error);
    }];
}
// 微信一键登录接口
- (NSURLSessionDataTask *)getUserByOpenId:(NSString *)openId tel:(NSString *)tel  success:(void (^)(KDSUser *_Nonnull))success error:(void (^)(NSError *_Nonnull))errorBlock failure:(void (^)(NSError *_Nonnull))failure
{
    NSDictionary *params = @{@"openId" : openId , @"tel" : tel };

    return [self POST:@"user/wechat/getUserByOpenId" parameters:params success:^(id _Nullable responseObject) {
        if (![responseObject isKindOfClass:NSDictionary.class]) {
            !errorBlock ? : errorBlock([NSError errorWithDomain:@"返回参数不正确" code:9999 userInfo:nil]);
            return;
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
//        NSLog(@"--{Kaadas}--dict===%@",dict);
        for (NSString *key in dict.allKeys) {
            if (![dict[key] isKindOfClass:NSString.class]) dict[key] = nil;
        }
        KDSUser *user = [[KDSUser alloc] init];
        user.uid = dict[@"uid"];
        user.token = dict[@"token"];
        self.token = dict[@"token"];
        !success ? : success(user);
    } error:errorBlock failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        !failure ? : failure(error);
    }];
}

//  获取微信的唯一标识 openid
- (NSURLSessionDataTask *)getOpenId:(NSString *)code success:(void (^)(NSString *_Nonnull))success error:(void (^)(NSError *_Nonnull))errorBlock failure:(void (^)(NSError *_Nonnull))failure
{
    NSDictionary *params = @{ @"code": code };

    return [self POST:@"user/wechat/getOpenId" parameters:params success:^(id _Nullable responseObject) {
        if (![responseObject isKindOfClass:NSDictionary.class]) {
            !errorBlock ? : errorBlock([NSError errorWithDomain:@"返回参数不正确" code:9999 userInfo:nil]);
            return;
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
        NSLog(@"--{Kaadas}--dict===%@",dict);
        NSString *openId = dict[@"openId"];
        !success ? : success(openId);
    } error:errorBlock failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        !failure ? : failure(error);
    }];
}
///  苹果自动登录
//注册苹果 openid   绑定手机
- (NSURLSessionDataTask *)putUserByAppleId:(NSString *)appleId tel:(NSString *)tel tokens:(NSString *)tokens success:(void (^)(KDSUser *_Nonnull))success error:(void (^)(NSError *_Nonnull))errorBlock failure:(void (^)(NSError *_Nonnull))failure
{
    NSDictionary *params = @{@"appleId" : appleId , @"tel" : tel, @"tokens": tokens };

    return [self POST:@"user/apple/putUserByAppleId" parameters:params success:^(id _Nullable responseObject) {
        if (![responseObject isKindOfClass:NSDictionary.class]) {
            !errorBlock ? : errorBlock([NSError errorWithDomain:@"返回参数不正确" code:9999 userInfo:nil]);
            return;
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
//        NSLog(@"--{Kaadas}--dict===%@",dict);
        for (NSString *key in dict.allKeys) {
            if (![dict[key] isKindOfClass:NSString.class]) dict[key] = nil;
        }
        KDSUser *user = [[KDSUser alloc] init];
        user.uid = dict[@"uid"];
        user.token = dict[@"token"];
        self.token = dict[@"token"];
        !success ? : success(user);
    } error:errorBlock failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        !failure ? : failure(error);
    }];
}
// 苹果一键登录接口
- (NSURLSessionDataTask *)getUserByAppleId:(NSString *)appleId tel:(NSString *)tel  success:(void (^)(KDSUser *_Nonnull))success error:(void (^)(NSError *_Nonnull))errorBlock failure:(void (^)(NSError *_Nonnull))failure
{
    NSDictionary *params = @{@"appleId" : appleId , @"tel" : tel };

    return [self POST:@"user/apple/getUserByAppleId" parameters:params success:^(id _Nullable responseObject) {
        if (![responseObject isKindOfClass:NSDictionary.class]) {
            !errorBlock ? : errorBlock([NSError errorWithDomain:@"返回参数不正确" code:9999 userInfo:nil]);
            return;
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
//        NSLog(@"--{Kaadas}--dict===%@",dict);
        for (NSString *key in dict.allKeys) {
            if (![dict[key] isKindOfClass:NSString.class]) dict[key] = nil;
        }
        KDSUser *user = [[KDSUser alloc] init];
        user.uid = dict[@"uid"];
        user.token = dict[@"token"];
        self.token = dict[@"token"];
        !success ? : success(user);
    } error:errorBlock failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        !failure ? : failure(error);
    }];
}
// 获取微信用户绑定的手机号
- (NSURLSessionDataTask *)getTelByAppleId:(NSString *)appleId success:(void (^)(NSString *_Nonnull))success error:(void (^)(NSError *_Nonnull))errorBlock failure:(void (^)(NSError *_Nonnull))failure
{
    NSDictionary *params = @{ @"appleId": appleId };

    return [self POST:@"user/apple/getTelByAppleId" parameters:params success:^(id _Nullable responseObject) {
        if (![responseObject isKindOfClass:NSDictionary.class]) {
            !errorBlock ? : errorBlock([NSError errorWithDomain:@"返回参数不正确" code:9999 userInfo:nil]);
            return;
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
//        NSLog(@"--{Kaadas}--dict===%@",dict);
        NSString *tel = dict[@"tel"];
        !success ? : success(tel);
    } error:errorBlock failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        !failure ? : failure(error);
    }];
}

// 短信验证码登录
- (NSURLSessionDataTask *)getUserByTokens:(NSString *)tel tokens:(NSString *)tokens success:(void (^)(KDSUser *_Nonnull))success error:(void (^)(NSError *_Nonnull))errorBlock failure:(void (^)(NSError *_Nonnull))failure
{
    NSDictionary *params = @{ @"tel" : tel, @"tokens": tokens };

    return [self POST:@"user/login/getUserByTokens" parameters:params success:^(id _Nullable responseObject) {
        if (![responseObject isKindOfClass:NSDictionary.class]) {
            !errorBlock ? : errorBlock([NSError errorWithDomain:@"返回参数不正确" code:9999 userInfo:nil]);
            return;
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
        NSLog(@"--{Kaadas}--dict===%@",dict);
        for (NSString *key in dict.allKeys) {
            if (![dict[key] isKindOfClass:NSString.class]) dict[key] = nil;
        }
        KDSUser *user = [[KDSUser alloc] init];
        user.uid = dict[@"uid"];
        user.token = dict[@"token"];
        self.token = dict[@"token"];
        !success ? : success(user);
    } error:errorBlock failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        !failure ? : failure(error);
    }];
}
@end
