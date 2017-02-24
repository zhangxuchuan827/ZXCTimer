//
//  ZXCCycleTimer.m
//  ZXCGlobalTimer
//
//  Created by LanTuZi on 17/2/23.
//  Copyright © 2017年 张绪川. All rights reserved.
//

#import "ZXCCycleTimer.h"

#import "ZXCQueue.h"
#import "ZXCBlockQueue.h"

#import "ZXCCountDownObj.h"

@interface ZXCCycleTimer ()

//随机数池
@property (nonatomic,strong) NSMutableArray * randPool;

//定时任务队列
@property (nonatomic,strong) NSMutableDictionary * countingQueueDict;

//循环任务队列
@property (nonatomic,strong) NSMutableDictionary * cycleQueueDict;


@end

@implementation ZXCCycleTimer{
    
    //线程
    NSThread * _aThread;
    
    //轮询时间
    NSInteger _timeInterval;
    
    //计时器
    NSTimer * _timer;
    
    
    
}

#pragma mark - 单例和初始化

static ZXCCycleTimer * shareObj = nil;

+(instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        shareObj = [[ZXCCycleTimer alloc]init];
        
    });
    
    return  shareObj;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _aThread = [[NSThread alloc]initWithTarget:self selector:@selector(initial) object:nil];
        
        _aThread.name = @"ZXC-CycleTimer-thread";
        
        [_aThread start];
        
    }
    return self;
}

-(void)initial{
    
    //循环时间
    _timeInterval = 1;
    
    //初始化定时器
    
    _timer  = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    
    [[NSRunLoop currentRunLoop]run];
}




/**
 定时器循环事件
 */
-(void)timerRun{
    
    [self run_cycle];
    
    [self run_counting];
    
    

}


-(NSMutableArray*)randPool{
    
    if (_randPool == nil) {
        
        _randPool  = [[NSMutableArray alloc]init];
        
        for (int i = 1 ; i < 500; i++) {
            [_randPool addObject:@(i)];
        }
    }
    
    return _randPool;
}
-(NSMutableDictionary*)cycleQueueDict{
    
    if (_cycleQueueDict == nil) {
        
        _cycleQueueDict  = [[NSMutableDictionary alloc]init];
        
    }
    
    return _cycleQueueDict;
}

-(NSMutableDictionary*)countingQueueDict{
    
    if (_countingQueueDict == nil) {
        
        _countingQueueDict  = [[NSMutableDictionary alloc]init];
        
    }
    
    return _countingQueueDict;
}



#pragma mark - 循环任务


-(void)run_cycle{
    
    //轮询队列,若是ZXCQueue类型则执行TargetDo,若是ZXCBlockQueue类型则执行queue.callBack
    [self.cycleQueueDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[ZXCQueue class]] ) {
            
            ZXCQueue * queue = obj;
            
            if ([queue.target respondsToSelector:queue.selector]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [queue.target performSelector:queue.selector withObject:queue.param1 withObject:queue.param2];
                    
                });
                
            }else{
                
                [self.cycleQueueDict removeObjectForKey:key];
                
                [self reductionRandPoolWithIndex:queue.index];
            }
            
            
        }
        else if ([obj isKindOfClass:[ZXCBlockQueue class]]){
            
            ZXCBlockQueue * queue = obj;
            
            if (queue.callBack) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    queue.callBack(queue.index);
                });
                
                
                
            }else{
                
                [self.cycleQueueDict removeObjectForKey:key];
                
                [self reductionRandPoolWithIndex:queue.index];
            }
            
        }
        
        
    }];

    
}

