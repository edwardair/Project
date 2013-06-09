//
//  TPSprite.h
//  Learn
//
//  Created by Apple on 13-6-5.
//
//

#ifndef __Learn__TPClass__
#define __Learn__TPClass__

#include "WGCocos2d.h"

enum{
    leftCount = 1,
    rightCount = 2,
    upCount = 4,
    downCount = 8,
};

class TPClass: public WGSprite{
public:
    CREATE_WITH_FILE(TPClass, const char* spName);
    
//    int left = 0;
//    int right = 0;
//    int up = 0;
//    int down = 0;

    int x,y;
    
    bool full = false;

    void overDraw(int type_);

    CC_PROPERTY(int, sum, Sum);
    CC_PROPERTY(int, left, Left);
    CC_PROPERTY(int, right, Right);
    CC_PROPERTY(int, up, Up);
    CC_PROPERTY(int, down, Down);

};

#endif
