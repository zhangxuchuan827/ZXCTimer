# ZXCGlobalTimer

###简介

ZXCGlobalTimer是一个全局的定时计时器,能够一行代码添加定时任务或者轮询任务,并且无需人为管理,控制器或者方法失效时,任务即失效

###下载&使用

1.直接将目录下'ZXCGlobalTimer'文件夹引入工程中,并且引入ZXCGlobalTimer.h头文件

2.使用CocoaPods:Pod 'ZXCGlobalTimer'


###方法
```
//---循环任务

1.使用方法:单例调用
+(instancetype)shareInstance;

2.添加事件到轮询队列(返回值是任务索引值)

-(NSInteger)addQueueWithTarget:(id)target selector:(SEL)selector;

-(NSInteger)addQueueWithBlock:(void(^)(NSInteger queueId))calBack;

3.移除本控制器的所有事件(仅target-Selecter事件)
-(void)removeQueueByTarget:(id)target;

4.通过索引值移除事件(慎用)
-(void)removeByIndex:(NSInteger)index;


```

```
//---定时任务

1.添加一个定时任务(block)
-(NSInteger)addCountDownWithTimeInterval:(NSTimeInterval)timeInterval endBlock:(void(^)())endBlock;

2.取消一个定时任务(参数:任务索引值)
-(void)cancelCountDownWithIndex:(NSInteger)index;

3.取消所有定时任务
-(void)removeAllCountDownTask;

```



###Demo


```

    //添加轮询队列
    
    NSInteger index = [[ZXCCycleTimer shareInstance] addQueueWithTarget:self selector:@selector(test1)];
    
    [[ZXCCycleTimer shareInstance] addQueueWithBlock:^(NSInteger queueId) {
        
        NSLog(@"定时器调用了block,当前索引值:%ld",queueId);
        
    }];
    
    //移除定时器
    [[ZXCCycleTimer shareInstance]removeByIndex:index];
    
    [[ZXCCycleTimer shareInstance]removeQueueByTarget:self];
    
    
    //定时器调用
    
    
    NSInteger index2 = [[ZXCCycleTimer shareInstance] addCountDownWithTimeInterval:10 endBlock:^() {
    
        NSLog(@"十秒钟吼执行了这个时间");
        
    }];
    
    //取消该任务
    [[ZXCCycleTimer shareInstance]cancelCountDownWithIndex:index2];
    
    [[ZXCCycleTimer shareInstance]cancelAllCountDownTask];
    


```




##End
若有任何问题欢迎发送邮件指正:[zhangxuchuan827@163.com](mailto:zhangxuchuan827@163.com)
