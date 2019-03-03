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

bool CGRectIntersectsLine(CGRect rect, ZZLine line) {
    CGFloat testStep = rect.size.height > rect.size.width ? rect.size.width : rect.size.height; // 用矩形的最小边长来测试
    if (CGRectContainsPoint(rect, CGPointMake(line.x, line.y))) {
        return true;
    }
    for (CGFloat currentStep = 0; currentStep < 10000; currentStep += testStep) {
        CGPoint point = CGPointMake(line.x + currentStep * cos(line.alpha), line.y + currentStep * sin(line.alpha));
        if (CGRectContainsPoint(rect, point)) {
            return true;
        }
    }
    return false;
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
    return CGPointMake(round(xValue), round(yValue)); // 四舍五入
}

CGPoint CGPointIntersectionFromRectToLine(CGRect rect, ZZLine line) {
    CGPoint rectOriginPoint = rect.origin;
    CGPoint rectDiagonalPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    
    ZZLine l1 = ZZLineMake(rectOriginPoint.x, rectOriginPoint.y, 0);
    ZZLine l2 = ZZLineMake(rectOriginPoint.x, rectOriginPoint.y, M_PI_2);
    ZZLine l3 = ZZLineMake(rectDiagonalPoint.x, rectDiagonalPoint.y, 0);
    ZZLine l4 = ZZLineMake(rectDiagonalPoint.x, rectDiagonalPoint.y, M_PI_2);
    
    CGRect biggerRect = CGRectInset(rect, -1, -1);
    
    CGPoint selectedPoint = CGPointNotFound;
    CGFloat minDistance = 10000000;
    
    bool isInside = CGRectContainsPoint(rect, CGPointMake(line.x, line.y));
    
    ZZLine lines[4] = {l1, l2, l3, l4};
    for (int i = 0; i < 4; i ++) {
        ZZLine tl = lines[i];
        CGPoint intersectPoint = CGPointIntersectionFromLines(tl, line);
        if (CGRectContainsPoint(biggerRect, intersectPoint)) {
            
            // 如果起点在矩形外，那么去距离最近的点便可；若在内，则很根据方向判断
//            if (isInside) {
//                // 起点在内，做一个测试的矩形测试一下一下情况
//                CGRect testRect = CGRectZero;
//                testRect.origin = intersectPoint;
//                testRect = CGRectInset(testRect, -1, -1);
//                if (CGRectIntersectsLine(testRect, line)) {
//                    selectedPoint = intersectPoint;
//                    break;
//                }
//            } else {
                CGFloat dist = CGDistanceFromPoints(CGPointMake(line.x, line.y), intersectPoint);
                if (dist < minDistance) {
                    minDistance = dist;
                    selectedPoint = intersectPoint;
//                }
            }
        }
    }
    return selectedPoint;
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

CGPoint CGPointRotateVector(CGPoint vector, CGFloat radius)
{
    CGFloat x = vector.x * cos(radius) - vector.y * sin(radius);
    CGFloat y = vector.x * sin(radius) + vector.y * cos(radius);
    return CGPointMake(x, y);
}


CGPoint CGPointRotatePoint(CGPoint targetPoint, CGPoint originPoint, CGFloat radius) {
    CGPoint tempVector = CGPointMake(targetPoint.x - originPoint.x, targetPoint.y - originPoint.y);
    CGPoint rotatedVector = CGPointRotateVector(tempVector, radius);
    CGPoint newPoint = CGPointMake(rotatedVector.x + originPoint.x, rotatedVector.y + originPoint.y);
    return newPoint;
}
