//
//  ViewController.m
//  Demo-OC
//
//  Created by LanTuZi on 17/2/23.
//  Copyright © 2017年 张绪川. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "ZXCTimer.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *timeTF;
@property (weak, nonatomic) IBOutlet UITextField *contentTF;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pushPage)];

    [self.view endEditing:YES];
}

-(void)pushPage{
    
    [self.navigationController pushViewController:[[SecondViewController alloc]init] animated:YES];
}

/************************************/


- (IBAction)addTimer:(id)sender {
    
    if (self.timeTF.text.length == 0 || self.contentTF.text.length == 0) {
        return;
    }
    
    NSString * content = self.contentTF.text.mutableCopy;
    
    [[ZXCTimer shareInstance] addTimerTask:^{
        NSLog(@"循环任务:%@",content);
    } after:self.timeTF.text.floatValue threadMode:ZXCBackgroundThread];
    
    self.timeTF.text = @"";
    self.contentTF.text = @"";
    
}


- (IBAction)addCycle:(id)sender {
    if (self.timeTF.text.length == 0 || self.contentTF.text.length == 0) {
        return;
    }

    NSString * content = self.contentTF.text.mutableCopy;
    [[ZXCTimer shareInstance]addCycleTask:^{
        NSLog(@"定时任务:%@",content);
        
    } timeInterval:self.timeTF.text.floatValue];
    
    self.timeTF.text = @"";
    self.contentTF.text = @"";
}



- (IBAction)deleteAll:(id)sender {

    
    [[ZXCTimer shareInstance] removeAllCycleTask];
    [[ZXCTimer shareInstance] removeAllTimerTask];
}


-(void)dealloc{
    
    NSLog(@"Dealloc - %@",self.class);
}

@end
