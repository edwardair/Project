//
//  GameLabel.m
//  hitDouDou-Universal
//
//  Created by ZYJ on 12-11-12.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameLabel.h"
#import "LevelData.h"
#import "OpenRayCast.h"
#define OneWorldWidth [DEVICE isEqualToString:@"-iPad"]?21:8
#define OneWorldHeight [DEVICE isEqualToString:@"-iPad"]?27:11
#define LabelCount_Pos [DEVICE isEqualToString:@"-iPad"]?ccp(53,1003):ccp(25,469)
#define LabelPointRate_Pos [DEVICE isEqualToString:@"-iPad"]?ccp(135, 953):ccp(53,449)
#define LabelHighest_Pos [DEVICE isEqualToString:@"-iPad"]?ccp(553, 927):ccp(240,440)
#define PlayerAppraise [DEVICE isEqualToString:@"-iPad"]?ccp(426, 53):ccp(181,26)

@interface GameLabel(){
    CCLabelAtlas *time;
    int minite;
    int second;
    CCLabelTTF *rayCastNumberTTF;
}
@property (nonatomic,assign) Data_Level currentLV;
@end
@implementation GameLabel
@synthesize rayCastNumber = _rayCastNumber;
- (Data_Level )currentLV{
    _currentLV = GetCurrentLevelData();
    return _currentLV;
}
CCLabelAtlas *getAtlas(NSString *str){
    return [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%@",str] charMapFile:[NSString stringWithFormat:@"Numbers%@.png",DEVICE] itemWidth:OneWorldWidth itemHeight:OneWorldHeight startCharMap:'0'];
}
- (int )rayCastNumber{
    int n = [[NSUserDefaults standardUserDefaults] integerForKey:@"TotalRemain"];
    _rayCastNumber = n;
    return _rayCastNumber;
}
- (void)setRayCastNumber:(int)rayCastNumber{
    CGSize winSize = [[CCDirector sharedDirector]winSize];
    
    _rayCastNumber = rayCastNumber;
    [[NSUserDefaults standardUserDefaults] setInteger:_rayCastNumber forKey:@"TotalRemain"];
    
    if (!rayCastNumberTTF) {
        //:          瞄准线 
        rayCastNumberTTF = [CCLabelTTF labelWithString:@"0" fontName:@"Georgia-Bold" fontSize:10.f];
        [self addChild:rayCastNumberTTF];
        rayCastNumberTTF.color = ccBLACK;
        rayCastNumberTTF.position = ccp(87, winSize.height-35.f);
        
        CCLabelTTF *title = [CCLabelTTF labelWithString:@":          瞄准线" fontName:@"Georgia-Bold" fontSize:10.f];
        [self addChild:title];
        title.color = ccBLACK;
        title.position = ccp(45, winSize.height-35.f);

    }
    rayCastNumberTTF.string = [NSString stringWithFormat:@"%d",_rayCastNumber];

}
-(id)init{
    if (self == [super init]) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];

        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"CurrentLV"];

        
        self.labelPoint = 0;
        
        self.labelCount = getAtlas(@"000000");
        [self addChild:self.labelCount];
        self.labelCount.anchorPoint = ccp(0, .5);
        self.labelCount.position = ccp(5, winSize.height-_labelCount.contentSize.height/2-10);
        
        CCLabelTTF *xTTF = [CCLabelTTF labelWithString:@"x" fontName:@"Georgia-Bold" fontSize:12.f];
        [self addChild:xTTF];
        xTTF.color = ccBLACK;
        xTTF.position = ccp(75, _labelCount.position.y);
        
        self.labelPointRate = getAtlas([NSString stringWithFormat:@"%d",self.currentLV.pointRate]);
        [self addChild:self.labelPointRate];
        self.labelPointRate.position = ccp(90, _labelCount.position.y);
        self.labelPointRate.anchorPoint = ccp(1, .5);
        self.labelPointRate.rotation = -5;
        self.labelPointRate.scale = 1;

        NSUserDefaults *highestData = [NSUserDefaults standardUserDefaults];
        int x = [highestData integerForKey:@"HighestCount"];
        
        self.labelHighest = getAtlas([NSString stringWithFormat:@"%06d",x]);
        [self addChild:self.labelHighest];
        self.labelHighest.position = ccp(winSize.width-_labelHighest.contentSize.width/2-45, winSize.height-_labelHighest.contentSize.height/2-35);
//        self.labelHighest.rotation = -3;

//        self.playerAppraise = getAtlas([NSString stringWithFormat:@"%d",self.currentLV.LV]);
//        [self addChild:self.playerAppraise z:1];
//        self.playerAppraise.position = PlayerAppraise;

        minite = 4;
        second = 60;
        time = getAtlas([NSString stringWithFormat:@"5 00"]);
        [self addChild:time z:1];
        time.position = ccp(5, winSize.height-40.f);
        
        self.rayCastNumber = self.rayCastNumber;
        
        CCLabelTTF *heighest = [CCLabelTTF labelWithString:@"最高分" fontName:@"Georgia-Bold" fontSize:10.f];
        [self addChild:heighest];
        heighest.position = ccp(winSize.width-heighest.contentSize.width/2-35, winSize.height-heighest.contentSize.height/2-10);
        heighest.color = ccBLACK;
        
        [self schedule:@selector(update) interval:1.f];
    }
    return self;
}

- (void)update{
    if (self.rayCastNumber<60) {
        second -= 1;
        if (second<0) {
            second = 59;
            minite -=1;
            if (minite<0) {
                //每五分钟 瞄准线个数增加1
                self.rayCastNumber += 1;
                minite = 4;
            }
        }
        time.string = [NSString stringWithFormat:@"%d %02d",minite,second];
    }
}
- (void)setLabelPoint:(int)labelPoint{
    _labelPoint += self.currentLV.pointRate*labelPoint;
    [self.labelCount setString:[NSString stringWithFormat:@"%06d",_labelPoint]];
    
    NSUserDefaults *highestData = [NSUserDefaults standardUserDefaults];
    int x = [highestData integerForKey:@"HighestCount"];
    if (_labelPoint > x) {
        [highestData setInteger:_labelPoint forKey:@"HighestCount"];
        [_labelHighest setString:[NSString stringWithFormat:@"%06d",_labelPoint]];
    }
}
-(void)dealloc{
    self.labelPointRate = nil;
    self.labelCount = nil;
    self.labelHighest = nil;

    [super dealloc];
}
@end
