//
//  NSObject+ZXCTimer.m
//  ZXCGlobalTimer-OC
//
//  Created by zhangxuchuan on 2018/4/16.
//  Copyright © 2018年 张绪川. All rights reserved.
//

#import "NSObject+ZXCTimer.h"

@implementation NSObject (ZXCTimer)


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
    
    ZXCCyclesQueueItem * item = [[ZXCTimer shareInstance] addCycleTask:callback timeInterval:time runCount:count threadMode:mode];
    item.targetHash = [self hash];
    return item;
}
-(void)removeCycleTask:(ZXCCyclesQueueItem*)item{
    [[ZXCTimer shareInstance] removeCycleTask:item];
}
-(void)removeAllCycleTask{
    [[ZXCTimer shareInstance] removeAllCycleTask];
}




-(ZXCTimerQueueItem*)addTimerTask:(dispatch_block_t)callback after:(NSTimeInterval)time{
    return [self addTimerTask:callback after:time threadMode:ZXCMainThread];
}
-(ZXCTimerQueueItem*)addTimerTask:(dispatch_block_t)callback after:(NSTimeInterval)time threadMode:(ZXCThreadMode)mode{
    ZXCTimerQueueItem * item = [[ZXCTimer shareInstance] addTimerTask:callback after:time threadMode:mode];
    item.targetHash = [self hash];
    return item;
}

-(void)removeTimerTask:(ZXCTimerQueueItem*)item{
    [[ZXCTimer shareInstance] removeTimerTask:item];
}
-(void)removeAllTimerTask{
    [[ZXCTimer shareInstance] removeAllTimerTask];
}



-(void)removeSelfTasks{
    [[ZXCTimer shareInstance] removeTasksByTargetHash:[self hash]];
}

@end
