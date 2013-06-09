//
//  WGDirector.cpp
//  Learn
//
//  Created by Apple on 13-6-5.
//
//

#include "WGDirector.h"

using namespace cocos2d;

CCSize WGDirector::winSize(){
    return Director->getWinSize();
}
float WGDirector::winCenterX(){
    return winSize().width/2;
}
float WGDirector::winCenterY(){
    return winSize().height/2;
}
CCPoint WGDirector::winCenter(){
    return CCPointMake(winCenterX(), winCenterY());
}
CCTexture2D* WGDirector::textureWithCString(const char *stringName){
    return CCTextureCache::sharedTextureCache()->addImage(stringName);
}
CCSpriteFrame* WGDirector::spriteFrameWithCString(const char *stringName){
    CCTexture2D *t = textureWithCString(stringName);
    return spriteFrameWithTexture(t);
}
CCSpriteFrame* WGDirector::spriteFrameWithTexture(CCTexture2D *texture){
    return CCSpriteFrame::createWithTexture(texture, CCRectMake(0, 0, texture->getContentSize().width, texture->getContentSize().height));
}




