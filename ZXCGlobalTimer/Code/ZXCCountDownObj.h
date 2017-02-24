//
//  ZXCCountDownObj.h
//  ZXCGlobalTimer
//
//  Created by LanTuZi on 17/2/23.
//  Copyright © 2017年 张绪川. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 定时器对象
 */
@interface ZXCCountDownObj : NSObject


/**
 索引值
 */
@property (nonatomic,assign) NSInteger index;


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
