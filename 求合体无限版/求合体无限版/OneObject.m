//
//  OneObject.m
//  求合体无限版
//
//  Created by ZYJ on 13-3-11.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "OneObject.h"
#import "Define.h"
#import "GameMainScene.h"
#import "ActionManage.h"
@interface OneObject(){
    
}
@property (nonatomic,retain) NSMutableDictionary *combiningObjectsDic;
@end
@implementation OneObject
@synthesize delegate;

- (id) mutableCopyWithZone:(NSZone *)zone {
	OneObject *copy = [[[self class] allocWithZone:zone] initWithOneObject:self];
	return copy;
}

- (OneObject *) initWithOneObject:(OneObject *) copyFrom {
    if ((self = [super initWithFile:[NSString stringWithFormat:@"Place_%03d.png",copyFrom.kType]])) {
        self.position = copyFrom.position;
        self.kType = copyFrom.kType;
	}
	return self;
}
+(int )randomIndex{
    int randomIndex = arc4random()%100;

    if (randomIndex<=69)
        randomIndex = LV1;
    else if (randomIndex<=89)
        randomIndex = LV2;
    else if (randomIndex<=97)
        randomIndex = LV3;
    else
        randomIndex = LV4;
    
    return randomIndex;
}

+(id )randomInitializeObject{
    
    int randomIndex = [OneObject randomIndex];
        
    return [[[[self class] alloc]initWithIndex:randomIndex levelUP:NO] autorelease];
}
+(id )selectedInitializeObjectWithType:(int)kType levelUP:(BOOL )up{
    return [[[[self class] alloc]initWithIndex:kType levelUP:up] autorelease];
}
- (id)initWithIndex:(int )index levelUP:(BOOL )up{

    if ( (self = [super initWithFile:[NSString stringWithFormat:@"Place_%03d%@.png",index,up?@"_UP":@""]]) ) {
        self.kType = index;
    }
    return self;
}

//get
- (NSMutableArray *)allKindsOfDic{
    if (!_allKindsOfDic) {
        _allKindsOfDic = [[NSMutableArray alloc]init];
    }
    return _allKindsOfDic;
}
- (NSMutableDictionary *)combiningObjectsDic{
    if (!_combiningObjectsDic) {
        _combiningObjectsDic = [[NSMutableDictionary alloc]init];
    }
    return _combiningObjectsDic;
}
//set
- (void)setNameOfObjOnBlock:(NSString *)nameOfObjOnBlock{
    [_nameOfObjOnBlock release];
    _nameOfObjOnBlock = [nameOfObjOnBlock retain];
}
//检查坐标p是否在正确的地图范围中
- (BOOL)checkPosInRightRrea:(CGPoint )p{
    return CGRectContainsPoint(CGRectMake(MinXEdge, MinYEdge, MaxXEdge-MinXEdge, MaxYEdge-MinYEdge), p);
}
//将所连结的所有obj停止其动作
- (void)setCombiningObjsStopAllActions{
    if (self.allKindsOfDic.count>0) {
        [ActionManage stopObjectAllActions:_allKindsOfDic];
        
        [self.allKindsOfDic removeAllObjects];
    }
}
//多线程 递归遍历
- (void)threadCheckAround:(NSMutableDictionary *)worldObjDic{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    [self setCombiningObjsStopAllActions];
    
    [self callSameKindRecursionWithDic:worldObjDic withObjName:self.nameOfObjOnBlock andType:self.kType];
    
    [ActionManage preCheckActionWithArray:_allKindsOfDic centerPos:self.position];
    
//    self.allowTouch = YES;
    
    [pool release];

    [NSThread exit];

}
//多线程 合成升级
- (void)threadLVUp{
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    [ActionManage removeObjectWithArray:_allKindsOfDic centerPos:self.position];
    
    
//    [pool release];
    
//    [NSThread exit];
}

//放置真正的Obj之前遍历检测placing四周是否有相同类型的obj
- (void)checkAroundPrePlaced:(NSMutableDictionary *)worldObjDic{
    NSLog(@"预检查");
    
    [NSThread detachNewThreadSelector:@selector(threadCheckAround:) toTarget:self withObject:worldObjDic];
    
}
//递归升级类
- (void )recursionCallLvUpWithkTypeIndex:(int )kType withDic:(NSMutableDictionary *)worldObjDic{
    //大于等于2 并且placing是否为最高级（最高级则无法再升级） 则 obj升级 检测升级后四周是否可再升级
    if (_combiningObjectsDic.allValues.count>=2) {
        //_allKindOfDic 只有在满足上述条件下  才将dic添加进数组中，可以防止最高级别第一次遍历时“升级”
        [_allKindsOfDic addObject:[_combiningObjectsDic mutableCopy] ];
        
        [self callSameKindRecursionWithDic:worldObjDic withObjName:self.nameOfObjOnBlock andType:++kType];
    }
}

//递归同类
- (void)callSameKindRecursionWithDic:(NSMutableDictionary *)worldObjDic withObjName:(NSString *)curName andType:(int )curKType{
    [self.combiningObjectsDic removeAllObjects];

    //递归遍历周围连结点
    [self recursionCallWithDic:worldObjDic withObjName:curName andType:curKType];
    
    [self recursionCallLvUpWithkTypeIndex:curKType withDic:worldObjDic];
    
}
- (void )recursionCallWithDic:(NSMutableDictionary *)worldObjDic withObjName:(NSString *)curName andType:(int )curKType{

    OneObject *saveObj = [worldObjDic objectForKey:curName];
    if (saveObj) {
        if ([_combiningObjectsDic objectForKey:curName]) {
            return;
        }else{
            [_combiningObjectsDic setObject:saveObj forKey:curName];
        }
    }
    
    int x = BlockXFlg(curName);
    int y = BlockYFlg(curName);
    
    int a[4] = {0,0,-1,1};//代表 上下左右 四个方向 X坐标的转化
    int b[4] = {-1,1,0,0};//Y坐标的转化
    
    for (int i = 0; i < 4; i++) {
        
        OneObject *temp = [worldObjDic objectForKey:Name(x+a[i], y+b[i])];
        
        if (temp && temp.kType==curKType) {
            [self recursionCallWithDic:worldObjDic withObjName:temp.nameOfObjOnBlock andType:curKType];
        }
    }
}
//触摸
//如果点中 placing 对象 则在placing位置放置相对应的obj 然后回收placing
- (void)placeObj{
    NSLog(@"放置");
    if (_allKindsOfDic.count>0) {
        //TODO: 3个以上同类合成
        [self.delegate combiningMultiObjects:_allKindsOfDic];
    }else{
        //TODO: 在placing位置放置单个同类obj
        [self.delegate placeOneObject];
    }

}
//如果点中 placing以外的 对象 则将placing返回container的位置，并设置placing的allowTouch为NO
- (void)revocationPlaceObj:(OneObject *)placing{
    NSLog(@"回收");

    [self.delegate revocationPlacing:placing];

}
//
- (void)removeAllObjects{
    [self threadLVUp];
//    [NSThread detachNewThreadSelector:@selector(threadLVUp) toTarget:self withObject:nil];
}
- (void)dealloc{
    [_allKindsOfDic release];
    _allKindsOfDic = nil;
    
    [_combiningObjectsDic release];
    _combiningObjectsDic = nil;
    
    [super dealloc];
}

@end
