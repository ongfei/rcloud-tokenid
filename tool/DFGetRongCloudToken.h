//
//  DFGetRongCloudToken.h
//  QuanZiChat
//
//  Created by SINOKJ on 16/4/26.
//  Copyright © 2016年 ZhongHongLin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MyBlock)(id);
@interface DFGetRongCloudToken : NSObject
@property(nonatomic, strong) NSString * app_key;
@property(nonatomic, strong) NSString * appSecret;
/**
 *  获取融云Token接口
 */
- (void)getTokenWithUserId:(NSString *)userId Name:(NSString *)name PortraitUri:(NSString *)portraitUri CallBack:(MyBlock)callBack;
@end
