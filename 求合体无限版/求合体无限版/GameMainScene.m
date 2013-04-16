//
//  MyCocos2DClass.m
//  求合体无限版
//
//  Created by ZYJ on 13-3-8.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "GameMainScene.h"
#import "WorldDataModel.h"
#import "OneObject.h"
#import "Define.h"
#import "MapShow.h"
@interface GameMainScene(){
    NSMutableDictionary *mapBlockDic;
    
    NSMutableDictionary *worldPointDic;
    WGSprite *curWillPlacedObj;
    WGSprite *container;
    OneObject *placing;
}
//@property (nonatomic,retain) WGSprite *

@end

@implementation GameMainScene
- (void)loadBG{
    CCSprite *bg = [CCSprite spriteWithFile:@"Bg_Main.png"];
    [self addChild:bg z:0];
    bg.position = ccp(winWidth()/2, winHeight()/2);
}
- (void)loadMapBlock{
    //初始化 地图块 对象
    mapBlockDic = [[WorldDataModel initMapBlockDic] retain];
    
    for (MapShow *mapBlock in mapBlockDic.allValues) {
        [self addChild:mapBlock z:0];
        [mapBlock addTarget:self selector:@selector(blockTouchEnd:) withObject:mapBlock];
    }
    
    Storage *storage = [[[Storage alloc]init] autorelease];
    [self addChild:storage z:0];
    storage.position = BlockPosition((Name(0, 0)));
    [WGDirector addTargetedDelegate:storage priority:0 swallowsTouches:YES];

    [storage addTarget:self selector:@selector(stroageTouched:) withObject:storage];
    
}
- (void)loadObjects{
    for (NSString *name in _worldObjectDic.allKeys) {
        //如果数组的类型不为0，则加载相应LV的obj
        int type = [[_worldObjectDic objectForKey:name] intValue];
        if (type!=0) {
            OneObject *obj = [OneObject selectedInitializeObjectWithType:type levelUP:NO];
            [self addChild:obj z:1];
            obj.position =  BlockPosition(name);
            obj.originalPosition = BlockPosition(name);
            [WGDirector addTargetedDelegate:obj priority:-1 swallowsTouches:YES];
            [obj addTarget:self selector:@selector(revocationPlacing:) withObject:placing];            
        }
    }
}
- (id)init{
    self = [super init];
    if (self) {
                
        WGPlayBGMusic(@"I Loved You.mp3");
        
////        //初始化  网格上的obj类型
        _worldObjectDic = [[WorldDataModel initWorldObjectDic] retain];

        [self loadBG];
        
        [self loadMapBlock];
//        [self loadObjects];
//                
        container = [WGSprite node];
        [self addChild:container z:0];
        [container setOpacity:100];
        container.position = ContainerPos;
        
        placing = [OneObject node];
        [self addChild:placing z:0];
        [placing addTarget:placing selector:@selector(placeObj)];
        [WGDirector addTargetedDelegate:placing priority:-1 swallowsTouches:YES];
        placing.delegate = self;
        
        [self initializeObject];
        
    }
    return self;
}


- (void)blockTouchEnd:(MapShow *)block{

    [self firstPlace:block];
    
}
- (void)stroageTouched:(Storage *)storage{
    [self revocationPlacing:placing];
    [placing setCombiningObjsStopAllActions];
    
    if (storage.storedObj.kType!=LVEmpty) {//如果仓库已经有obj保存着，则跟placing调换
        OneObject *placeCopy = [placing mutableCopy];
        [placing setDisplayFrame:[WGDirector spriteFrameWithTexutre:storage.storedObj.texture]];
        placing.kType = storage.storedObj.kType;
        [container setDisplayFrame:[WGDirector spriteFrameWithTexutre:storage.storedObj.texture]];

        [storage.storedObj setDisplayFrame:[WGDirector spriteFrameWithTexutre:placeCopy.texture]];
        storage.storedObj.kType = placeCopy.kType;
        [placeCopy release];
    }else{//否则直接将placing储存在仓库中
        OneObject *placeCopy = [placing mutableCopy];
        [storage.storedObj setDisplayFrame:[WGDirector spriteFrameWithTexutre:placeCopy.texture]];
        storage.storedObj.kType = placeCopy.kType;
        [placeCopy release];
        
        [self initializeObject];
    }
    
}

