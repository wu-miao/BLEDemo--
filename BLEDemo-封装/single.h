//
//  single.h
//  MVVC－缓存
//
//  Created by wumiao on 17/1/5.
//  Copyright © 2017年 wumiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMBluetoothHelper.h"
@interface single : NSObject<WMBluetoothHelperDelegate>

@property (nonatomic, strong) WMBluetoothHelper *wm;

+ (single *)shareInstance;

@end
