//
//  ZXCCycleTimer.h
//  ZXCGlobalTimer
//
//  Created by LanTuZi on 17/2/23.
//  Copyright © 2017年 张绪川. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 定时计时器类
 */
@interface ZXCCycleTimer : NSObject


+(instancetype)shareInstance;



#pragma mark - 循环任务

/**
 添加事件到轮询队列//时间间隔1秒
 
 @param target 控制器
 @param selector 执行方法
 @return 队列索引值
 */
-(NSInteger)addQueueWithTarget:(id)target selector:(SEL)selector;

/**
 添加事件到轮询队列
 
 @param timeinteval 时间间隔
 @param target 控制器
 @param selector 执行方法
 @return 队列索引值
 */
-(NSInteger)addQueueWithTimeInterval:(NSTimeInterval)timeinteval Target:(id)target selector:(SEL)selector;


/**
 添加回调到轮询队列(block将在主线程中执行)//时间间隔1秒
 
 @param calBack 轮询回调
 @return 索引值
 */
-(NSInteger)addQueueWithBlock:(void(^)(NSInteger queueId))calBack;

/**
 添加回调到轮询队列(block将在主线程中执行)
 
 @param timeinteval 时间间隔
 @param calBack 轮询回调
 @return 索引值
 */
-(NSInteger)addQueueWithTimeInterval:(NSTimeInterval)timeinteval Block:(void(^)(NSInteger queueId))calBack;


/**
 移除本控制器的所有事件(仅targetDo事件)
 
 @param target 控制器
 */
-(void)removeQueueByTarget:(id)target;



/**
 通过索引值移除事件(慎用)
 
 @param index 事件索引值
 */
-(void)removeByIndex:(NSInteger)index;


#pragma mark - 定时任务



/**
 添加一个定时任务(block)

 @param timeInterval 定时时长
 @param endBlock 结束回调(主线程中执行)
 @return 定时任务索引值
 */
-(NSInteger)addCountDownWithTimeInterval:(NSTimeInterval)timeInterval endBlock:(void(^)())endBlock;


/**
 取消一个定时任务

 @param index 任务索引值
 */
-(void)cancelCountDownWithIndex:(NSInteger)index;


/**
 取消所有定时任务
 */
-(void)cancelAllCountDownTask;



@end
