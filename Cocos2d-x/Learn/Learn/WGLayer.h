//
//  WGLayer.h
//  Learn
//
//  Created by Apple on 13-6-4.
//
//

#ifndef __Learn__WGLayer__
#define __Learn__WGLayer__

#include "cocos2d.h"

#define kSoundNoBuffer -1


//切换场景时使用，返回一个CCScene
#define CREATE_FUNC_CCSCENE(__TYPE__) \
static CCScene* createScene() \
{ \
    CCScene *scene = CCScene::create(); \
    __TYPE__ *layer = __TYPE__::create(); \
    scene->addChild(layer); \
    return scene; \
}

using namespace cocos2d;

class WGLayer: public cocos2d::CCLayer{
public:
    
    virtual bool init();
    virtual void myInit();
    
    CREATE_FUNC(WGLayer);
    CREATE_FUNC_CCSCENE(WGLayer);
    
    virtual ~WGLayer();
    
    CC_PROPERTY(bool, allowTouch, AllowTouch);
    
    void setMyPriority(int priority);

    void registerWithTouchDispatcher();
    virtual bool  ccTouchBegan(CCTouch *pTouch,CCEvent *pEvent);
    virtual void ccTouchMoved(CCTouch *pTouch,CCEvent *pEvent);
    virtual void ccTouchEnded(CCTouch *pTouch,CCEvent *pEvent);

protected:
    void prePlayBackGroundMusic( const char *pName);
    void playBGMusic(const char *pName);
    void pauseBGMusic();
    void resumeBGMusic();
    void stopBGMusic();
    bool isBGMusicPlaying();
    void prePlaySoundEffect(const char *pName...);
    void playSoundEffect(const char *pName,bool record);
    void stopSoundEffect();
    unsigned int soundId = kSoundNoBuffer;
};

#endif /* defined(__Learn__WGLayer__) */
