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
- (void )initWithArray:(NSMutableArray *)array{
    for (UIButton *b in array) {
        [self.downView addSubview:b];
        
        int index = [array indexOfObject:b];
        b.frame = CGRectMake(0, self.frame.size.height+BtnWidth*index, self.frame.size.width, BtnWidth);
        [b addTarget:self action:@selector(subviewsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    }
}
- (UIButton *)initButton:(NSString *)name{
    UIButton *b = [[UIButton alloc]init];
    b.titleLabel.text = name;
    return b;
}
- (UIButton *)initf:(NSString *)x{
    UIButton *b = [[UIButton alloc]init];
    return b;
}
- (void)initializeButtonData:(NSArray *)data{
    NSMutableArray *array = [NSMutableArray array];

    for (NSString *name in data) {
        UIButton *b = [[UIButton alloc]init];
        b.titleLabel.text = name;
        
        [array addObject:b];
    }
    
    [self initWithArray:array];
    
    [self addTarget:self action:@selector(superButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

//UIButton 点击方法
- (void)superButtonClicked{
    [self spreadAndStrictionAction:YES];
}
- (void)subviewsButtonClicked:(UIButton *)button{
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
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.f];
    _downView.frame = CGRectMake(_downView.frame.origin.x, _downView.frame.origin.y, _downView.frame.size.width, ss?BtnWidth*[self subviewsNumber]:0);
    [UIView commitAnimations];
}
@end
