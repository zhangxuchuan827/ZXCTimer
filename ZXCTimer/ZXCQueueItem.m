//
//  ZXCQueueItem.m
//  ZXCGlobalTimer-OC
//
//  Created by zhangxuchuan on 2018/4/12.
//  Copyright © 2018年 张绪川. All rights reserved.
//

#import "ZXCQueueItem.h"

@implementation ZXCQueueItem


-(NSString *)description{
    return [NSString stringWithFormat:@"%@,index:%ld,name:%@",NSStringFromClass(self.class),(long)self.index,self.name];
}


@end

@implementation ZXCCyclesQueueItem

-(void)pause{
    _isPause = YES;
}
-(void)begin{
    _isPause = NO;
}


@end

@implementation ZXCTimerQueueItem


@end
