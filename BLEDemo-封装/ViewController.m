//
//  ViewController.m
//  BLEDemo-封装
//
//  Created by wumiao on 17/1/6.
//  Copyright © 2017年 wumiao. All rights reserved.
//

#import "ViewController.h"
#import "single.h"
#import "sendDataViewController.h"
#define viewWidth self.view.bounds.size.width
#define viewheight self.view.bounds.size.height
@interface ViewController ()<WMBluetoothHelperDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) WMBluetoothHelper *wm;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation ViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [single shareInstance].wm.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设备";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"扫描" style:UIBarButtonItemStylePlain target:self action:@selector(start)];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}
- (void)start{
    [single shareInstance].wm.delegate = self;
    [[single shareInstance].wm startScan];
    [single shareInstance].wm.scannTime = 3;
}
#pragma mark ------- WMBluetoothHelperDelegate
- (void)foundPeripheral:(CBPeripheral *)per{
    [self.dataArray addObject:per];
    [self.tableView reloadData];
}
- (void)scannFinish:(NSMutableArray *)bleArr{
    NSLog(@"bleArr = %@",bleArr);
}
- (void)connectSuccessAndFindSerivce:(CBPeripheral *)per character:(CBCharacteristic *)character{
    sendDataViewController *send = [[sendDataViewController alloc] init];
    [self.navigationController pushViewController:send animated:YES];
}
#pragma mark ----tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    CBPeripheral *per = self.dataArray[indexPath.row];
    if ([per.name isEqualToString:@"RPB502-1A3F"]) {
        cell.textLabel.textColor = [UIColor redColor];
    }
    cell.textLabel.text = per.name;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CBPeripheral *per = self.dataArray[indexPath.row];
    [[single shareInstance].wm startconnect:per];
}

#pragma mark ----懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewheight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (WMBluetoothHelper *)wm{
    if (!_wm) {
        _wm = [[WMBluetoothHelper alloc] init];
        _wm.delegate = self;
    }
    return _wm;
}
@end
