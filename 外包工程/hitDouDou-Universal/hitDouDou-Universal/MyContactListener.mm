//
//  MyContactListener.m
//  Box2DPong
//
//  Created by Ray Wenderlich on 2/18/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "MyContactListener.h"
#import "creatBallSprite.h"
#import "CreateFixture.h"
#import "BasicBody.h"
MyContactListener::MyContactListener() : _contacts() {
}

MyContactListener::~MyContactListener() {
}
BOOL bodyIsBasicBody(b2Fixture *fixture){
    CCSprite *sp = (CCSprite *)fixture->GetUserData();
    if ([sp isMemberOfClass:[BasicBody class]] || [sp isMemberOfClass:[CreateFixture class]]) {
        return YES;
    }
    else return NO;
}

void MyContactListener::BeginContact(b2Contact* contact) {
    // We need to copy out the data because the b2Contact passed in
    // is reused.
    MyContact myContact = { contact->GetFixtureA(), contact->GetFixtureB() };

    b2Fixture *fixtureA_,*fixtureB_;
    fixtureA_ = contact->GetFixtureA();
    fixtureB_ = contact->GetFixtureB();
    
    if (bodyIsBasicBody(fixtureA_)) {
        CCSprite *sp = (CCSprite *)fixtureB_->GetBody()->GetUserData();
        if ([sp isMemberOfClass:[creatBallSprite class]]) {
            myContact.theBallVelocity = fixtureB_->GetBody()->GetLinearVelocity();
        }
    }else if (bodyIsBasicBody(fixtureB_)){
        CCSprite *sp = (CCSprite *)fixtureA_->GetBody()->GetUserData();
        if ([sp isMemberOfClass:[creatBallSprite class]]) {
            myContact.theBallVelocity = fixtureA_->GetBody()->GetLinearVelocity();
        }
    }
    _contacts.push_back(myContact);
}

void MyContactListener::EndContact(b2Contact* contact) {
    MyContact myContact = { contact->GetFixtureA(), contact->GetFixtureB() };
    std::vector<MyContact>::iterator pos;
    pos = std::find(_contacts.begin(), _contacts.end(), myContact);
    
    if (pos != _contacts.end()) {
        _contacts.erase(pos);
    }
}

void MyContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold) {
}
void MyContactListener::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse) {
}

