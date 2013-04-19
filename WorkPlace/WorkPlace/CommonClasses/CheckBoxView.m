//
//  CheckBoxView.m
//  WorkPlace
//
//  Created by BlackApple on 13-4-19.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "CheckBoxView.h"
#import "CommonMethod.h"
#define DefaultViewHeight 30.f
#define DefaultBoxHeight  20.f
#define EdgeDistance 5.f
#define EmptyLength 10.f
#define DefaultFontSize 18.f
#define UNSELECTED @"_UnSelected"
#define SELECTED @"_Selected"

#define DefaultTypePNG @"DefaultTypePNG"

@implementation CheckBoxView
+(id )initWithFrame:(CGRect)frame type:(UICheckBoxType )type{
    CheckBoxView *box = [[[self alloc] initWithFrame:frame] autorelease];
    box.type = type;
    return box;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
//初始化boxView
- (UIImageView *)boxView{
    if (!_boxView) {
        //默认第一次初始化 设置背景透明 ／／在这里写而不是在init里面写是由于如果是使用xib加载的话init不会走
        self.backgroundColor = [UIColor clearColor];
        _boxSelected = NO;

        _boxView = [[UIImageView alloc]initWithFrame:CGRectMake(EdgeDistance, DefaultViewHeight/2-DefaultBoxHeight/2, DefaultBoxHeight, DefaultBoxHeight)];
        [self addSubview:_boxView];
    }
    return _boxView;
}
//初始化textLabel
- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]init];

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
    //如果未定义过 textFont 怎选择默认字体大小18.0f来设置textLabel的大小
    if (!_textFont) {
        //默认字体大小
        [self setTextFont:[UIFont systemFontOfSize:DefaultFontSize]];
    }else
        [self autoSizeFrameWithFont:_textFont];
}
- (void)setTextFont:(UIFont *)textFont{
//    if (!_textFont) {
        [_textFont release];
//    }
    
    _textFont = [textFont retain];
    [_textLabel setFont:_textFont];
    [self autoSizeFrameWithFont:_textFont];
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
- (void)autoSizeFrameWithFont:(UIFont *)font{
    [CommonMethod autoSizeLabel:self.textLabel withFont:font];
    CGSize textSize = [self.textLabel.text sizeWithFont:font];

    CGSize selfWillSize = self.frame.size;
    selfWillSize.height = DefaultViewHeight;
    selfWillSize.width = self.boxView.frame.origin.x + self.boxView.frame.size.width + EmptyLength + textSize.width + EdgeDistance;
    
    //self 自适应 frame
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, selfWillSize.width, selfWillSize.height);
    
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
    self.textFont = nil;
    NSLogString(@"CheckBox ：释放");
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
