//
//  ZXCCycleTimer.h
//  ZXCGlobalTimer
//
//  Created by LanTuZi on 17/2/23.
//  Copyright © 2017年 张绪川. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXCQueueItem.h"


@interface ZXCTimer : NSObject


+(instancetype)shareInstance;

#pragma mark - 循环任务

-(ZXCCyclesQueueItem*)addCycleTask:(dispatch_block_t)callback timeInterval:(NSTimeInterval)time;

-(ZXCCyclesQueueItem*)addCycleTask:(dispatch_block_t)callback timeInterval:(NSTimeInterval)time runCount:(NSInteger)count;

-(ZXCCyclesQueueItem*)addCycleTask:(dispatch_block_t)callback timeInterval:(NSTimeInterval)time threadMode:(ZXCThreadMode)mode;

/**
 添加循环任务

 @param callback callback description
 @param time 时间间隔
 @param count 循环次数（若一直循环输入-1）
 @param mode 执行线程（默认为当前线程）
 @return return value description
 */
-(ZXCCyclesQueueItem*)addCycleTask:(dispatch_block_t)callback timeInterval:(NSTimeInterval)time runCount:(NSInteger)count threadMode:(ZXCThreadMode)mode;


-(void)removeCycleTask:(ZXCCyclesQueueItem*)item;

-(void)removeAllCycleTask;

#pragma mark - 定时任务

-(ZXCTimerQueueItem*)addTimerTask:(dispatch_block_t)callback after:(NSTimeInterval)time;

/**
 添加定时任务

 @param callback callback description
 @param time 延迟时间
 @param mode 执行线程（默认为当前线程）
 @return return value description
 */
-(ZXCTimerQueueItem*)addTimerTask:(dispatch_block_t)callback after:(NSTimeInterval)time threadMode:(ZXCThreadMode)mode;

-(void)removeTimerTask:(ZXCTimerQueueItem*)item;

-(void)removeAllTimerTask;




#pragma mark - 其他

/**
 @param hash [self hash]
 */
-(void)removeTasksByTargetHash:(NSUInteger)hash;



@end
