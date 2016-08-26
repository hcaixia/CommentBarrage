//
//  BarrageView.h
//  CommentBarrage
//
//  Created by 黄彩霞 on 16/7/1.
//  Copyright © 2016年 HuangCaixia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarrageModel.h"

@protocol BarrageViewDelegate <NSObject>

/**
 *  长按
 **/
- (void)getLongPressModel:(BarrageModel *)model;

@end

@interface BarrageView : UIView

@property (nonatomic, assign)id <BarrageViewDelegate> delegate;

/**
 * 添加
**/
- (void)addItem:(BarrageModel *)model;

@end
