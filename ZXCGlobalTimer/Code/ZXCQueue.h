//
//  ZXCQueue.h
//  ZXCGlobalTimer
//
//  Created by LanTuZi on 17/2/23.
//  Copyright © 2017年 张绪川. All rights reserved.
//

#import <Foundation/Foundation.h>



/**
 循环队列对象
 */
@interface ZXCQueue : NSObject


/**
 执行者
 */
@property (weak,nonatomic) id  target;


/**
 选择器
 */
@property (assign,nonatomic) SEL  selector;


/**
 索引值
 */
@property (assign,nonatomic) NSInteger  index;




/**
 下次执行时间
 */
@property (nonatomic,strong) NSDate * nextRunDate;


/**
 执行时间间隔
 */
@property (nonatomic,assign) NSTimeInterval timeInteval;



@end
