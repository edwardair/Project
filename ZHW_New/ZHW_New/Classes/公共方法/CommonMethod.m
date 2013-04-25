//
//  CommonMethod.m
//  ZHW_New
//
//  Created by BlackApple on 13-4-10.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "CommonMethod.h"
#import "StaticManager.h"
@implementation CommonMethod
//获取屏幕可用 Frame
CGRect applicationFrame(){
    CGRect frame = [[UIScreen mainScreen]applicationFrame];
    return frame;
}
//获取屏幕完整 Size
CGSize screenSize(){
    CGSize size = [[UIScreen mainScreen] bounds].size;
    return size;
}
//检测NSString是否为空 如果空返回空字符串
NSString *writeEnable(NSString *text){
    NSString *s = [text isKindOfClass:[NSNumber class]]?[NSString stringWithFormat:@"%@",text]:text;
    return (s&&![s isEqual:[NSNull null]])?s:@"";//[s isEqualToString:@"<null>"]
}
#pragma mark  NSLog 
void NSLogFrame(CGRect frame){
    NSLog(@"%f,%f,%f,%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
}
void NSLogCGPoint(CGPoint point){
    NSLog(@"%f,%f",point.x,point.y);
}
void NSLogString(id obj){
    NSLog(@"%@",obj);
}
void NSLogFloat(float i){
    NSLog(@"%f",i);
}


#pragma mark ----------------------

@end
#pragma mark 点击注销键盘手势
static TapResignKeyBoard *tapResignKeyBoard = nil;
@interface TapResignKeyBoard()
@property (strong,nonatomic) UITapGestureRecognizer *emptyAreaTouched;
@property (assign,nonatomic) BOOL didKeyBoardShowed;
@end

static float orgCenterOfParentView = 0.f;

@implementation TapResignKeyBoard
@synthesize tapDelegate  =_tapDelegate;
+(TapResignKeyBoard *)shareTapResignKeyBoard{
    if (!tapResignKeyBoard) {
        tapResignKeyBoard = [[TapResignKeyBoard alloc]init];
    }
    return tapResignKeyBoard;
}
- (void)setTapDelegate:(id<TapResignKeyBoardDelegate>)tapDelegate{
    //委托存在 同时 设置为nil时，相应的删除通知
    if (_tapDelegate && !tapDelegate) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
    //委托不存在 同时tapDelegate不为nil时，添加通知
    else if (!_tapDelegate && tapDelegate){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisAppear:) name:UIKeyboardWillHideNotification object:nil];
    }
    _tapDelegate = tapDelegate;
}
- (UITapGestureRecognizer *)emptyAreaTouched{
    if (!_emptyAreaTouched) {
        _emptyAreaTouched = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyBoard)];
//        [_emptyAreaTouched setCancelsTouchesInView:NO];
        _emptyAreaTouched.enabled = NO;
    }
    return _emptyAreaTouched;
}
//在rootViewController更改的情况下  更改前运行此方法
- (void)removeGestureFromRootViewController{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];

    [keyWindow.rootViewController.view removeGestureRecognizer:self.emptyAreaTouched];
}
//在rootViewController更改的情况下  更改后运行此方法
- (void)addGestureToRootViewController{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    [keyWindow.rootViewController.view addGestureRecognizer:self.emptyAreaTouched];
}
//方法注销键盘
- (void)resignKeyBoard{
    [[_tapDelegate curClickedText] resignFirstResponder];
}
//通知中心
- (void)keyboardWillAppear:(NSNotification *)notification{
    NSLog(@"键盘显现");
   if(_tapDelegate) [self TextInputAnimation:notification];
    
    self.emptyAreaTouched.enabled = YES;
    
    if ([_tapDelegate respondsToSelector:@selector(keyBoardWillAppearDelegate)]) {
        [_tapDelegate keyBoardWillAppearDelegate];
    }
}
- (void)keyboardWillDisAppear:(NSNotification *)notification{
    NSLog(@"键盘隐藏");
    if(_tapDelegate) [self resignParentView:notification];
    
    self.emptyAreaTouched.enabled = NO;
    
    if ([_tapDelegate respondsToSelector:@selector(keyBoardWillDisAppearDelegate)]) {
        [_tapDelegate keyBoardWillDisAppearDelegate];
    }

}
#pragma mark 点击TextField TextView时 屏幕内容自适应键盘高度
-(float )isParentView:(UIView *)parent sub:(UIView *)sub center:(float )posY{

    if (![sub.superview isEqual:parent]) {
        CGRect subFrame = sub.frame;
        subFrame = [sub.superview convertRect:subFrame toView:sub.superview.superview];
        CGRect parFrame = sub.superview.frame;
        
        posY += subFrame.origin.y-parFrame.origin.y;
        
        posY = [self isParentView:parent sub:sub.superview center:posY];
    }
    return posY;
}
- (float )isSuperView:(UIView *)superView EqualToParentView:(UIView *)parentView{
    float y = 0;
    if (![superView isEqual:parentView]) {
        y += superView.frame.origin.y;
        if ([superView isKindOfClass:[UIScrollView class]]) {
            UIScrollView *s = (UIScrollView *)superView;
            y -= s.contentOffset.y;
        }
        y += [self isSuperView:superView.superview EqualToParentView:parentView];
    }else{
        return 0;
    }
    return y;
}
#pragma mark 使传递的View在键盘弹出时自适应高度  一般View为最底层的view
-(void)TextInputAnimation:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];

    UIView *textView = [_tapDelegate curClickedText];
    UIView *willFitView = [_tapDelegate willFitPointOfView];
    //记录父View初始中心y坐标
    if (!_didKeyBoardShowed) {
        orgCenterOfParentView = willFitView.center.y;
    }
    
    float originOffSetY = [self isSuperView:textView.superview EqualToParentView:willFitView];

    float originY = originOffSetY + textView.frame.origin.y;
    float textViewBottomY = originY + textView.frame.size.height;
    //state 屏幕最上方状态栏 nav导航控制器（手动添加的不算） BOOL值为YES时修正textViewBottomY的值
    textViewBottomY += ([_tapDelegate statusBarShow]?20.f:0)+([_tapDelegate navigationBarShow]?44.f:0);
    float textWillBottomY = [[userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].origin.y;

    float sub = textWillBottomY-textViewBottomY;
    
    if (sub>0) {
        return;
    }
    
    NSLog(@"上移 tapDelegate");
    [UIView beginAnimations:@"MoveUp" context:NULL];
    [UIView setAnimationDuration:[[userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue]];
    [UIView setAnimationCurve:[[userInfo objectForKey:@"UIKeyboardAnimationCurveUserInfoKey"] intValue]];
    willFitView.transform = CGAffineTransformMakeTranslation(0, sub);
    [UIView commitAnimations];
    
}
#pragma mark 注销键盘时 屏幕返回初始位置
-(void)resignParentView:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];

    if (_tapDelegate) {
        NSLog(@"下移 ");
        [UIView beginAnimations:@"MoveDown" context:NULL];
        
        [UIView setAnimationDuration:[[userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue]];//
        [UIView setAnimationCurve:[[userInfo objectForKey:@"UIKeyboardAnimationCurveUserInfoKey"] intValue]];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(changeKeyBoardShowState)];

        [_tapDelegate willFitPointOfView].transform = CGAffineTransformMakeTranslation(0,  orgCenterOfParentView-[_tapDelegate willFitPointOfView].center.y);
        [UIView commitAnimations];
    }
}
- (void)changeKeyBoardShowState{
    _didKeyBoardShowed = NO;
}
@end


