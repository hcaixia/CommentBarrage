//
//  BarrageView.m
//  CommentBarrage
//
//  Created by 黄彩霞 on 16/7/1.
//  Copyright © 2016年 HuangCaixia. All rights reserved.
//

#import "BarrageView.h"
#import "YYWebImage.h"

#define mScreenWidth  ([UIScreen mainScreen].bounds.size.width)
#define mScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define _headerMinHt 35 //头像高度
#define cellFont 13 //cell字体

#pragma mark - tableViewCell

@interface BarrageCell : UITableViewCell

@property (nonatomic, strong)UIView * bgView;
@property (nonatomic, strong)UIImageView * headerView;
@property (nonatomic, strong)UIButton * textView;
@property (nonatomic, assign)CGFloat bgviewMaxHt;
@property (nonatomic, strong)BarrageModel * model;

@property (nonatomic, strong)void(^ barrageCellBlock)(BarrageModel *model);

- (void)reloadData:(BarrageModel *)model;

@end

@implementation BarrageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _bgviewMaxHt = 100;
        [self createView];
        self.backgroundColor = [UIColor clearColor];

    }
    
    return self;
}

//TODO:创建单个视图
- (void)createView
{
    CGSize headerSize = CGSizeMake(_headerMinHt, _headerMinHt);
    CGFloat gap = 10;
    UIFont * textFont = [UIFont systemFontOfSize:cellFont];
    CGSize contentSize = CGSizeMake(0, 0);
    contentSize.width += 10;
    
    //
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _bgView.layer.cornerRadius = _bgView.frame.size.height/2;
    _bgView.layer.masksToBounds = YES;
    [self addSubview:_bgView];
    
    //
    _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, headerSize.width, headerSize.height)];
    _headerView.layer.cornerRadius = headerSize.width/2;
    _headerView.layer.masksToBounds = YES;
    _headerView.contentMode = UIViewContentModeScaleAspectFill;
    _headerView.clipsToBounds = YES;
    [_bgView addSubview:_headerView];
    
    //
    _textView = [[UIButton alloc] initWithFrame:CGRectMake(_headerView.bounds.size.width + _headerView.frame.origin.x + gap, 0, contentSize.width, _bgView.bounds.size.height)];
    _textView.userInteractionEnabled = NO;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.titleLabel.font = textFont;
    _textView.titleLabel.textColor = [UIColor whiteColor];
    _textView.titleLabel.textAlignment = NSTextAlignmentLeft;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.titleLabel.numberOfLines = 0;
    [_bgView addSubview:_textView];
    
    _textView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

    UILongPressGestureRecognizer * longpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [_bgView addGestureRecognizer:longpgr];
}

//TODO:长按手势
- (void)longPressAction:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        _barrageCellBlock(self.model);
    }
}
//TODO:刷新数据
- (void)reloadData:(BarrageModel *)model
{
    _model = model;
    
    CGFloat gap = 10;
    UIFont * textFont = [UIFont systemFontOfSize:cellFont];
    CGSize contentSize = [self sizeWithString:model.Content Font:textFont Size:CGSizeMake(mScreenWidth - 40 - _headerMinHt, MAXFLOAT)];
    contentSize.width += 20;
    CGFloat bgWidth = _headerMinHt + contentSize.width > mScreenWidth - 10 ? mScreenWidth - 10 :  _headerMinHt + gap + contentSize.width;
    CGFloat bgHt = contentSize.height + 20 <  _headerMinHt ?  _headerMinHt : contentSize.height + 20;
    CGFloat bgx = mScreenWidth - bgWidth - 5 < 0 ? 0 : mScreenWidth - bgWidth - 5;
    //
    _bgView.frame = CGRectMake(bgx, 0, bgWidth, bgHt);
    _bgView.layer.cornerRadius = _bgView.frame.size.height/2;
    _bgView.layer.masksToBounds = YES;
    model.rowHeigt = bgHt;
    

    //
    if (bgHt >= _bgviewMaxHt){
        
        CGRect frame = _headerView.frame;
        frame.size = CGSizeMake(35, bgHt);
        _headerView.frame = frame;
        
        _headerView.layer.cornerRadius = 0;
        _headerView.layer.masksToBounds = YES;
        
        _bgView.layer.cornerRadius = 0;
        _bgView.layer.masksToBounds = YES;
        
    }else if (bgHt > _headerMinHt) {
        CGRect frame = _headerView.frame;
        frame.size = CGSizeMake(bgHt, bgHt);
        _headerView.frame = frame;
        
        _headerView.layer.cornerRadius = _headerView.bounds.size.width/2;
        _headerView.layer.masksToBounds = YES;
        
        _bgView.layer.cornerRadius = _bgView.bounds.size.height/2;
        _bgView.layer.masksToBounds = YES;
        
    }else {
        CGRect frame = _headerView.frame;
        frame.size = CGSizeMake(_headerMinHt, _headerMinHt);
        _headerView.frame = frame;
        
        _headerView.layer.cornerRadius = _headerView.bounds.size.width/2;
        _headerView.layer.masksToBounds = YES;
        
        _bgView.layer.cornerRadius = _bgView.bounds.size.height/2;
        _bgView.layer.masksToBounds = YES;
    }
   
    [_headerView yy_setImageWithURL:[NSURL URLWithString:model.photo] placeholder:nil];
    
    
    //
    _textView.frame = CGRectMake(_headerView.bounds.size.width + _headerView.frame.origin.x + gap, 0, _bgView.bounds.size.width - _headerView.bounds.size.width - _headerView.frame.origin.x - gap * 2, _bgView.bounds.size.height);
    [_textView setTitle:model.Content forState:UIControlStateNormal];
//    _textView.text = model.Content;
    
}

