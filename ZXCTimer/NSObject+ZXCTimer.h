//
//  NSObject+ZXCTimer.h
//  ZXCGlobalTimer-OC
//
//  Created by zhangxuchuan on 2018/4/16.
//  Copyright © 2018年 张绪川. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXCTimer.h"

@interface NSObject (ZXCTimer)

#pragma mark - 循环任务

-(ZXCCyclesQueueItem*)addCycleTask:(dispatch_block_t)callback timeInterval:(NSTimeInterval)time;
-(ZXCCyclesQueueItem*)addCycleTask:(dispatch_block_t)callback timeInterval:(NSTimeInterval)time runCount:(NSInteger)count;
-(ZXCCyclesQueueItem*)addCycleTask:(dispatch_block_t)callback timeInterval:(NSTimeInterval)time threadMode:(ZXCThreadMode)mode;
-(ZXCCyclesQueueItem*)addCycleTask:(dispatch_block_t)callback timeInterval:(NSTimeInterval)time runCount:(NSInteger)count threadMode:(ZXCThreadMode)mode;

-(void)removeCycleTask:(ZXCCyclesQueueItem*)item;
-(void)removeAllCycleTask;


#pragma mark - 定时任务

-(ZXCTimerQueueItem*)addTimerTask:(dispatch_block_t)callback after:(NSTimeInterval)time;
-(ZXCTimerQueueItem*)addTimerTask:(dispatch_block_t)callback after:(NSTimeInterval)time threadMode:(ZXCThreadMode)mode;

-(void)removeTimerTask:(ZXCTimerQueueItem*)item;
-(void)removeAllTimerTask;


#pragma mark - 统一

-(void)removeSelfTasks;

@end
