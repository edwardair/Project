//
//  RayCast.h
//  hitDouDou-Universal
//
//  Created by ZYJ on 12-11-1.
//
//

#ifndef hitDouDou_Universal_RayCast_h
#define hitDouDou_Universal_RayCast_h


#import "Box2D.h"
//#import "PolygonSprite.h"

class RaycastCallback : public b2RayCastCallback
{
public:
    RaycastCallback(){
    }
    
    float32 ReportFixture(b2Fixture *fixture,const b2Vec2 &point,const b2Vec2 &normal,float32 fraction)
    {
        PolygonSprite *ps = (PolygonSprite*)fixture->GetBody()->GetUserData();
        if (!ps.sliceEntered)
        {
            ps.sliceEntered = YES;
            
            //you need to get the point coordinates within the shape
            ps.entryPoint  = ps.body->GetLocalPoint(point);
            
            ps.sliceEntryTime = CACurrentMediaTime() + 1;
            CCLOG(@"Slice Entered at world coordinates:(%f,%f), polygon coordinates:(%f,%f)", point.x*PTM_RATIO, point.y*PTM_RATIO, ps.entryPoint.x*PTM_RATIO, ps.entryPoint.y*PTM_RATIO);
        }
        else if (!ps.sliceExited)
        {
            ps.exitPoint = ps.body->GetLocalPoint(point);
            ps.sliceExited = YES;
            
            CCLOG(@"Slice Exited at world coordinates:(%f,%f), polygon coordinates:(%f,%f)", point.x*PTM_RATIO, point.y*PTM_RATIO, ps.exitPoint.x*PTM_RATIO, ps.exitPoint.y*PTM_RATIO);
        }
        return 1;
    }
};

#endif
