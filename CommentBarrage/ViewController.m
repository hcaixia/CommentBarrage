//
//  ViewController.m
//  CommentBarrage
//
//  Created by 黄彩霞 on 16/7/1.
//  Copyright © 2016年 HuangCaixia. All rights reserved.
//

#import "ViewController.h"
#import "BarrageView.h"


#define mScreenWidth  ([UIScreen mainScreen].bounds.size.width)
#define mScreenHeight ([UIScreen mainScreen].bounds.size.height)


@interface ViewController ()<UITextFieldDelegate, BarrageViewDelegate>

@property (nonatomic, strong)IBOutlet UITextField * sendTextField;
@property (nonatomic, strong)BarrageView * barrageView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _barrageView = [[BarrageView alloc] initWithFrame:CGRectMake(0, 100, mScreenWidth, 40 * 4)];
    _barrageView.delegate = self;
    [self.view addSubview:_barrageView];
    
    _sendTextField.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BarrageViewDelegate
- (void)getLongPressModel:(BarrageModel *)model
{
    
}

#pragma mark - textField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BarrageModel * md = [[BarrageModel alloc] init];
    md.Content = textField.text;
    md.photo = @"http://pic.58pic.com/58pic/14/00/69/66858PICNfJ_1024.jpg";
    [_barrageView addItem:md];
    
    textField.text = @"";
    
    return YES;
}


@end
