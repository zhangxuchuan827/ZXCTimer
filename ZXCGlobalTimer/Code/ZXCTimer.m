//
//  ZXCCycleTimer.m
//  ZXCGlobalTimer
//
//  Created by LanTuZi on 17/2/23.
//  Copyright © 2017年 张绪川. All rights reserved.
//

#import "ZXCTimer.h"


@interface ZXCTimer ()

//随机数池
@property (atomic,strong ) NSMutableArray * randPool;
///定时任务队列
@property (atomic,strong) NSMutableDictionary * timerQueueDict;
///循环任务队列
@property (atomic,strong) NSMutableDictionary * cycleQueueDict;



@end

@implementation ZXCTimer{
    
    NSThread * _cycleThread;        //循环任务线程
    
    NSTimer * _cycleTimer;
    NSTimer * _bTimer;
    
    NSTimeInterval _timeInterval;    //轮询时间
    NSInteger _maxTaskCount;    //最大任务数量
}

#pragma mark - 单例和初始化

static ZXCTimer * shareObj = nil;

+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObj = [[ZXCTimer alloc]init];
    });
    
    return  shareObj;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _cycleQueueDict = [NSMutableDictionary new];
        _timerQueueDict = [NSMutableDictionary new];
        
        _timeInterval = 0.1;
        _maxTaskCount = 100;

        _randPool = [NSMutableArray new];
        
        for (int i = 1 ; i < _maxTaskCount; i++) {
            [_randPool addObject:@(i)];
        }
        
        _cycleThread = [[NSThread alloc]initWithTarget:self selector:@selector(initialTimer) object:nil];
        _cycleThread.name = @"ZXC-CycleQueue-thread";
        [_cycleThread start];

        
        NSLog(@"ZXCTimer install");
        
    }
    return self;
}


-(void)initialTimer{
    _cycleTimer  = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(cycleRun) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_cycleTimer forMode:NSDefaultRunLoopMode];
    _bTimer  = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_bTimer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop]run];
}

#pragma mark - 循环任务

-(void)cycleRun{
    @synchronized(self){
        [self.cycleQueueDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, ZXCCyclesQueueItem * obj, BOOL * _Nonnull stop) {
            //如果还没有到执行时间,就跳过
            NSDate * currentDate = [NSDate date];
            if (obj.isPause ||[obj.nextRunDate compare:currentDate] != NSOrderedAscending) {
                return ;
            }
            
            switch (obj.mode) {
                case ZXCMainThread:
                    [self performSelectorOnMainThread:@selector(runBlock:) withObject:obj waitUntilDone:NO];
                    break;
                    
                default:
                    [self performSelectorInBackground:@selector(runBlock:) withObject:obj];
                    break;
            }
            
            obj.nextRunDate = [[NSDate alloc] initWithTimeIntervalSinceNow:obj.timeInteval];
            
            if (obj.runCount > 0) {
                obj.runCount -= 1;
            }
            if (obj.runCount == 0) {
                [self removeCycleTask:obj];
            }
            
            
        }];
        
    }
}

-(ZXCCyclesQueueItem*)addCycleTask:(dispatch_block_t)callback timeInterval:(NSTimeInterval)time{
    return [self addCycleTask:callback timeInterval:time runCount:-1 threadMode:ZXCMainThread];
}

-(ZXCCyclesQueueItem*)addCycleTask:(dispatch_block_t)callback timeInterval:(NSTimeInterval)time runCount:(NSInteger)count{
    return [self addCycleTask:callback timeInterval:time runCount:count threadMode:ZXCMainThread];
}

-(ZXCCyclesQueueItem*)addCycleTask:(dispatch_block_t)callback timeInterval:(NSTimeInterval)time threadMode:(ZXCThreadMode)mode{
    return [self addCycleTask:callback timeInterval:time runCount:-1 threadMode:mode];
}

-(ZXCCyclesQueueItem*)addCycleTask:(dispatch_block_t)callback timeInterval:(NSTimeInterval)time runCount:(NSInteger)count threadMode:(ZXCThreadMode)mode{
    
    ZXCCyclesQueueItem * item = [ZXCCyclesQueueItem new];
    item.callBack = callback;
    item.index = [self randNumNotInIndex];
    item.timeInteval = time;
    item.nextRunDate = [[NSDate alloc] initWithTimeIntervalSinceNow:time];
    item.runCount = count;
    item.mode = mode;
    
    [self.cycleQueueDict setObject:item forKey:@(item.index)];
    [_cycleTimer setFireDate:[NSDate distantPast]];
    
    return item;
}

-(void)removeCycleTasks:(NSArray*)arr{
    if (arr == nil || arr.count == 0) {
        return;
    }
    for (ZXCCyclesQueueItem * itm in arr) {
        [self removeCycleTask:itm];
    }
}

-(void)removeCycleTask:(ZXCCyclesQueueItem *)item{
    if (item == nil) {
        return;
    }
    [self.cycleQueueDict removeObjectForKey:@(item.index)];
    [self reductionRandPoolWithIndex:item.index];
    
    if(self.cycleQueueDict.allValues.count == 0){
        [_cycleTimer setFireDate: [NSDate distantFuture]];
    }
}


