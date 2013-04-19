//
//  CheckBoxView.m
//  WorkPlace
//
//  Created by BlackApple on 13-4-19.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "CheckBoxView.h"
#import "CommonMethod.h"
#define EdgeDistance 5.f
#define EmptyLength 10.f
#define DefaultFontSize 18.f
#define SelfViewHeight 30.f
#define UNSELECTED @"_UnSelected"
#define SELECTED @"_Selected"

#define DefaultTypePNG @"DefaultTypePNG"

@implementation CheckBoxView
+(id )initWithFrame:(CGRect)frame type:(UICheckBoxType )type{
    CheckBoxView *box = [[[self alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, SelfViewHeight)] autorelease];
    box.type = type;
    return box;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.backgroundColor = [UIColor clearColor];
//        _boxSelected = NO;
    }
    return self;
}
//初始化boxView
- (UIImageView *)boxView{
    if (!_boxView) {
        //默认第一次初始化 设置背景透明 ／／在这里写而不是在init里面写是由于如果是使用xib加载的话init不会走
        self.backgroundColor = [UIColor clearColor];
        _boxSelected = NO;

        _boxView = [[UIImageView alloc]initWithFrame:CGRectMake(EdgeDistance, SelfViewHeight/2-20.0f/2, 20, 20)];
        [self addSubview:_boxView];
    }
    return _boxView;
}
//初始化textLabel
- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SelfViewHeight, SelfViewHeight)];
//        [_textLabel setTextColor:[UIColor redColor]];
        //默认字体大小
        [_textLabel setFont:[UIFont systemFontOfSize:DefaultFontSize]];
        [self addSubview:_textLabel];
    }
    return _textLabel;
}
//设置boxSelected状态
- (void)setBoxSelected:(BOOL)boxSelected{
    NSString *imageName = boxSelected?pngSelectedFileName(_type):pngUnSelectedFileName(_type);
    self.boxView.image = [UIImage imageNamed:imageName];
    self.boxView.highlightedImage = [UIImage imageNamed:imageName];
    _boxSelected = boxSelected;
}
- (void)setText:(NSString *)text{
    self.textLabel.text = text;
//    _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [_textLabel setTextColor:[UIColor redColor]];
    //默认字体大小
    [_textLabel setFont:[UIFont systemFontOfSize:DefaultFontSize]];
    [self autoSizeFrame];
}
//根据UICheckBoxType 返回相对应的图片名称
NSString *pngUnSelectedFileName(UICheckBoxType type){
    //TODO: 根据type选择相应的png文件名
    NSString *name = nil;
    switch (type) {
        case UICheckBoxTypeDefault:
            name = DefaultTypePNG;
            break;
        default:
            break;
    }

    return [NSString stringWithFormat:@"%@%@.png",name,UNSELECTED];
}//未选中状态
NSString *pngSelectedFileName(UICheckBoxType type){
    //TODO: 根据type选择相应的png文件名
    NSString *name = nil;
    switch (type) {
        case UICheckBoxTypeDefault:
            name = DefaultTypePNG;
            break;
        default:
            break;
    }

    return [NSString stringWithFormat:@"%@%@.png",name,SELECTED];
}//选中状态

- (void)setType:(UICheckBoxType)type{
    _type = type;
    self.boxSelected = NO;
}

//使自身自动调整为boxView+textLabel 的大小
- (void)autoSizeFrame{
    CGSize size = self.frame.size;
    size.height = SelfViewHeight;
    
    [CommonMethod autoSizeLabel:self.textLabel];
    CGSize textSize = [self.textLabel.text sizeWithFont:self.textLabel.font];
    size.width = self.boxView.frame.origin.x + self.boxView.frame.size.width + EmptyLength + textSize.width + 5;

    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
    //self.textLabel 自适应 坐标
    self.textLabel.center = CGPointMake(EdgeDistance+self.boxView.frame.size.width+EdgeDistance+self.textLabel.frame.size.width/2, self.frame.size.height/2);
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.alpha = .8f;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.alpha = 1.f;
    if (self.boxView.image) {
        self.boxSelected = !_boxSelected;
    }
}

- (void)dealloc{
    self.boxView = nil;
    self.textLabel = nil;
    [super dealloc];
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
