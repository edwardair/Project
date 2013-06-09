//
//  TPSprite.h
//  Learn
//
//  Created by Apple on 13-6-4.
//
//

#ifndef __Learn__WGSprite__
#define __Learn__WGSprite__

#include "cocos2d.h"


#define CREATE_WITH_FILE(__TYPE__,PNAME) \
static __TYPE__* spriteWithFile(const char* pName) \
{ \
__TYPE__ *newSprite = new __TYPE__(); \
if (newSprite && newSprite->initWithFile(pName)) { \
    newSprite->setAllowTouch(true);/*默认精灵类初始可点击*/ \
    newSprite->myInit(); \
    newSprite->autorelease(); \
    return newSprite; \
} \
CC_SAFE_DELETE(newSprite); \
return NULL; \
 \
}

using namespace cocos2d;

class WGSprite : public CCSprite,public CCTouchDelegate{
public:
    CREATE_WITH_FILE(WGSprite, const char* spName);
    virtual void myInit();
    
    virtual ~WGSprite();
    
    virtual void onEnter();
    virtual void onExit();
    
    virtual bool  ccTouchBegan(CCTouch *pTouch,CCEvent *pEvent);
    virtual void ccTouchMoved(CCTouch *pTouch,CCEvent *pEvent);
    virtual void ccTouchEnded(CCTouch *pTouch,CCEvent *pEvent);

    CCRect rect();
    bool containsTouchLocation(CCTouch *pTouch);

    CC_PROPERTY(bool, allowTouch, AllowTouch);
    void setMyPriority(int priority);

void addTarget_Selcetor(CCObject *rec, SEL_CallFuncN selector);
protected:
    CCObject*       m_pListener;
    SEL_CallFuncN    m_pfnSelector;

};
#endif /* defined(__Learn__TPSprite__) */
