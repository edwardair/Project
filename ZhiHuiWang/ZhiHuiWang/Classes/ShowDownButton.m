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
@property (strong,nonatomic) UIView *downView;
@end

@implementation ShowDownButton
- (UIView *)downView{
    if (!_downView) {
        _downView = [[UIView alloc]init];
        [self addSubview:_downView];
        _downView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 0);
        [_downView setBackgroundColor:[UIColor blueColor]];
//        _downView.hidden = YES;
    }
    return _downView;
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

/*
#pragma mark 加载self的数据Data
-(void) buttonWithNames: (NSString *) name, ...
{
    
	va_list args;
	va_start(args,name);
    
	[self initWithNames: name vaList:args] ;
        
	va_end(args);
}
-(void) initWithNames: (NSString *) name vaList: (va_list) args
{
    NSMutableArray *array = nil;
	if( name ) {
//        [array addObject:[self initButton:name]];
        
		NSString *i = va_arg(args, NSString*);
        
		while(i) {
//			[array addObject:[self initButton:i]];
			i = va_arg(args, NSString*);
		}
	}
    
	[self initWithArray:array];
}
//- (UIButton *)initButton:(NSString *)name{
//    UIButton *b = [[UIButton alloc]init];
//    b.titleLabel.text = name;
//    return b;
//}
*/

- (void)initializeButtonData:(NSArray *)data{
    NSMutableArray *array = [NSMutableArray array];

    for (NSString *name in data) {
        int index = [data indexOfObject:name];

        UIButton *b = [[UIButton alloc]initWithFrame:CGRectMake(0, BtnWidth*index, self.frame.size.width, 0)];
        [b setBackgroundColor:[UIColor redColor]];
        [self.downView addSubview:b];

        [b setTitle:name forState:UIControlStateNormal];
        b.titleLabel.textColor = [UIColor redColor];
        b.titleLabel.transform = CGAffineTransformMake(1, 1, 1, 1, 1, 0);
        [b addTarget:self action:@selector(subviewsButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//        [b setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [array addObject:b];
    }
    
    [self addTarget:self action:@selector(superButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

//UIButton 点击方法
- (void)superButtonClicked{
    [self spreadAndStrictionAction:YES];
}
- (void)subviewsButtonClicked{
    [self spreadAndStrictionAction:NO];
}
//获取 _downView的子视图个数
- (int )subviewsNumber{
    return _downView.subviews.count;
}
//downView 的伸展 收缩动作 ss 为YES时伸展，NO时收缩
- (void)spreadAndStrictionAction:(BOOL)ss{
    int i = [self subviewsNumber];
    NSLog(@"%d",i);
    _downView.frame = CGRectMake(_downView.frame.origin.x, _downView.frame.origin.y, _downView.frame.size.width, 0);
//    [_downView setTranslatesAutoresizingMaskIntoConstraints:YES];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    _downView.hidden = NO;

//    _downView.frame = CGRectMake(_downView.frame.origin.x, _downView.frame.origin.y, _downView.frame.size.width, ss?BtnWidth*[self subviewsNumber]:0);
//    CGAffineTransform tran = CGAffineTransformScale(_downView.transform, 1, 1);
    [_downView setTransform:CGAffineTransformMake(0, 0, 0, 0, 0, 1)];
    [UIView commitAnimations];
}

//touches
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
}
@end
