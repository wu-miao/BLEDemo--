//
//  WMBluetoothHelper.m
//  BLEDemo-封装
//
//  Created by wumiao on 17/1/6.
//  Copyright © 2017年 wumiao. All rights reserved.
//

#import "WMBluetoothHelper.h"

@implementation WMBluetoothHelper
@synthesize scannTime;
@synthesize cbCM;
@synthesize nDevices;
@synthesize nCharacteristics;
@synthesize nServices;
@synthesize cbCharacteristcs;
@synthesize bluetoothPowerOn;
@synthesize cbPeripheral;
@synthesize serviceUUID;
@synthesize deviceUUID;
@synthesize characterUUIDArray;
@synthesize writeUUID;

- (void)startScan{
    if (bluetoothPowerOn) {
        //扫描设备
        NSLog(@"开始扫描");
        [cbCM scanForPeripheralsWithServices:nil options:nil];
        [self performSelector:@selector(stopScan) withObject:nil afterDelay:scannTime];
    }
}

- (void)stopScan{
    NSLog(@"结束扫描");
    [cbCM stopScan];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopScan) object:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(scannFinish:)]) {
        [self.delegate scannFinish:nDevices];
    }
}

- (void)startconnect:(CBPeripheral *)per{
    NSLog(@"开始连接");
    cbPeripheral = per;
    [cbCM connectPeripheral:per options:nil];
}

- (void)connectSpecificDevice:(NSString *)UUIDString{
    
}

- (void)cancelConnect{
    NSLog(@"取消连接");
    [cbCM cancelPeripheralConnection:cbPeripheral];
}

- (void)writeData:(NSData *)data{
    NSLog(@"发送数据:%@",data);
    [cbPeripheral writeValue:data forCharacteristic:cbCharacteristcs type:CBCharacteristicWriteWithResponse];
}
#pragma mark -CBCentralManagerDelegate
//判断系统蓝牙状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBManagerStatePoweredOff:
            bluetoothPowerOn = FALSE;
            if (self.delegate && [self.delegate respondsToSelector:@selector(blePowerOff)]) {
                [self.delegate blePowerOff];
            }
            break;
        case CBManagerStatePoweredOn:
            bluetoothPowerOn = YES;
            if (self.delegate && [self.delegate respondsToSelector:@selector(blePowerOn)]) {
                [self.delegate blePowerOn];
            }
            [self startScan];
            break;
        case CBManagerStateResetting:
            break;
        case CBManagerStateUnauthorized:
            break;
        case CBManagerStateUnknown:
            break;
        case CBManagerStateUnsupported:
            break;
        default:
            break;
    }
}
//已发现设备
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    if (![nDevices containsObject:peripheral]) {
        [nDevices addObject:peripheral];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(foundPeripheral:)]) {
        [self.delegate foundPeripheral:peripheral];
    }
}
//已连接到设备但是还不能通讯
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    //发现services
    //设置peripheral的delegate未self非常重要，否则，didDiscoverServices无法回调
    peripheral.delegate = self;
    if (self.delegate && [self.delegate respondsToSelector:@selector(connectSuccess:)]) {
        [self.delegate connectSuccess:peripheral];
    };
    NSMutableArray *servicesUUID = [NSMutableArray arrayWithObject:[CBUUID UUIDWithString:serviceUUID]];
    [cbPeripheral discoverServices:servicesUUID];
}
// 连接设备失败（但不包含超时，系统没有超时处理）
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(connectFailed)]) {
        [self.delegate connectFailed];
    }
}
//已断开从机的链接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"已断开设备");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self startconnect:peripheral];
    });
}
#pragma mark -CBPeripheralDelegate
//已搜索到services
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    for (CBService *s in peripheral.services) {
        NSLog(@"s = %@",s);
        [peripheral discoverCharacteristics:nil forService:s];
    }
}

//已搜索到Characteristics
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    for (CBCharacteristic *c in service.characteristics) {
        NSLog(@"c = %@",c);
        if ([characterUUIDArray containsObject:[NSString stringWithFormat:@"%@",c.UUID]]) {
            [peripheral setNotifyValue:YES forCharacteristic:c];
        }
        if ([c.UUID isEqual:[CBUUID UUIDWithString:writeUUID]]) {
            cbCharacteristcs = c;
            if (self.delegate && [self.delegate respondsToSelector:@selector(connectSuccessAndFindSerivce:character:)]) {
                [self.delegate connectSuccessAndFindSerivce:peripheral character:c];
            }
        }
    }
}
// 设置数据订阅成功（或失败）
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"订阅改变%@",characteristic);
    if (error) {
        return;
    }
}
//已读到char
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        return;
    }
    NSLog(@"读取数据成功");
    NSLog(@"characteristic.value = %@",characteristic.value);
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendDataScuccess:)]) {
        [self.delegate sendDataScuccess:characteristic.value];
    }
}
#pragma mark -内部函数
-(id)init
{
    if(self = [super init])
    {
        scannTime = 5;
        
        cbCM = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        nDevices = [[NSMutableArray alloc] init];
        nServices = [[NSMutableArray alloc] init];
        nCharacteristics = [[NSMutableArray alloc] init];
        bluetoothPowerOn = FALSE;
        
        //deviceUUID    = @"****";
        serviceUUID   = kserviceUUID;
        writeUUID     = kwriteUUID;
        characterUUIDArray = [[NSArray alloc] initWithObjects:
                              kwriteUUID,
                              kcharacterUUID,
                              nil];
    }
    return self;
}
@end
