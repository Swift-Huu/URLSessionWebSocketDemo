//
//  SocketRocketViewController.m
//  WebSocketDemo
//
//  Created by 胡智林 on 2019/10/14.
//  Copyright © 2019 胡智林. All rights reserved.
//

#import "SocketRocketViewController.h"
#import <SocketRocket/SRWebSocket.h>
#import <Masonry/Masonry.h>
#import "WebSocketDemo-Swift.h"
@interface SocketRocketViewController ()<SRWebSocketDelegate>
@property(nonatomic ,strong) SRWebSocket *mySRWebSocket;
@property(nonatomic, strong) UITextView *input;
@property(nonatomic, strong) UIButton *sendButton;
@end

@implementation SocketRocketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"连接" style:UIBarButtonItemStylePlain target:self action:@selector(conectionTap)];
    [self.view addSubview:self.input];
    [self.view addSubview:self.sendButton];
    [self.input mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.input);
        make.top.mas_equalTo(self.input.mas_bottom).offset(30);
        make.height.mas_equalTo(30);
    }];
    NSURL *url = [[NSURL alloc]initWithString: @"ws://localhost:8090/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    self.mySRWebSocket = [[SRWebSocket alloc]initWithURLRequest:request];
    self.mySRWebSocket.delegate = self;
    [self.mySRWebSocket open];
}
- (void)dealloc{
    [self.mySRWebSocket close];
    self.mySRWebSocket.delegate = nil;
    self.mySRWebSocket = nil;
}
- (UITextView *)input {
    if (!_input) {
        _input = [[UITextView alloc]init];
        _input.backgroundColor = [UIColor lightGrayColor];
    }
    return _input;
}
- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.backgroundColor = [UIColor systemBlueColor];
        [_sendButton addTarget:self action:@selector(sendButtonTap) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}
-(void)sendButtonTap {
    if (self.mySRWebSocket.readyState == SR_OPEN) {
       
        [self.mySRWebSocket send: self.input.text];
    } else {
        [HUD showWithMsg:@"WebSocket未打开" detailMsg:@"请退出重试"];
    }
}
- (void)conectionTap {
//    [self.mySRWebSocket close];
//    NSLog(@"conectionTap readyState = %ld", self.mySRWebSocket.readyState);
//    if (self.mySRWebSocket.readyState == SR_CLOSED) {
//        [self.mySRWebSocket open];
//    }
//    NSString *testString = @"testMessage";
//    [self.mySRWebSocket send:testString];
}
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"didReceiveMessage %@", message);
}
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"webSocketDidOpen ");
//    [SVProgressHUD showWithStatus:@"webSocketDidOpen"];
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError %@", error.description);
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"didCloseWithCode code = %ld %@", code, reason);
}
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    NSLog(@"didReceivePong %@", pongPayload.description);
}
- (BOOL)webSocketShouldConvertTextFrameToString:(SRWebSocket *)webSocket {
    return  YES;
}
@end
