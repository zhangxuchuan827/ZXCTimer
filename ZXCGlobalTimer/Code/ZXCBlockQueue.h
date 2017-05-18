//
//  ZXCBlockQueue.h
//  ZXCGlobalTimer
//
//  Created by LanTuZi on 17/2/23.
//  Copyright © 2017年 张绪川. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 循环队列对象
 */
@interface ZXCBlockQueue : NSObject



/**
 索引值
 */
@property (assign,nonatomic) NSInteger  index;


/**
 任务名
 */
@property (assign,nonatomic) NSString * name;


/**
 执行回调,(索引值)
 */
@property (nonatomic,copy) void(^callBack)(NSInteger index) ;


/**
 下次执行时间
 */
@property (nonatomic,strong) NSDate * nextRunDate;



/**
 执行时间间隔
 */
@property (nonatomic,assign) NSTimeInterval timeInteval;


@end
