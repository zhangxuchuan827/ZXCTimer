# ZXClTimer


## 简介

ZXCTimer是一个全局的定时计时器,能够一行代码添加定时任务或者轮询任务,并且无需人为管理,控制器退出时可直接直接kill本控制器所有的任务

## 下载&使用

1.直接将目录下'ZXCGlobalTimer'文件夹引入工程中,并且引入NSObject+ZXCTimer.h头文件



### 循环任务

```
-(ZXCCyclesQueueItem*)addCycleTask:(dispatch_block_t)callback timeInterval:(NSTimeInterval)time;
-(ZXCCyclesQueueItem*)addCycleTask:(dispatch_block_t)callback timeInterval:(NSTimeInterval)time runCount:(NSInteger)count;
-(ZXCCyclesQueueItem*)addCycleTask:(dispatch_block_t)callback timeInterval:(NSTimeInterval)time threadMode:(ZXCThreadMode)mode;
-(ZXCCyclesQueueItem*)addCycleTask:(dispatch_block_t)callback timeInterval:(NSTimeInterval)time runCount:(NSInteger)count threadMode:(ZXCThreadMode)mode;

-(void)removeCycleTask:(ZXCCyclesQueueItem*)item;
-(void)removeAllCycleTask;

```

### 定时任务

```
-(ZXCTimerQueueItem*)addTimerTask:(dispatch_block_t)callback after:(NSTimeInterval)time;
-(ZXCTimerQueueItem*)addTimerTask:(dispatch_block_t)callback after:(NSTimeInterval)time threadMode:(ZXCThreadMode)mode;

-(void)removeTimerTask:(ZXCTimerQueueItem*)item;
-(void)removeAllTimerTask;

```

### NSObject  [ dealloc 时调用]
```
-(void)removeSelfTasks;
```

### Demo

```
单例方式 可替换 self方式

------------------------------------------
[self addCycleTask:^{
		NSLog(@"【主线程】循环任务");
    } timeInterval:0.44];


[self addCycleTask:^{
        NSLog(@"【后台】循环任务");
    } timeInterval:1 threadMode:ZXCBackgroundThread];

[self addTimerTask:^{
        NSLog(@"【主线程】定时任务");
    } after:10];
    
[self addTimerTask:^{
        NSLog(@"【后台】定时任务");
    } after:10 threadMode:ZXCBackgroundThread];

```




## End
若有任何问题欢迎发留言
