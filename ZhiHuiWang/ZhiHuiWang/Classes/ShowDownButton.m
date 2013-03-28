//
//  ShowDownButton.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-3-26.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "ShowDownButton.h"
#define BtnWidth 15

@interface ShowDownButton(){
    
}
@end

@implementation ShowDownButton
- (UIScrollView *)downScrollView{
    if (!_downScrollView) {
        _downScrollView = [[UIScrollView alloc]init];
        [self.superview addSubview:_downScrollView];
        _downScrollView.frame = CGRectMake(self.frame.origin.x, self.frame.size.height+self.frame.origin.y, self.frame.size.width, 0);
        [_downScrollView setBackgroundColor:[UIColor blueColor]];
        _downScrollView.hidden = YES;
    }
    return _downScrollView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)createSubButtonWithIndex:(int )index Name:(NSString *)name{
    UIButton *b = [[UIButton alloc]initWithFrame:CGRectMake(0, BtnWidth*index, self.frame.size.width, BtnWidth)];
    [self.downScrollView addSubview:b];
    
    [b setTitle:name forState:UIControlStateNormal];

    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [b addTarget:self action:@selector(subviewsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

}
- (void)initializeButtonData:(NSMutableArray *)data{
    [self setTitle:@"--请选择--" forState:UIControlStateNormal];
    
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    [self createSubButtonWithIndex:0 Name:self.titleLabel.text];
    
    for (NSString *name in data) {
        NSLog(@"%@",name);
//        NSMutableString *s = [NSMutableString stringWithUTF8String:[name UTF8String]];
        int index = [data indexOfObject:name];
        index += 1;
        [self createSubButtonWithIndex:index Name:name];
    }
    
    self.downScrollView.frame = CGRectMake(self.downScrollView.frame.origin.x, self.downScrollView.frame.origin.y, self.downScrollView.frame.size.width, BtnWidth*(data.count+1));
    [self addTarget:self action:@selector(superButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

//UIButton 点击方法
- (void)superButtonClicked{
    if (_downScrollView.hidden) {
        [self spreadAndStrictionAction:YES];
    }
}
- (void)subviewsButtonClicked:(UIButton *)b{
    NSLog(@"%@",b.titleLabel.text);
    [self spreadAndStrictionAction:NO];

    [self setTitle:b.titleLabel.text forState:UIControlStateNormal];
}
//获取 _downView的子视图个数
- (int )subviewsNumber{
    return _downScrollView.subviews.count;
}
//downView 的伸展 收缩动作 ss 为YES时伸展，NO时收缩
- (void)spreadAndStrictionAction:(BOOL)ss{
    _downScrollView.hidden = !ss;
}


@end
