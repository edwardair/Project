#include "HelloWorldScene.h"
#include "SimpleAudioEngine.h"

#include "Test.h"
#include "WGCocos2d.h"
using namespace cocos2d;
using namespace CocosDenshion;

CCScene* HelloWorld::scene()
{
    // 'scene' is an autorelease object
    CCScene *scene = CCScene::create();
    
    // 'layer' is an autorelease object
    HelloWorld *layer = HelloWorld::create();

    // add layer as a child to scene
    scene->addChild(layer);

    // return the scene
    return scene;
}
// on "init" you need to initialize your instance
bool HelloWorld::init()
{
    //////////////////////////////
    // 1. super init first
    if ( !CCLayer::init() )
    {
        return false;
    }
    
    glClearColor(1, 1, 1, 1);

    CCSprite *sprite = CCSprite::create("CloseNormal.png");
    this->addChild(sprite);
    sprite->setPosition(ccp(240, 160));
    sprite->setScale(2.f);
    CCSize ss = sprite->getContentSize();
    CCOrbitCamera *orbit = CCOrbitCamera::create(5.f, 5.f, 0, 0, 360, 90, -45);
    CCMoveBy *moveBy = CCMoveBy::create(5.f, ccp(100, 0));
    sprite->runAction(CCSequence::create(orbit,moveBy));
    
    CCArray *array = CCArray::create();
    array->addObject(this);
    
    CCDirector::sharedDirector()->getScheduler()->scheduleSelector(schedule_selector(HelloWorld::updateabc), this, 2.f, false);
    
    CCMenuItemImage *i = CCMenuItemImage::create("CloseNormal.png", NULL, this, menu_selector(HelloWorld::clicked));
    CCMenu *menu = CCMenu::create(i,NULL);
    menu->setPosition(100, 100);
    this->addChild(menu);
    
    CCTexture2D *t = WGDirector::textureWithCString("Map_6.png");
    CCSprite *sp = CCSprite::createWithTexture(t);
    this->addChild(sp);
    
    
    return true;
}

void HelloWorld::updateabc(){
    CCLog("update");
}
void HelloWorld::clicked(){
    
//    CCScene *scene = CCScene::create();
//    Test *test = Test::create();
//    scene->addChild(test);
    
//    CCScene *scene = Test::createScene();
    CCScene *scene = Test::createScene();
    CCDirector::sharedDirector()->replaceScene(scene);
        
}
void HelloWorld::menuCloseCallback(CCObject* pSender)
{
    CCDirector::sharedDirector()->end();

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    exit(0);
#endif
}
