//
//  SubMenuButton.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-3-25.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "SubMenuButton.h"

@implementation SubMenuButton
+(id )initWithTitle:(NSString *)title{
    return [[self alloc]initWithTitle:title];
}
- (id )initWithTitle:(NSString *)title{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    self = [super initWithFrame:CGRectMake(0, 0, screenRect.size.width, 50)];
    if (self) {
        self.didContentUnfold = NO;
        
        [self setBackgroundColor:[UIColor colorWithRed:.3 green:.7 blue:.8 alpha:.6]];
        self.alpha = .5f;
        
        UILabel *label = [[UILabel alloc]init];
        label.text = title;
        label.textColor = [UIColor blackColor];
        label.frame = CGRectMake(0, 0, 70, 50);
        
        [self addSubview:label];

    }
    return self;
}
- (void)setDidContentUnfold:(BOOL)didContentUnfold{
    //TODO: 设置 btn 的展开状态
}
- (void)setContentView:(UIView *)contentView{
    _contentView = contentView;
    if (contentView) {
        [self addSubview:contentView];
        contentView.center = CGPointMake(contentView.center.x, self.center.y+self.frame.size.height/2+contentView.frame.size.height/2);
    }
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

@end