//TODO:计算字符串的size
- (CGSize)sizeWithString:(NSString *)string Font:(UIFont *)font Size:(CGSize)Size
{
    CGSize expectedLabelSize = CGSizeZero;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        expectedLabelSize = [string boundingRectWithSize:Size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
        
    }else{
        expectedLabelSize = [string sizeWithFont:font constrainedToSize:Size lineBreakMode:NSLineBreakByCharWrapping];
    }
    return expectedLabelSize;
}

@end


#pragma mark -BarrageView
@interface BarrageView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, assign)NSTimeInterval timeInterval;
@property (nonatomic, strong)NSTimer * timer;

@end

@implementation BarrageView

//TODO:初始化
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createTableView];
        
        self.backgroundColor = [UIColor clearColor];
        _dataArray = [[NSMutableArray alloc] init];
        BarrageModel * md = [[BarrageModel alloc] init];
        md.rowHeigt = 0;
        md.ID = -1;
        [_dataArray addObject:md];
        
        self.hidden = YES;
        self.alpha = 0;
    }
    
    return self;
}

//TODO:添加
- (void)addItem:(BarrageModel *)model
{
    UIFont * textFont = [UIFont systemFontOfSize:cellFont];
    CGSize contentSize = [self sizeWithString:model.Content Font:textFont Size:CGSizeMake(mScreenWidth - 40 - _headerMinHt, MAXFLOAT)];
    contentSize.width += 20;
    CGFloat bgHt = contentSize.height + 20 <  _headerMinHt ?  _headerMinHt : contentSize.height + 20;
    model.rowHeigt = bgHt;
    //
    
    [_dataArray insertObject:model atIndex:_dataArray.count - 1];
    [_tableView reloadData];

    [_tableView beginUpdates];
    
    NSIndexPath * indexpath2 = [NSIndexPath indexPathForRow:_dataArray.count - 1 inSection:0];
    [_tableView scrollToRowAtIndexPath:indexpath2 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    [_tableView endUpdates];
    
    self.alpha = 1;
    self.hidden = NO;
    _timeInterval = 5;
    _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

#pragma mark - tableView
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BarrageModel * model = _dataArray[indexPath.row];
    if (model.ID == -1) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SpaceCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SpaceCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];

        }
        
        return cell;
    }
    BarrageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[BarrageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.barrageCellBlock = ^(BarrageModel *model){
        if (_delegate && [_delegate respondsToSelector:@selector(getLongPressModel:)]) {
            [_delegate getLongPressModel:model];
        }
    };
    [cell reloadData:model];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BarrageModel * model = _dataArray[indexPath.row];
    return model.rowHeigt + 10;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.alpha = 1;
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    _timeInterval = 5;
    _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

#pragma mark - NSTimer
- (void)timerAction:(NSTimer *)timer
{
    if (self.alpha <= 0) {
        
        self.hidden = YES;
        [_timer invalidate];
        _timer = nil;
        
        [timer invalidate];
        timer = nil;
        
        return;
    }
    _timeInterval --;
    if (_timeInterval <= 0) {
        self.alpha -= 0.4;
        if (self.alpha < 0) {
            self.alpha = 0;
        }
    }
}

//TODO:计算字符串的size
- (CGSize)sizeWithString:(NSString *)string Font:(UIFont *)font Size:(CGSize)Size
{
    CGSize expectedLabelSize = CGSizeZero;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        expectedLabelSize = [string boundingRectWithSize:Size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
        
    }else{
        expectedLabelSize = [string sizeWithFont:font constrainedToSize:Size lineBreakMode:NSLineBreakByCharWrapping];
    }
    return expectedLabelSize;
}

@end



