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

 struct ZZLine {
    CGFloat x;
    CGFloat y;
    CGFloat alpha;
};
typedef struct ZZLine ZZLine;

#define CGPointNotFound CGPointMake(CGFLOAT_MIN, CGFLOAT_MIN)

ZZLine ZZLineMake(CGFloat x, CGFloat y, CGFloat alpha);

CGFloat CGDistanceFromPoints(CGPoint point1, CGPoint point2);
CGPoint CGPointOffsetVector(CGPoint point, CGPoint vector);
CGPoint CGPointOffset(CGPoint point, CGFloat dx, CGFloat dy);
CGPoint CGPointIntersectionFromLines(ZZLine line1, ZZLine line2);
CGPoint CGPointIntersectionFromLineToRect(ZZLine line, CGRect rect);
CGPoint CGPointRotateVector(CGPoint vector, CGFloat radius);
CGPoint CGPointRotatePoint(CGPoint targetPoint, CGPoint originPoint, CGFloat radius);

#endif /* CGTool_h */
