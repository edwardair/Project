//
//  LevelData.h
//  hitDouDou-Universal
//
//  Created by ZYJ on 12-10-30.
//
//

#ifndef hitDouDou_Universal_LevelData_h
#define hitDouDou_Universal_LevelData_h

struct Data_Level {
    int LV;
    BOOL didPunishOpen;
    int lifeMax;
    int punishBallNumberMin;
    int punishBallNumberMax;
    int ballTotalNumber;
    int pointRate;
    NSString *curPlayerAppraise;
    int tierCount;
};
typedef struct Data_Level Data_Level;

CG_INLINE Data_Level
GetCurrentLevelData(void){
    
    int lv_ = [[NSUserDefaults standardUserDefaults] integerForKey:@"CurrentLV"];
    if (lv_ <= 0) {
        lv_ = 1;
        [[NSUserDefaults standardUserDefaults] setInteger:lv_ forKey:@"CurrentLV"];
    }
    
    Data_Level lv;
    lv.LV = lv_;
    lv.didPunishOpen = YES;
    lv.lifeMax = 6;
    lv.punishBallNumberMin = 4;
    lv.punishBallNumberMax = 7;
    lv.ballTotalNumber = 5;
    lv.pointRate = lv_;
    lv.tierCount = 4;

    return lv;
}


#endif
