//
//  HeTi.h
//  Learn
//
//  Created by Apple on 13-6-5.
//
//

#ifndef __Learn__HeTi__
#define __Learn__HeTi__

#include "WGCocos2d.h"
#include "TPClass.h"

class HeTi:public WGLayer{
public:
    void myInit();
    ~HeTi();
    
    CREATE_FUNC(HeTi);
    CREATE_FUNC_CCSCENE(HeTi);
    
    
    void call_Clicked(TPClass *sp);
private:
    CCDictionary *allSprites;
    void changeDisplayFrame();
    void recursionFromFirstTP(TPClass *sp);
    void checkCorners();
    bool compare(TPClass *a,TPClass *b);
};

#endif /* defined(__Learn__HeTi__) */