-(NSInteger)addQueueWithTarget:(id)target selector:(SEL)selector{
    
    return [self addQueueWithTarget:target selector:selector withParam1:nil Param2:nil];
    
}
-(NSInteger)addQueueWithTarget:(id)target selector:(SEL)selector withParam:(id)obj{

    return [self addQueueWithTarget:target selector:selector withParam1:obj Param2:nil];
    
}
-(NSInteger)addQueueWithTarget:(id)target selector:(SEL)selector withParam1:(id)obj1 Param2:(id)obj2{

    NSAssert(target, @"执行主体不能为空");
    NSAssert(selector , @"事件不能为空");
    
    //除重-用于避免重复添加相同事件
    
    __block NSInteger havedIndex = 0;
    
    __block BOOL isHaved = NO;
    
    [self.cycleQueueDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[ZXCQueue class]]) {
            
            ZXCQueue * inQueue = obj;
            
            if (inQueue.selector == selector &&
                inQueue.target   == target   &&
                inQueue.param1   == obj1     &&
                inQueue.param2   == obj2) {
                
                havedIndex = inQueue.index;
                
                isHaved = YES;
                
                return ;
                
            }
            
        }
        
    }];
    
    if (isHaved) {
        
        return havedIndex;
        
    }
    
    __weak typeof(self) weakTarget = target;
    
    NSInteger index = [self randNumNotInIndex];
    
    ZXCQueue * queue = [ZXCQueue new];
    
    queue.index = index;
    
    queue.selector = selector;
    
    queue.target = weakTarget;
    
    queue.param1 = obj1;
    
    queue.param2 = obj2;

    
    [self.cycleQueueDict setObject:queue forKey:@(index)];
    
    return index;
    
}

-(NSInteger)addQueueWithBlock:(void(^)(NSInteger queueId))calBack{
    
    //添加
    NSInteger index = [self randNumNotInIndex];
    
    
    ZXCBlockQueue * queue = [ZXCBlockQueue new];
    
    queue.index = index;
    
    queue.callBack = calBack;
    
    
    [self.cycleQueueDict setObject:queue forKey:@(index)];
    
    return index;
    
}
-(void)removeQueueByTarget:(id)target{
    
    __weak typeof(target) weakTarget = target;
    
    [self.cycleQueueDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[ZXCQueue class]]) {
            
            ZXCQueue * queue = obj;
            
            if ([queue.target isEqual:weakTarget]) {
                
                [self.cycleQueueDict removeObjectForKey:@(queue.index)];
                
                [self reductionRandPoolWithIndex:queue.index];
                
            }
            
        }
        
        
        
    }];
    
    
}
-(void)removeByIndex:(NSInteger)index{
    
    if (index == 0) {
        return;
    }
    
    [self.cycleQueueDict removeObjectForKey:@(index)];
    
    [self reductionRandPoolWithIndex:index];
    
}


#pragma mark - 定时任务

-(void)run_counting{
    
    __block NSMutableArray * needCancalKey = [NSMutableArray new];
    
    [self.countingQueueDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        ZXCCountDownObj * coutting = obj;
        
        //判断如果block失效,取消任务
        if(coutting.endBlock){
            
            [needCancalKey addObject:key];
            
            return ;
        }
        
        //判断如果当前的时间大于或等于结束时间
        
        NSDate * currentDate = [NSDate date];
        NSDate * endDate = coutting.endDate;
        //判断时间
        if([currentDate compare:endDate] == NSOrderedSame || [currentDate compare:endDate] == NSOrderedDescending){
            
            //执行目标的block
            if (coutting.endBlock) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    coutting.endBlock();
                    
                });
                
            }
            
            //添加到待取消任务数组--无论执行成功与否,到时就取消
            
            [needCancalKey addObject:key];
            
            
        }
        
        
        
        
        
    }];
    
    
    for (NSString * key in needCancalKey) {
        
        [self cancelCountDownWithIndex:[key integerValue]];
        
        
    }
    
}

-(NSInteger)addCountDownWithTimeInterval:(NSTimeInterval)timeInterval endBlock:(void(^)())endBlock{
    
    NSInteger index = [self randNumNotInIndex];
    
    ZXCCountDownObj * obj = [ZXCCountDownObj new];
    
    obj.createDate = [NSDate date];
    
    obj.endDate = [[NSDate alloc]initWithTimeIntervalSinceNow:timeInterval];
    
    obj.index = index;
    
    obj.endBlock = endBlock;
    
    [self.countingQueueDict setObject:obj forKey:@(index)];
    
    return index;
    
}

-(void)cancelCountDownWithIndex:(NSInteger)index{
    
    BOOL result = [self.countingQueueDict.allKeys containsObject:@(index)];
    
    if (result) {
        
        [self.countingQueueDict removeObjectForKey:@(index)];
        
        [self reductionRandPoolWithIndex:index];
        
    }
    
}



#pragma mark - 随机数相关

/**
 生成随机数-不与队列中的索引重复
 
 @return 不重复随机数索引
 */
-(NSInteger)randNumNotInIndex{
    
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






@end
