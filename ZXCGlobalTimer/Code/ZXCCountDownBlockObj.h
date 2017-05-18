//
//  ZXCCountDownBlockObj.h
//  ZXCGlobalTimer-OC
//
//  Created by 张绪川 on 17/2/25.
//  Copyright © 2017年 张绪川. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 定时器对象block
 */
@interface ZXCCountDownBlockObj : NSObject


/**
 索引值
 */
@property (nonatomic,assign) NSInteger index;

/**
 任务名
 */
@property (assign,nonatomic) NSString * name;

/**
 结束回调
 */
@property (nonatomic,copy) void(^endBlock)() ;


/**
 创建时间
 */
@property (nonatomic,strong) NSDate * createDate;


/**
 结束时间
 */
@property (nonatomic,strong) NSDate * endDate;



@end
