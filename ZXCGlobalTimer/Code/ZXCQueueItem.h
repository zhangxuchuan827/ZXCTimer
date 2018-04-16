//
//  ZXCQueueItem.h
//  ZXCGlobalTimer-OC
//
//  Created by zhangxuchuan on 2018/4/12.
//  Copyright © 2018年 张绪川. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ZXCThreadMode) {
    ZXCMainThread,
    ZXCBackgroundThread,
};

@interface ZXCQueueItem : NSObject


///任务描述
@property (assign,nonatomic) NSString * name;
@property (nonatomic,copy) dispatch_block_t callBack;
@property (assign,nonatomic) NSInteger index;
@property (nonatomic,assign) ZXCThreadMode mode;

@property (nonatomic,assign) NSUInteger targetHash;

@end


/**
 循环任务Item
 */
@interface ZXCCyclesQueueItem : ZXCQueueItem

@property (nonatomic,assign) NSInteger runCount;
@property (nonatomic,strong) NSDate * nextRunDate;
@property (nonatomic,assign) NSTimeInterval timeInteval;
@property (assign,nonatomic,readonly) BOOL isPause;

-(void)pause;
-(void)begin;

@end


/**
 定时器Item
 */
@interface ZXCTimerQueueItem : ZXCQueueItem

@property (nonatomic,strong) NSDate * createDate;
@property (nonatomic,strong) NSDate * endDate;

@end
