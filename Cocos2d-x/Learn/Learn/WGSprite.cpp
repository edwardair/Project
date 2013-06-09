//
//  TPSprite.cpp
//  Learn
//
//  Created by Apple on 13-6-4.
//
//

#include "WGSprite.h"
#define DefaultPriority -1

using namespace cocos2d;
#pragma mark *************************
#pragma mark 使用png图片初始化
//WGSprite* WGSprite::spriteWithFile(const char *spName){
//    WGSprite *newSprite = new WGSprite();
//    if (newSprite && newSprite->initWithFile(spName)) {
//        newSprite->setAllowTouch(true);//默认精灵类初始可点击
//        newSprite->myInit();
//        newSprite->autorelease();
//        return newSprite;
//    }
//    CC_SAFE_DELETE(newSprite);
//    return NULL;
//}
#pragma mark *************************
#pragma mark myInit 可重写
void WGSprite::myInit(){
    
}
#pragma mark *************************
#pragma mark 析构
WGSprite::~WGSprite(){
    //虚构函数 处理内存释放
}

#pragma mark *************************
#pragma mark allowTouch
bool WGSprite::getAllowTouch(){
    return allowTouch;
}
void WGSprite::setAllowTouch(bool allowTouch_){
    allowTouch = allowTouch_;
}
#pragma mark -----------添加触摸委托
void WGSprite::addTarget_Selcetor(cocos2d::CCObject *rec, SEL_CallFuncN selector){
    m_pListener = rec;
    m_pfnSelector = selector;
}
#pragma mark *************************
#pragma mark 更改触摸权限
void WGSprite::setMyPriority(int priority){
    CCDirector::sharedDirector()->getTouchDispatcher()->setPriority(priority, this);
}

#pragma mark *************************
#pragma mark 精灵触摸
void WGSprite::onEnter(){
    CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(this, DefaultPriority, true);
    CCSprite::onEnter();
}
void WGSprite::onExit(){
    CCDirector::sharedDirector()->getTouchDispatcher()->removeDelegate(this);
    CCSprite::onExit();
}

CCRect WGSprite::rect(){
    CCRect myRect = this->boundingBox();
    return myRect;
}
bool WGSprite::containsTouchLocation(CCTouch *pTouch){
    CCPoint touchLocation = pTouch->getLocation();
    
    return rect().containsPoint(touchLocation);
}
bool WGSprite::ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent){
    if (!containsTouchLocation(pTouch)) 
        return false;
    else if (!allowTouch)
        return false;
    
    CCLog("WGSprite TouchBegin");

    return true;
}
void WGSprite::ccTouchMoved(CCTouch *pTouch, CCEvent *pEvent){
    CCLog("WGSprite TouchMoving");

}
void WGSprite::ccTouchEnded(CCTouch *pTouch, CCEvent *pEvent){
    CCLog("WGSprite TouchEnd");
    if (m_pListener && m_pfnSelector) {
        (m_pListener->*m_pfnSelector)(this);
    }
}
#pragma mark *************************



