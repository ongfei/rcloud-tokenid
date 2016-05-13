//
//  DFGetRongCloudToken.m
//  QuanZiChat
//
//  Created by SINOKJ on 16/4/26.
//  Copyright © 2016年 ZhongHongLin. All rights reserved.
//

#import "DFGetRongCloudToken.h"
#import "CocoaSecurity.h"
//生成Token
#define BASE_URL @"https://api.cn.rong.io/user/getToken.json"
@implementation DFGetRongCloudToken
- (void)getTokenWithUserId:(NSString *)userId Name:(NSString *)name PortraitUri:(NSString *)portraitUri CallBack:(MyBlock)callBack {
    if (!_app_key || !_appSecret) {
        NSLog(@"请先设置appkey和appSecret");
        return;
    }
    NSDictionary *parameters = @{
                                 @"userId":userId,
                                 @"name":name,
                                 @"portraitUri":portraitUri,
                                 };
    [self getNetDataWithParameter:parameters URL:BASE_URL CallBack:^(id data) {
        if (data == nil) {
            callBack(nil);
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                id parseData = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
                callBack(parseData[@"token"]);
            });
        }
    }];

    
}

- (void)getNetDataWithParameter:(NSDictionary *)params URL:(NSString *)url CallBack:(MyBlock)callBack{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"post"];
    NSData *tempData = [self httpBodyFromParamDictionary:params];
    [request setHTTPBody:tempData];
    NSString *nonce = [NSString stringWithFormat:@"%d", arc4random_uniform(10000)];
    NSString *Timestamp = [NSString stringWithFormat:@"%ld",time(NULL)];
    [request setValue:self.app_key forHTTPHeaderField:@"App-Key"];
    [request setValue:nonce forHTTPHeaderField:@"Nonce"];
    [request setValue:Timestamp forHTTPHeaderField:@"Timestamp"];
    [request setValue:self.appSecret forHTTPHeaderField:@"appSecret"];
    [request setValue:[self getSHA1String] forHTTPHeaderField:@"Signature"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data == nil) {
            callBack(nil);
        }else{
            callBack(data);
        }
    }];
    [task resume];
}
- (NSData *)httpBodyFromParamDictionary:(NSDictionary *)params
{
    NSMutableString * data = [NSMutableString string];
    for (NSString * key in params.allKeys) {
        [data appendFormat:@"%@=%@&",key,params[key]];
    }
    return [[data substringToIndex:data.length-1] dataUsingEncoding:NSUTF8StringEncoding];
}
- (NSString *)getSHA1String{
    if (self.appSecret) {
        NSString *str = [NSString stringWithFormat:@"%@%@%@",self.appSecret,[NSString stringWithFormat:@"%d",arc4random_uniform(10000)],[NSString stringWithFormat:@"%ld",time(NULL)]];
        CocoaSecurityResult *result_sha1 = [CocoaSecurity sha1:str];
        return result_sha1.hex;
    }else{
        NSLog(@"请设置appSecret");
        return nil;
    }
}
@end
