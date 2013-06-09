//
//  WGLayer.cpp
//  Learn
//
//  Created by Apple on 13-6-4.
//
//

#include "WGLayer.h"
#include "SimpleAudioEngine.h"

#define DefaultPriority 0

using namespace cocos2d;
using namespace CocosDenshion;

bool WGLayer::init(){
    if (!CCLayer::init()) {
        return false;
    }
    this->setTouchEnabled(true);

    myInit();
    
    return true;
}
#pragma mark ----------myInit 可重写
void WGLayer::myInit(){
    
}

#pragma mark ***析构函数****
WGLayer::~WGLayer(){
    
}

#pragma mark ------setter getter----------
bool WGLayer::getAllowTouch(){
    return allowTouch;
}
void WGLayer::setAllowTouch(bool allowTouch_){
    allowTouch = allowTouch_;
}

#pragma mark --------重置WGLayer的触摸权限
void WGLayer::setMyPriority(int priority){
    if (CCDirector::sharedDirector()->getTouchDispatcher()->findHandler(this)) {
        CCDirector::sharedDirector()->getTouchDispatcher()->setPriority(priority, this);
    }
    else{
        allowTouch = true;
        CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(this, priority, true);
    }
}

#pragma mark -------WGLayer 的层触摸实现
void WGLayer::registerWithTouchDispatcher(){
    if (allowTouch) {
        CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(this, DefaultPriority, true);
    }
}
bool WGLayer::ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent){
    CCLog("WGLayer TouchBegin");
    return true;
}
void WGLayer::ccTouchMoved(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent){
    CCLog("WGLayer TouchMoving");
}
void WGLayer::ccTouchEnded(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent){
    CCLog("WGLayer TouchEnd");
}

#pragma mark -------播放声音
void WGLayer::prePlayBackGroundMusic(const char *pName){
    
}
void WGLayer::playBGMusic(const char *pName){
    SimpleAudioEngine::sharedEngine()->playBackgroundMusic(pName, true );
}
void WGLayer::pauseBGMusic(){
    SimpleAudioEngine::sharedEngine()->pauseBackgroundMusic();
}
void WGLayer::resumeBGMusic(){
    SimpleAudioEngine::sharedEngine()->resumeBackgroundMusic();
}
void WGLayer::stopBGMusic(){
    SimpleAudioEngine::sharedEngine()->stopBackgroundMusic();
}
bool WGLayer::isBGMusicPlaying(){
    return SimpleAudioEngine::sharedEngine()->isBackgroundMusicPlaying();
}
void WGLayer::prePlaySoundEffect(const char *pName...){
    va_list args;
    va_start(args, pName);
    if (pName) {
        SimpleAudioEngine::sharedEngine()->preloadEffect(pName);
        const char *pNext = va_arg(args, const char*);
        while (pNext) {
            SimpleAudioEngine::sharedEngine()->preloadEffect(pName);
            pNext = va_arg(args, const char*);
        }
    }
    va_end(args);
}
void WGLayer::playSoundEffect(const char *pName,bool record){
    if (record) {//如果为true 则记录声音的soundId，以便后续可以对其停止
        if (soundId!=kSoundNoBuffer) {
            stopSoundEffect();
        }
        soundId = SimpleAudioEngine::sharedEngine()->playEffect(pName);
    }else{//一般为短音效 通常情况不需要记录来停止
        SimpleAudioEngine::sharedEngine()->playEffect(pName);
    }
}
void WGLayer::stopSoundEffect(){
    SimpleAudioEngine::sharedEngine()->stopEffect(soundId);
    soundId = kSoundNoBuffer;
}
