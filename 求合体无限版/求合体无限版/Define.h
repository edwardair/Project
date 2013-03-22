//
//  Define.h
//  求合体无限版
//
//  Created by ZYJ on 13-3-11.
//
//


#pragma mark OneObject Class Define
typedef enum kObjectType :int {
    LVEmpty = 0,
    LV1 = 1,
    LV2,
    LV3,
    LV4,
    LV5,
    LV6,
    LV7,
    LVEND,
}kObjectType;

#define ContainerPos ccp(winWidth()/2, winHeight()-10-25)
#define MinXEdge (int )PointOfLeftUpCorner.x
#define MaxXEdge (int )PointOfLeftUpCorner.x+PicWidth*LineCount
#define MinYEdge (int )PointOfLeftUpCorner.y
#define MaxYEdge (int )PointOfLeftUpCorner.y-PicWidth*LineCount

#pragma mark WorldPointDic Class Define
#define PointOfLeftUpCorner ccp(35,335)
#define LineCount 6
#define PicWidth 50
//#define WorldEmpty 0
#define PointKey(p) [NSString stringWithFormat:@"ccp(%d,%d)",(int )p.x,(int )p.y]

#pragma mark MapShow Class Define
//L left; R right; U up;D down 代表哪个口是开的
// eg: R  左封闭右开口；
// UD 为上下通 ;LR 为左右通
//enum{
//    Full = -1,          //-1  代表此位置四周都有物品存在
//    Empty,              //0
//    UDLR,               //1 上下左右  代表四周都‘不’开口
//    U,D,L,R,            //2,3,4,5
//    UD,LR,              //6,7
//    RU,RD,LU,LD,        //8,9,10,11
//    ULR,DLR,RUD,LUD,    //12,13,14,15
//};

#define Full @"F"
#define Empty @"E"
#define U @"U"
#define D @"D"
#define L @"L"
#define R @"R"
#define UD @"UD"
#define LR @"LR"
#define UR @"UR"
#define DR @"DR"
#define UL @"UL"
#define DL @"DL"
#define ULR @"ULR"
#define DLR @"DLR"
#define UDR @"UDR"
#define UDL @"UDL"
#define UDLR @"UDLR"

#define Name(x,y) [NSString stringWithFormat:@"%dx%d",x,y]

//根据名字name 获取相对应坐标
#define NameArray(name) [name componentsSeparatedByString:@"x"]
#define BlockXFlg(name) [[NameArray(name) objectAtIndex:0] intValue]
#define BlockYFlg(name) [[NameArray(name) objectAtIndex:1] intValue]
#define BlockPosition(name) ccpAdd(PointOfLeftUpCorner, ccp(BlockXFlg(name)*PicWidth, -BlockYFlg(name)*PicWidth))