//更改地图块视图
- (void)changeMapBlockShow:(NSString *)curBlockName setEmptyArray:(NSMutableArray *)allKindsAr{
    NSString *name_ = [curBlockName mutableCopy];
    NSMutableArray *allKindsAr_ = [allKindsAr mutableCopy];
    
    MapShow *block = [mapBlockDic objectForKey:name_];
    block.mapBlockType = Full;
    for (NSMutableDictionary *dic in allKindsAr_) {
        for (NSString *name in dic) {
            MapShow *block_ = [mapBlockDic objectForKey:name];
            block_.mapBlockType = Empty;
        }
    }
    
    for (MapShow *block_ in mapBlockDic.allValues) {
        if (![block_.mapBlockType isEqualToString:Full]) {
            block_.mapBlockType = Empty;
        }
    }
    
    [block handleErgodicWithDic:mapBlockDic];
    
    [name_ release];
    [allKindsAr_ release];
    
}

//更新一个 Obj
- (void)initializeObject{
    OneObject *obj = [OneObject randomInitializeObject];
    
    [container setDisplayFrame:[WGDirector spriteFrameWithTexutre:obj.texture]];
    
    [placing setDisplayFrame:[WGDirector spriteFrameWithTexutre:obj.texture]];
    placing.kType = obj.kType;
    placing.position = ContainerPos;
    placing.originalPosition = placing.position;
    
    obj = nil;
}
//第一次 放置 placing 虚放置
- (void)firstPlace:(MapShow *)block{
    placing.position = block.position;
//    placing.originalPosition = touchLocation;
    placing.allowTouch = YES;
    placing.nameOfObjOnBlock = block.mapBlockName;
    [placing checkAroundPrePlaced:_worldObjectDic];
}

#pragma mark delegate 方法
- (void)addChildAndTouch:(OneObject *)obj{
    [self addChild:obj z:1];
    obj.nameOfObjOnBlock = placing.nameOfObjOnBlock;
    obj.position = placing.position;
    obj.originalPosition = placing.position;
    obj.delegate = self;
    obj.allowTouch = YES;
    [WGDirector addTargetedDelegate:obj priority:-1 swallowsTouches:YES];
    [obj addTarget:obj selector:@selector(revocationPlaceObj:) withObject:placing];
    
    [_worldObjectDic setObject:obj forKey:obj.nameOfObjOnBlock];
    
    [self initializeObject];

}
//第二次 放置 placing 实放置 delegate方法
//单个放置
- (void)placeOneObject{
    [self changeMapBlockShow:placing.nameOfObjOnBlock setEmptyArray:nil];

    OneObject *obj = [placing mutableCopy];

    [self addChildAndTouch:obj];
    
}
//升级放置
- (void)levelUpObjectWithArray:(NSMutableArray *)array{
    [self changeMapBlockShow:placing.nameOfObjOnBlock setEmptyArray:placing.allKindsOfDic];

    //删除_worldObjectDic中 array所包含的所有节点，置世界位置为空,可以再次点击放置obj
    for (NSMutableDictionary *dic in array) {
        [_worldObjectDic removeObjectsForKeys:dic.allKeys];
    }
    
    // lvUpIndex 的值代表placing升级几个级别
    int lvUpIndex = array.count;
    
    NSMutableDictionary *lastDic = array.lastObject;
    BOOL up = lastDic.count>=3?YES:NO;

    //将placing的连结字典中的都remove掉
    [placing removeAllObjects];

    //在placing位置放置升级后的object
    OneObject *obj = [OneObject selectedInitializeObjectWithType:placing.kType+lvUpIndex levelUP:up];
    [self addChildAndTouch:obj];
}
- (void)combiningMultiObjects:(NSMutableArray *)array{
    [self levelUpObjectWithArray:array];
    
}
//回收 不正确区域点击
- (void)revocationPlacing:(OneObject *)placing_{
    placing_.position = container.position;
    placing_.allowTouch = NO;
    placing_.nameOfObjOnBlock = nil;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
}

- (void)dealloc{
    [mapBlockDic release];
    
    [worldPointDic release];
    self.worldObjectDic = nil;
    
    [super dealloc];
}

@end
