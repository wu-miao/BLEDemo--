//
//  sendDataViewController.m
//  BLEDemo-封装
//
//  Created by wumiao on 17/1/6.
//  Copyright © 2017年 wumiao. All rights reserved.
//

#import "sendDataViewController.h"
#import "single.h"
#import "number.h"
#define viewWidth self.view.bounds.size.width
#define viewheight self.view.bounds.size.height
@interface sendDataViewController ()<WMBluetoothHelperDelegate>
@property (nonatomic, strong) UITextView  *textView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton    *sureButton;
@property (nonatomic, strong) UILabel     *receiveLabel;
@property (nonatomic, strong) UILabel     *sendLabel;
@end

@implementation sendDataViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [single shareInstance].wm.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [single shareInstance].wm.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.sureButton];
    [self.view addSubview:self.sendLabel];
    [self.view addSubview:self.receiveLabel];
}
#pragma mark ------ WMBluetoothHelperDelegate
- (void)sendDataScuccess:(NSData *)backData{
    NSLog(@"backData = %@",backData);
    self.textView.text = [NSString stringWithFormat:@"%@",backData];
}
- (void)sure{
    NSLog(@"发送数据");
    [[single shareInstance].wm writeData:[number hexToBytes:self.textField.text]];
}
#pragma mark -------懒加载
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 74, viewWidth - 100, 100)];
        _textView.backgroundColor = [UIColor redColor];
    }
    return _textView;
}
- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 184, viewWidth - 100, 30)];
        _textField.borderStyle = UITextBorderStyleLine;
    }
    return _textField;
}
- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 250, viewWidth, 30)];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _sureButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_sureButton addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchDown];
    }
    return _sureButton;
}

- (UILabel *)sendLabel{
    if (!_sendLabel) {
        _sendLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth - 100, 184, 100, 30)];
        _sendLabel.text = @"发送的数据";
        _sendLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _sendLabel;
}
- (UILabel *)receiveLabel{
    if (!_receiveLabel) {
        _receiveLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth - 100, 74, 100, 100)];
        _receiveLabel.text = @"接收的数据";
        _receiveLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _receiveLabel;
}
@end