-(void)removeAllCycleTask{
    [_cycleTimer setFireDate: [NSDate distantFuture]];
    NSArray * allKey = self.cycleQueueDict.allKeys;
    [self.cycleQueueDict removeAllObjects];
    for (NSNumber * num in allKey) {
        [self reductionRandPoolWithIndex:num.integerValue];
    }
}

#pragma mark - 定时任务


-(void)timerRun{
    @synchronized(self){
        [self.timerQueueDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, ZXCTimerQueueItem *  _Nonnull obj, BOOL * _Nonnull stop) {
            
            NSDate * currentDate = [NSDate date];
            if ([obj.endDate compare:currentDate] != NSOrderedAscending) {
                return ;
            }
            
            switch (obj.mode) {
                case ZXCMainThread:
                    [self performSelectorOnMainThread:@selector(runBlock:) withObject:obj waitUntilDone:NO];
                    break;
                    
                default:
                    [self performSelectorInBackground:@selector(runBlock:) withObject:obj];
                    break;
            }
            [self removeTimerTask:obj];
            
        }];
    }
}

-(ZXCTimerQueueItem*)addTimerTask:(dispatch_block_t)callback after:(NSTimeInterval)time{
    return [self addTimerTask:callback after:time threadMode:ZXCMainThread];
}

-(ZXCTimerQueueItem*)addTimerTask:(dispatch_block_t)callback after:(NSTimeInterval)time threadMode:(ZXCThreadMode)mode{
    ZXCTimerQueueItem * item = [ZXCTimerQueueItem new];
    item.createDate = [NSDate date];
    item.endDate = [[NSDate alloc] initWithTimeIntervalSinceNow:time];
    item.index = [self randNumNotInIndex];
    item.callBack = callback;
    item.mode = mode;
    
    [self.timerQueueDict setObject:item forKey:@(item.index)];
    [_bTimer setFireDate: [NSDate distantPast]];
    
    return item;
}
-(void)removeTimerTasks:(NSArray *)array{
    if (array == nil || array.count == 0) {
        return;
    }
    for (ZXCTimerQueueItem * itm in array) {
        [self removeTimerTask:itm];
    }
}
-(void)removeTimerTask:(ZXCTimerQueueItem *)item{
    if (item == nil) {
        return;
    }
    [self.timerQueueDict removeObjectForKey:@(item.index)];
    [self reductionRandPoolWithIndex:item.index];
    if (self.timerQueueDict.allValues.count == 0) {
        [_bTimer setFireDate:[NSDate distantFuture]];
    }
}

-(void)removeAllTimerTask{
    [_bTimer setFireDate:[NSDate distantFuture]];
    NSArray * allkey = self.timerQueueDict.allKeys;
    [self.timerQueueDict removeAllObjects];
    for (ZXCTimerQueueItem * itm in allkey) {
        [self reductionRandPoolWithIndex:itm.index];
    }
}


#pragma mark - 其他

-(void)removeTasksByTargetHash:(NSUInteger)hash{
    
    __weak typeof(self) weakSelf = self;
    
    [self.cycleQueueDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, ZXCCyclesQueueItem * obj, BOOL * _Nonnull stop) {
        if (obj.targetHash == hash) {
            [weakSelf removeCycleTask:obj];
        }
    }];
    
    
    [self.timerQueueDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, ZXCTimerQueueItem * obj, BOOL * _Nonnull stop) {
        if (obj.targetHash == hash) {
            [weakSelf.timerQueueDict removeObjectForKey:key];
        }
    }];
}

#pragma mark - 随机数相关

/**
 生成随机数-不与队列中的索引重复
 
 @return 不重复随机数索引
 */
-(NSInteger)randNumNotInIndex{
    
    if (self.randPool.count == 0) {
        
        for (NSInteger i = _maxTaskCount; i < _maxTaskCount + 50; i++) {
            [_randPool addObject:@(i)];
        }
        
    }
    
    NSInteger randomIndex =  arc4random()%self.randPool.count;
    
    NSNumber * index = [self.randPool objectAtIndex:randomIndex];
    
    [self.randPool removeObjectAtIndex:randomIndex];
    
    return index.integerValue;
    
}
/**
 还原随机数池的数字
 */
-(void)reductionRandPoolWithIndex:(NSInteger)index{
    
    [self.randPool addObject:@(index)];
    
}







#pragma mark - 公共方法

-(void)runBlock:(ZXCQueueItem*)item{
    
    if (item.callBack == nil) {
        [self removeTask:item];
        NSLog(@"ZXCTimer-remove:%@",item);
        return;
    }
    
    @try {
        item.callBack();
    } @catch (NSException *exception) {
        NSLog(@"ZXCTimer-ERROR:%@",exception);
        [self removeTask:item];
        NSLog(@"ZXCTimer-remove:%@",item);
    }
    
}

-(void)removeTask:(ZXCQueueItem *)item{
    
    if (item.class == ZXCTimerQueueItem.class) {
        [self removeTimerTask:(ZXCTimerQueueItem*)item];
    }
    else if (item.class == ZXCCyclesQueueItem.class) {
        [self removeCycleTask:(ZXCCyclesQueueItem*)item];
    }
}



@end
