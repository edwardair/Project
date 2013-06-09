//
//  Test.h
//  Learn
//
//  Created by Apple on 13-5-31.
//
//

#ifndef __Learn__Test__
#define __Learn__Test__

#include "WGCocos2d.h"


class Test :public WGLayer
{
public:
    void myInit();

    CREATE_FUNC(Test);

    CREATE_FUNC_CCSCENE(Test);
};

#endif /* defined(__Learn__Test__) */
