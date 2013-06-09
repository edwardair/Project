//
//  HeTi.cpp
//  Learn
//
//  Created by Apple on 13-6-5.
//
//

#include "HeTi.h"
#include "TPClass.h"
using namespace cocos2d;

#define key(i,j)  CCString::createWithFormat("%d*%d",i,j)->getCString()

void HeTi::myInit(){
    glClearColor(1, 1, 1, 1);
        
    allSprites = new CCDictionary();

    for (int i = 0;i<6;i++) {
        for (int j = 0; j<6; j++) {
            TPClass *sp = TPClass::spriteWithFile("Map_0.png");
            this->addChild(sp);
            sp->x = i;
            sp->y = j;
            CCSize size = WinSize;
            sp->CCNode::setPosition((size.width-600)/2.0+50+j*100,700-i*100);
            sp->addTarget_Selcetor(this, callfuncN_selector(HeTi::call_Clicked));
            
            if (i==0) {
                sp->setUp(upCount);
            }else if (i==5){
                sp->setDown(downCount);
            }
            if (j==0) {
                sp->setLeft(leftCount);
            }else if (j==5){
                sp->setRight(rightCount);
            }

            allSprites->setObject(sp, key(i, j));

        }
    }
    
    changeDisplayFrame();
    
}
HeTi::~HeTi(){
    allSprites->release();
}
void HeTi::call_Clicked(TPClass *sp){
    if (sp->full) {
        sp->full = false;
        sp->setUp(0);
        sp->setLeft(0);
        sp->setRight(0);
        sp->setDown(0);
    }else{
        sp->setUp(upCount);
        sp->setLeft(leftCount);
        sp->setRight(rightCount);
        sp->setDown(downCount);

        sp->full = true;

    }
    
    recursionFromFirstTP(sp);
    
    changeDisplayFrame();
    
    checkCorners();
}

void HeTi::changeDisplayFrame(){
    CCArray *keys = allSprites->allKeys();
    for (int i = 0; i < keys->count(); i++) {
        CCString *key =(CCString *)keys->objectAtIndex(i);
        TPClass *sp = (TPClass *)allSprites->objectForKey(key->getCString());
        int sum = sp->getSum();
        sum = sum>15?15:sum;
        CCString *pName = CCString::createWithFormat("Map_%d.png",sum);
        if (sp->full) {
            pName = CCString::create("Map_F.png");
        }
        CCSpriteFrame *frame = WGDirector::spriteFrameWithCString(pName->getCString());
        sp->setDisplayFrame(frame);
        
    }
}

void HeTi::recursionFromFirstTP(TPClass *sp){
    int a[4] = {-1,1,0,0};//上下右左 四个方向
    bool full = sp->full;
    for (int i = 0; i < 4; i++) {
        TPClass *temp = NULL;
        temp = (TPClass *)allSprites->objectForKey(key(sp->x+a[i], sp->y+a[3-i]));

        if (temp) {
            switch (i) {
                case 0:
                {
                    if (full) {
                        temp->setDown(downCount);
                    }else{
                        if (temp->full) {
                            sp->setUp(upCount);
                        }else{
                            temp->setDown(0);
                        }
                    }
                }
                    break;
                case 1:
                {
                    if (full) {
                        temp->setUp(upCount);
                    }else{
                        if (temp->full) {
                            sp->setDown(downCount);
                        }else{
                            temp->setUp(0);
                        }
                    }
                }
                    break;
                case 2:
                {
                    if (full) {
                        temp->setLeft(leftCount);
                    }else{
                        if (temp->full) {
                            sp->setRight(rightCount);
                        }else{
                            temp->setLeft(0);
                        }
                    }
                }
                    break;
                case 3:
                {
                    if (full) {
                        temp->setRight(rightCount);
                    }else{
                        if (temp->full) {
                            sp->setLeft(leftCount);
                        }else{
                            temp->setRight(0);
                        }
                    }
                }
                    break;
                default:
                    break;
            }
        }
    }
}



void HeTi::checkCorners(){
    for (int i = 0; i < 6; i++) {
        for (int j = 0; j < 6; j++) {
            TPClass *curTP = (TPClass *)allSprites->objectForKey(key(i, j));
            TPClass *lu = (TPClass *)allSprites->objectForKey(key(i-1, j-1));
            TPClass *ru = (TPClass *)allSprites->objectForKey(key(i-1, j+1));
            TPClass *ld = (TPClass *)allSprites->objectForKey(key(i+1, j-1));
            TPClass *rd = (TPClass *)allSprites->objectForKey(key(i+1, j+1));

            if (lu &&
                (curTP->getLeft()+curTP->getUp())==0 &&
                lu ->getSum()==15
                ) {
                curTP->overDraw(0);
            }
            if (ru &&
                (curTP->getRight()+curTP->getUp())==0 &&
                ru ->getSum()==15
                ) {
                curTP->overDraw(1);
            }
            if (ld &&
                (curTP->getLeft()+curTP->getDown())==0 &&
                ld ->getSum()==15
                ) {
                curTP->overDraw(3);
            }
            if (rd &&
                (curTP->getRight()+curTP->getDown())==0 &&
                rd ->getSum()==15
                ) {
                curTP->overDraw(2);
            }
        }
    }
}

