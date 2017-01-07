//
//  WMBluetoothHelper.h
//  BLEDemo-封装
//
//  Created by wumiao on 17/1/6.
//  Copyright © 2017年 wumiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define kserviceUUID @"****"
#define kwriteUUID @"****"
#define kcharacterUUID @"****"

@protocol WMBluetoothHelperDelegate <NSObject>
@optional
//发现设备
- (void)foundPeripheral:(CBPeripheral *)per;
//扫描结束
- (void)scannFinish:(NSMutableArray *)bleArr;
//连接设备成功 <没有指定服务和特征，纯粹连接上而已>
- (void)connectSuccess:(CBPeripheral *)per;
//连接设备成功 <发现制定服务和特征>
- (void)connectSuccessAndFindSerivce:(CBPeripheral *)per
                           character:(CBCharacteristic *)character;
//发送数据成功并返回数据
- (void)sendDataScuccess:(NSData *)backData;
//连接失败
- (void)connectFailed;
//由于距离等一些原因，设备断开连接
- (void)disConnectWithDevice;
//蓝牙被打开
- (void)blePowerOn;
//蓝牙被关闭
- (void)blePowerOff;

@end

@interface WMBluetoothHelper : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic, weak) id<WMBluetoothHelperDelegate>delegate;

@property (assign)           int                  scannTime; //扫描时长，默认5s
@property (nonatomic, retain)NSMutableDictionary *deviceDic;//扫描到的设备

@property (nonatomic,strong) CBCentralManager     *cbCM;
@property (strong,nonatomic) NSMutableArray       *nDevices;
@property (strong,nonatomic) NSMutableArray       *nServices;
@property (strong,nonatomic) NSMutableArray       *nCharacteristics;

@property (strong,nonatomic) CBPeripheral         *cbPeripheral;
@property (strong,nonatomic) CBService            *cbServices;
@property (strong,nonatomic) CBCharacteristic     *cbCharacteristcs;
@property (nonatomic,assign)BOOL bluetoothPowerOn;

@property (nonatomic, retain) NSString             *deviceUUID;
@property (nonatomic, retain) NSString             *serviceUUID;
@property (nonatomic, retain) NSString             *writeUUID;
@property (nonatomic, retain) NSArray              *characterUUIDArray;
/*
 开始扫描
 */
- (void)startScan;
/*
 停止扫描
 */
- (void)stopScan;
/*
 连接设备
 */
- (void)startconnect:(CBPeripheral *)per;
/*
 链接特定的设备,<未完成>
 */
- (void)connectSpecificDevice:(NSString *)UUIDString;
/*
 断开连接
 */
- (void)cancelConnect;
/*
 发送数据
 */
- (void)writeData:(NSData *)data;

@end
