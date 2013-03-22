//
//  MapShow.m
//  求合体无限版
//
//  Created by ZYJ on 13-3-13.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "MapShow.h"
#import "Define.h"
@interface MapShow()

@end
@implementation MapShow
@synthesize mapBlockType = _mapBlockType;
+(id )initWithType:(NSString *)name{
    return [[[self alloc]initWithType:name] autorelease];
}
- (id )initWithType:(NSString *)name{
    if (self == [super init]) {
        self.mapBlockType = name;
    }
    return self;
}
- (void)setMapBlockType:(NSString *)mapBlockType{
    [_mapBlockType release];
    
    _mapBlockType = [mapBlockType retain];
    
    CCSpriteFrame *frame = [WGDirector spriteFrameWithString:[NSString stringWithFormat:@"Map_%@.png",mapBlockType]];
    [self setDisplayFrame:frame];
}

- (void)setMapBlockName:(NSString *)mapBlockName{
    _mapBlockName = mapBlockName;
    CCLabelTTF *ttf = [CCLabelTTF labelWithString:_mapBlockName fontName:@"AppleGothic" fontSize:20];
    [self addChild:ttf];
    ttf.color = ccc3(255, 0, 0);
    ttf.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
}

//处理遍历地图块设置相应的displayFrame
enum{
    UP = 0,
    DOWN,
    LEFT,
    RIGHT,
};
//检测 以 x，y为坐标的相对应地图块的mapBlockType中是否包含有U、D、L、R的关键字，如果有，则返回相应NSString
#define AgainstDir(dir)  ((dir==UP) ? @"D" : ((dir==DOWN) ? @"U" : ((dir==LEFT) ? @"R" : @"L")))
#define SameDir(dir)  ((dir==UP) ? @"U" : ((dir==DOWN) ? @"D" : ((dir==LEFT) ? @"L" : @"R")))

- (NSString *)isBlock:(MapShow *)block haveWallOnDirection:(int )dir{
    NSString *returnC = SameDir(dir);
    NSString *againstC = AgainstDir(dir);
    if (!block) {
        return returnC;
    }
    //block 存在情况
    NSString *name = block.mapBlockType;
    
    NSRange foundC = [name rangeOfString:againstC];
    
    if (foundC.length>0 || [name isEqualToString:Full]) {
        return returnC;
    }
    return nil;
}
- (void)setCurBlockTexture:(MapShow *)block dictnory:(NSMutableDictionary *)dic{
    NSString *name = block.mapBlockName;
    
    NSMutableString *tempName = [NSMutableString string];
    
    int a[4] = {0,0,-1,1};
    int b[4] = {-1,1,0,0};
    for (int i = 0; i < 4; i++) {
        int x,y;//x,y代表 上下左右四个方向
        x = a[i];
        y = b[i];
        x += BlockXFlg(name);
        y += BlockYFlg(name);
        
        MapShow *block_ = [dic objectForKey:Name(x, y)];
        
        NSString *appendString_ = [self isBlock:block_ haveWallOnDirection:i];
        if (appendString_) {
            [tempName appendString:appendString_];
        }
        
    }
    if (tempName.length==0) {
        [tempName setString:Empty];
    }
    
    block.mapBlockType = tempName;
    
}

- (void)handleErgodicWithDic:(NSMutableDictionary *)dic{
    for (MapShow *curBlock in dic.allValues) {
        
        if ([curBlock.mapBlockType isEqualToString:Full]) {
            continue;
        }
        
        [self setCurBlockTexture:curBlock dictnory:dic];
    }

}

- (void)dealloc{
    [self.mapBlockType release];
    _mapBlockType = nil;
    self.mapBlockName = nil;
    [super dealloc];
}
@end


//仓库
@implementation Storage
- (id )init{
    if (self == [super initWithFile:@"Map_F.png"]) {
        self.storedObj = [OneObject node];
        [self addChild:_storedObj];
        _storedObj.kType = LVEmpty;
        _storedObj.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    }
    return self;
}


- (void)dealloc{
    
    [super dealloc];
}

@end
