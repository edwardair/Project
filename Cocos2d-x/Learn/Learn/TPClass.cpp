//
//  TPSprite.cpp
//  Learn
//
//  Created by Apple on 13-6-5.
//
//

#include "TPClass.h"

int TPClass::getSum(){
    return (left+right+up+down);
}
void TPClass::setSum(int var){
    sum = (left+right+up+down);
}
int TPClass::getUp(){
    return up;
}
void TPClass::setUp(int var){
    //不管var传过来的值为多少，上下左右的值为定值（除0外）
    up =  (var!=0)||(var==0&&x==0)?upCount:var;//(var!=0 ? upCount : (x>0 ? var : upCount));
}
int TPClass::getDown(){
    return down;
}
void TPClass::setDown(int var){
    down =  (var!=0)||(var==0&&x==5)?downCount:var;//(var!=0 ? downCount : (x<5 ? var : downCount));
}
int TPClass::getLeft(){
    return left;
}
void TPClass::setLeft(int var){
    left = (var!=0)||(var==0&&y==0)?leftCount:var;//(var!=0 ? leftCount : (y>0 ? var : leftCount));
}
int TPClass::getRight(){
    return right;
}
void TPClass::setRight(int var){
    right = (var!=0)||(var==0&&y==5)?rightCount:var;// (var!=0 ? var : (x<5 ? var : right));
}

void TPClass::overDraw(int type_){
    CCRenderTexture *render = CCRenderTexture::create(this->getContentSize().width, this->getContentSize().height);
    CCSprite *b = CCSprite::create("Map_B.png");
    b->setPosition(ccp(this->getContentSize().width/2, this->getContentSize().height/2));
    b->setRotation(90.0*type_);

    CCPoint temp = this->getPosition();
    CCPoint tempAn = this->getAnchorPoint();
    this->setAnchorPoint(CCPointZero);
    this->setPosition(CCPointZero);

    render->begin();
    b->visit();
    this->visit();
    render->end();
    
    this->setAnchorPoint(tempAn);
    this->setPosition(temp);
    
    CCTexture2D *t  = CCTextureCache::sharedTextureCache()->addUIImage(render->newCCImage(), NULL);
    this->setDisplayFrame(WGDirector::spriteFrameWithTexture(t));

}
