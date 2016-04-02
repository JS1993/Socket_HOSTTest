//
//  ViewController.m
//  Demo3_JS_HOSTTest
//
//  Created by  江苏 on 16/3/26.
//  Copyright © 2016年 jiangsu. All rights reserved.
//

#import "ViewController.h"
#import "AsyncSocket.h"
@interface ViewController ()<AsyncSocketDelegate>

@property (strong, nonatomic) IBOutlet UITextField *MessageTF;
@property (strong, nonatomic) IBOutlet UIView *myView;
@property(nonatomic,strong)AsyncSocket* sreverSocket;
@property(nonatomic,strong)AsyncSocket* mySreverSocket;
@property(nonatomic,strong)AsyncSocket* clinetSocket;
@property (strong, nonatomic) IBOutlet UITextField *IPTF;
@end

@implementation ViewController
int i=1;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.sreverSocket=[[AsyncSocket alloc]initWithDelegate:self];
    [self.sreverSocket acceptOnPort:8000 error:nil];
}
//当接收新的accept的时候
-(void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket{
    self.mySreverSocket=newSocket;//将newSocket持有住
}
//当连接成功的时候
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    [self.mySreverSocket readDataWithTimeout:-1 tag:0];
}
//当读取数据的时候
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString* stringx=[self.IPTF.text stringByAppendingString:@":"];
    NSString* string=[stringx stringByAppendingString:[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]];
    UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(10, 30*i++, 250, 20)];
    label.text=string;
    [self.myView addSubview:label];
    //保证后续数据可以持续得到
    [self.mySreverSocket readDataWithTimeout:-1 tag:0];
}
//当断开连接的时候
-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err{
    
}
- (IBAction)sure:(id)sender {
    [self.IPTF resignFirstResponder];
}
- (IBAction)send:(id)sender {
    self.clinetSocket=[[AsyncSocket alloc]initWithDelegate:self];
    [self.clinetSocket connectToHost:self.IPTF.text onPort:8000 error:nil];
    NSData* data=[self.MessageTF.text dataUsingEncoding:NSUTF8StringEncoding];
    [self.clinetSocket writeData:data withTimeout:-1 tag:0];
    UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(self.myView.bounds.size.width-150, 30*(i++), 150, 20)];
    NSString* mysays=@"我说：";
    label.text=[mysays stringByAppendingString:self.MessageTF.text];
    [self.myView addSubview:label];
    [self.MessageTF resignFirstResponder];
    self.MessageTF.text=@"";
}
-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"数据发送完成");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
