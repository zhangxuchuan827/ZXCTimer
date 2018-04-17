//
//  SecondViewController.m
//  ZXCGlobalTimer-OC
//
//  Created by zhangxuchuan on 2018/4/16.
//  Copyright © 2018年 张绪川. All rights reserved.
//

#import "SecondViewController.h"
#import "NSObject+ZXCTimer.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pushPage)];
    
    self.title = [NSString stringWithFormat:@"这是第%ld个页面",self.navigationController.viewControllers.count];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [button1 setTitle:@"test1" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(test1) forControlEvents:UIControlEventTouchUpInside];
    button1.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:button1];
    
    UIButton * button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [button2 setTitle:@"test2" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(test2) forControlEvents:UIControlEventTouchUpInside];
    button2.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2+40);
    [self.view addSubview:button2];
}

- (void)pushPage {
    
    [self.navigationController pushViewController:[[SecondViewController alloc]init] animated:YES];
}


-(void)test1{
    

    __weak typeof(self) weakSelf = self;
    
    NSInteger index = self.navigationController.viewControllers.count;
    
    [self addCycleTask:^{
        NSLog(@"[%@]当前是4秒一次的循环任务 - %ldPage",[NSThread currentThread],index);
       
       [weakSelf secondPagePrint];
        
    } timeInterval:0.44];
    
}

-(void)test2{
    NSInteger index = self.navigationController.viewControllers.count;
    [self addCycleTask:^{
        NSLog(@"[%@]当前是十秒一次的循环任务 - %ldPage",[NSThread currentThread],index);
        
        for (int i = 0; i < 1000; i ++) {
            NSLog(@"这里是在后太输出10000个数字 -- %d",i);
        }
    } timeInterval:1 threadMode:ZXCBackgroundThread];
    
}


-(void)secondPagePrint{
    
    NSURLSessionTask * task = [[NSURLSession sharedSession]dataTaskWithURL:[NSURL URLWithString:@""] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
        
    }];
    [task resume];
}


-(void)dealloc{
    
    NSLog(@"Dealloc - %@ - %@",self.class,self);
    
    [self removeSelfTasks];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
