//
//  CGTool.h
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/3/1.
//  Copyright © 2019 Jam. All rights reserved.
//

#ifndef CGTool_h
#define CGTool_h

#include <stdio.h>
#import <CoreGraphics/CoreGraphics.h>

/**
 * xy为原点（或直线上任意点），alpha为方向（0时指向右，逆时针为正方向）
 */
struct ZZLine {
    CGFloat x;
    CGFloat y;
    CGFloat alpha;
};
typedef struct ZZLine ZZLine;

CGFloat CGFloatABS(CGFloat value);

#define CGPointNotFound CGPointMake(-10000000, -10000000)

ZZLine ZZLineMake(CGFloat x, CGFloat y, CGFloat alpha);
bool ZZLineEqualsToLine(ZZLine line1, ZZLine line2);

bool CGRectIntersectsLine(CGRect rect, ZZLine line); // 检测直线是否交矩形，仅判断alpha方向
CGPoint CGPointIntersectionFromLines(ZZLine line1, ZZLine line2); // 两条直线的交点
CGPoint CGPointIntersectionFromRectToLine(CGRect rect, ZZLine line); // 直线与矩形的焦点，取距离最近的那个点
CGPoint CGPointCenterFromPoints(CGPoint point1, CGPoint point2); // 求中点
CGFloat CGDistanceFromPoints(CGPoint point1, CGPoint point2); // 两点间的距离
CGPoint CGPointOffsetVector(CGPoint point, CGPoint vector); // 点偏移
CGPoint CGPointOffset(CGPoint point, CGFloat dx, CGFloat dy); // 点偏移2
CGPoint CGPointRotateVector(CGPoint vector, CGFloat radius); // 向量旋转
CGPoint CGPointRotatePoint(CGPoint targetPoint, CGPoint originPoint, CGFloat radius); // 点饶点旋转

#endif /* CGTool_h */
