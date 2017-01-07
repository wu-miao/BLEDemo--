//
//  number.h
//  nsstring nsdata test
//
//  Created by wumiao on 16/4/8.
//  Copyright © 2016年 wumiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface number : NSString

/**
 *  普通字符转16进制
 */
+ (NSString *)hexStringFromString:(NSString *)string;
/**
 *  将16进制数据转化成NSData
 */
+ (NSData *) hexToBytes:(NSString *)string;
/**
 *  16进制转换为普通字符串的
 */
+ (NSString *)stringFromHexString:(NSString *)hexString;
/**
 *  nsdata转成16进制字符串
 */
+ (NSString *)stringWithHexBytes2:(NSData *)sender;
/**
 *  将16进制数据转化成NSData 数组
 */
+ (NSData *) parseHexToByteArray:(NSString*) hexString;
@end
