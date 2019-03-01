//
//  CGTool.c
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/3/1.
//  Copyright © 2019 Jam. All rights reserved.
//

#include "CGTool.h"

ZZLine ZZLineMake(CGFloat x, CGFloat y, CGFloat alpha) {
    ZZLine line;
    line.x = x;
    line.y = y;
    line.alpha = alpha;
    return line;
}

CGFloat CGDistanceFromPoints(CGPoint point1, CGPoint point2) {
    CGFloat dx = point1.x - point2.x;
    CGFloat dy = point1.y - point2.y;
    return sqrt(dx * dx + dy * dy);
}

CGPoint CGPointOffsetVector(CGPoint point, CGPoint vector) {
    return CGPointMake(point.x + vector.x, point.y + vector.y);
}

CGPoint CGPointOffset(CGPoint point, CGFloat dx, CGFloat dy) {
    return CGPointMake(point.x + dx, point.y + dy);
}

CGPoint CGPointIntersectionFromLines(ZZLine line1, ZZLine line2) {
    // y = k * x + c; k = tan@;
    
    CGFloat k1 = tan(line1.alpha);
    CGFloat c1 = line1.y - k1 * line1.x;
    CGFloat k2 = tan(line2.alpha);
    CGFloat c2 = line2.y - k2 * line2.x;
    
    if (k1 == k2) {
        return CGPointNotFound;
    }
    
    CGFloat xValue = (c2 - c1) / (k1 - k2);
    CGFloat yValue = k1 * xValue + c1;
    return CGPointMake(xValue, yValue);
}

CGPoint CGPointRotateVector(CGPoint vector, CGFloat radius)
{
    CGFloat x = vector.x * cos(radius) - vector.y * sin(radius);
    CGFloat y = vector.x * sin(radius) + vector.y * cos(radius);
    return CGPointMake(x, y);
}

CGPoint CGPointIntersectionFromLineToRect(ZZLine line, CGRect rect) {
    CGPoint rectOriginPoint = rect.origin;
    CGPoint rectDiagonalPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    
    ZZLine l1 = ZZLineMake(rectOriginPoint.x, rectOriginPoint.y, 0);
    ZZLine l2 = ZZLineMake(rectOriginPoint.x, rectOriginPoint.y, M_PI_2);
    ZZLine l3 = ZZLineMake(rectDiagonalPoint.x, rectDiagonalPoint.y, 0);
    ZZLine l4 = ZZLineMake(rectDiagonalPoint.x, rectDiagonalPoint.y, M_PI_2);
    
    CGRect biggerRect = CGRectInset(rect, -1, -1);
    
    CGPoint selectedPoint = CGPointZero;
    CGFloat minDistance = 10000000;
    
    ZZLine lines[4] = {l1, l2, l3, l4};
    for (int i = 0; i < 4; i ++) {
        ZZLine tl = lines[0];
        CGPoint interPoint = CGPointIntersectionFromLines(tl, line);
        if (CGRectContainsPoint(biggerRect, interPoint)) {
            CGFloat dist = CGDistanceFromPoints(CGPointMake(line.x, line.y), interPoint);
            if (dist < minDistance) {
                minDistance = dist;
                selectedPoint = interPoint;
            }
        }
    }
    return selectedPoint;
}

CGPoint CGPointRotatePoint(CGPoint targetPoint, CGPoint originPoint, CGFloat radius) {
    CGPoint tempVector = CGPointMake(targetPoint.x - originPoint.x, targetPoint.y - originPoint.y);
    CGPoint rotatedVector = CGPointRotateVector(tempVector, radius);
    CGPoint newPoint = CGPointMake(rotatedVector.x + originPoint.x, rotatedVector.y + originPoint.y);
    return newPoint;
}
