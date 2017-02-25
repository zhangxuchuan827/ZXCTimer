//
//  ViewController.m
//  Demo-OC
//
//  Created by LanTuZi on 17/2/23.
//  Copyright © 2017年 张绪川. All rights reserved.
//

#import "ViewController.h"

#import "ZXCGlobalTimer.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //添加轮询队列
    
    NSInteger index = [[ZXCCycleTimer shareInstance] addQueueWithTarget:self selector:@selector(test1)];
    
    [[ZXCCycleTimer shareInstance] addQueueWithTarget:self selector:@selector(test2_WithParam:) withParam:@"我是参数"];
    
    [[ZXCCycleTimer shareInstance] addQueueWithTarget:self selector:@selector(test3_WithParam:Param2:) withParam1:@"参数1" Param2:@"参数2"];
    
//    [[ZXCCycleTimer shareInstance] addQueueWithBlock:^(NSInteger queueId) {
//        
//        NSLog(@"定时器调用了block,当前索引值:%ld",queueId);
//        
//    }];
    
    //移除定时器
    [[ZXCCycleTimer shareInstance]removeByIndex:index];
    
    [[ZXCCycleTimer shareInstance]removeQueueByTarget:self];
    
    
    //定时器调用
    
    
    NSInteger index2 = [[ZXCCycleTimer shareInstance] addCountDownWithTimeInterval:10 endBlock:^() {
    
        NSLog(@"十秒钟吼执行了这个时间");
        
    }];
    
    //取消该任务
    [[ZXCCycleTimer shareInstance]cancelCountDownWithIndex:index2];
    
    
}



-(void)test1{
    
    NSLog(@"定时器调用了test1");
    
}

-(void)test2_WithParam:(NSString *)str{
    
    NSLog(@"定时器调用了test2\n参数:%@",str);
    
}
-(void)test3_WithParam:(NSString *)str Param2:(NSString *)str2{
    
    NSLog(@"定时器调用了test3\n参数1:%@\n参数2:%@",str,str2);
    
}




/************************************/


- (IBAction)add:(id)sender {
    
    [[ZXCCycleTimer shareInstance] addQueueWithTarget:self selector:@selector(test1)];
    
}

- (IBAction)delete:(id)sender {
    
    [[ZXCCycleTimer shareInstance]removeQueueByTarget:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
