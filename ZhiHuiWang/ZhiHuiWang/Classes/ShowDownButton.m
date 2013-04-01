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
@synthesize downMenus = _downMenus;
- (UIScrollView *)downScrollView{
    if (!_downScrollView) {
        _downScrollView = [[UIScrollView alloc]init];
        [self.superview addSubview:_downScrollView];
        _downScrollView.frame = CGRectMake(self.frame.origin.x, self.frame.size.height+self.frame.origin.y, self.frame.size.width, 0);
        [_downScrollView setBackgroundColor:[UIColor blueColor]];
//        _downScrollView.scrollEnabled = YES;
//        _downScrollView.bouncesZoom = YES;
//        _downScrollView.alwaysBounceVertical = YES;
        _downScrollView.hidden = YES;
    }
    return _downScrollView;
}
- (NSMutableArray *)downMenus{
    if (!_downMenus) {
        _downMenus = [[NSMutableArray alloc]init];
    }
    return _downMenus;
}
- (void)setDownMenus:(NSMutableArray *)downMenus{
    int index = 1;
    for (NSString *name in downMenus) {
        UIButton *b = [self createSubButtonWithIndex:index++ Name:name];
        [b addTarget:self action:@selector(subviewsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.downScrollView.frame = CGRectMake(self.downScrollView.frame.origin.x, self.downScrollView.frame.origin.y, self.downScrollView.frame.size.width, BtnWidth*(downMenus.count+1));

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

- (UIButton *)createSubButtonWithIndex:(int )index Name:(NSString *)name{
    UIButton *b = [[UIButton alloc]initWithFrame:CGRectMake(0, BtnWidth*index, self.frame.size.width, BtnWidth)];
    [self.downScrollView addSubview:b];
    
    b.tag = index-1;
    [b setTitle:name forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    return b;
}
- (void)initializeButton{
    //如果 self 存在子节点 删掉 重新加载
    for (UIView *sub in self.downScrollView.subviews) {
//        if ([sub isKindOfClass:[UIButton class]]) {
            [sub removeFromSuperview];
//        }
    }
    self.meetingId = 0;
    
    [self setTitle:@"--请选择--" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
   UIButton *nonData = [self createSubButtonWithIndex:0 Name:self.titleLabel.text];
    [nonData addTarget:self action:@selector(subviewsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addTarget:self action:@selector(superButtonClicked) forControlEvents:UIControlEventTouchUpInside];

}

//UIButton 点击方法
- (void)superButtonClicked{
    if (_downScrollView.hidden) {
        [self spreadAndStrictionAction:YES];
    }
}
- (void)subviewsButtonClicked:(UIButton *)b{
    //加入  meetingId 为 0 或 1 时 会议必填项为空 创建不成功
    self.meetingId = b.tag;
    NSLog(@"%d",b.tag);

    [self spreadAndStrictionAction:NO];

    [self setTitle:b.titleLabel.text forState:UIControlStateNormal];
    
    if (_delegate && [_delegate respondsToSelector:_selector]) {
        [_delegate performSelector:_selector withObject:b];
    }
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
