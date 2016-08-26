//
//  BarrageModel.h
//  CommentBarrage
//
//  Created by 黄彩霞 on 16/7/1.
//  Copyright © 2016年 HuangCaixia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarrageModel : NSObject

@property (nonatomic, assign)NSInteger ID; //ID -1代表空格占位
@property (nonatomic, copy)NSString * Content; //内容
@property (nonatomic, copy)NSString * photo; //头像
@property (nonatomic, assign)float rowHeigt; //高度

@end
