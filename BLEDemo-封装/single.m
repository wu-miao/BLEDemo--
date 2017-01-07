//
//  single.m
//  MVVC－缓存
//
//  Created by wumiao on 17/1/5.
//  Copyright © 2017年 wumiao. All rights reserved.
//

#import "single.h"

@implementation single
+ (single *)shareInstance{
    static dispatch_once_t pred = 0;
    __strong static single *_sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}
- (id)init{
    if ([super init]) {
        _wm = [[WMBluetoothHelper alloc] init];
    }
    return self;
}
@end
