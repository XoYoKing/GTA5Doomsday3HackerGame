//
//  CGTool.c
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/3/1.
//  Copyright © 2019 Jam. All rights reserved.
//

#include "CGTool.h"

CGFloat CGFloatABS(CGFloat value) {
    if (value < 0) {
        value = value * -1;
    }
    return value;
}

ZZLine ZZLineMake(CGFloat x, CGFloat y, CGFloat alpha) {
    ZZLine line;
    line.x = x;
    line.y = y;
    line.alpha = alpha;
    return line;
}

bool ZZLineEqualsToLine(ZZLine line1, ZZLine line2) {
    return line1.x == line2.x && line1.y == line2.y && line1.alpha == line2.alpha;
}

bool CGRectIntersectsLine(CGRect rect, ZZLine line) {
    CGPoint rectOriginPoint = rect.origin;
    CGPoint rectDiagonalPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    
    ZZLine l1 = ZZLineMake(rectOriginPoint.x, rectOriginPoint.y, 0);
    ZZLine l2 = ZZLineMake(rectOriginPoint.x, rectOriginPoint.y, M_PI_2);
    ZZLine l3 = ZZLineMake(rectDiagonalPoint.x, rectDiagonalPoint.y, 0);
    ZZLine l4 = ZZLineMake(rectDiagonalPoint.x, rectDiagonalPoint.y, M_PI_2);
    
    CGRect biggerRect = CGRectInset(rect, -1, -1); // 放大一点的，避免不够精确引起的误差
    
    ZZLine lines[4] = {l1, l2, l3, l4};
    for (int i = 0; i < 4; i ++) {
        ZZLine tl = lines[i];
        CGPoint intersectPoint = CGPointIntersectionFromLines(tl, line);
        if (CGRectContainsPoint(biggerRect, intersectPoint)) { // 碰撞点是否在框内
            return YES;
        }
    }
    return NO;
}

CGPoint CGPointIntersectionFromLines(ZZLine line1, ZZLine line2) {
    // y = k * x + c; k = tan@;
    
    CGFloat k1 = tan(line1.alpha);
    CGFloat c1 = line1.y - k1 * line1.x;
    CGFloat k2 = tan(line2.alpha);
    CGFloat c2 = line2.y - k2 * line2.x;
    
    if (k1 == k2) { // 平行的不存在交点
        return CGPointNotFound;
    }
    // 如果k无穷大或0，则是特殊情况
    
    CGFloat xValue = (c2 - c1) / (k1 - k2);
    CGFloat yValue;
    if (CGFloatABS(k1) > CGFloatABS(k2)) { // 选一个斜率小的来计算y值
        yValue = k2 * xValue + c2;
    } else {
        yValue = k1 * xValue + c1;
    }
    return CGPointMake((xValue), (yValue)); // 四舍五入
}

CGPoint CGPointIntersectionFromRectToLine(CGRect rect, ZZLine line) {
    CGPoint rectOriginPoint = rect.origin;
    CGPoint rectDiagonalPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    
    ZZLine l1 = ZZLineMake(rectOriginPoint.x, rectOriginPoint.y, 0);
    ZZLine l2 = ZZLineMake(rectOriginPoint.x, rectOriginPoint.y, M_PI_2);
    ZZLine l3 = ZZLineMake(rectDiagonalPoint.x, rectDiagonalPoint.y, 0);
    ZZLine l4 = ZZLineMake(rectDiagonalPoint.x, rectDiagonalPoint.y, M_PI_2);
    
    CGRect biggerRect = CGRectInset(rect, -1, -1); // 放大一点的，避免不够精确引起的误差
    
    CGPoint selectedPoint = CGPointNotFound;
    CGFloat minDistance = 10000000;

    ZZLine lines[4] = {l1, l2, l3, l4};
    for (int i = 0; i < 4; i ++) {
        ZZLine tl = lines[i];
        CGPoint intersectPoint = CGPointIntersectionFromLines(tl, line);
        if (CGRectContainsPoint(biggerRect, intersectPoint)) { // 碰撞点是否在框内
            // 判断点的方向是否正确，再判断点的距离是否最近
            CGFloat dist = CGDistanceFromPoints(CGPointMake(line.x, line.y), intersectPoint);
            CGFloat cosdx = (intersectPoint.x - line.x) / dist;
            CGFloat sindy = (intersectPoint.y - line.y) / dist;
            
            if ((cosdx * cos(line.alpha)) >= 0 && (sindy * sin(line.alpha)) >= 0) {
                if (dist < minDistance) {
                    minDistance = dist;
                    selectedPoint = intersectPoint;
                }
            }
        }
    }
    // 排除擦边情况
    // 如果交点在四个角附近，要判断是否擦边
    if (!CGPointEqualToPoint(selectedPoint, CGPointNotFound)) {
        CGFloat tolerance = 1.0;
        CGFloat testDistance = rect.size.width * 0.5 * M_SQRT2 - tolerance; // 我假设它是正方形（此游戏只用到正方形），其他比例比较复杂，。。。
        CGPoint centerPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
        // 求点与直线的距离
        // y = kx + b
        CGFloat k = tan(line.alpha);
        if (k > 10000000) { // k不存在
            if (CGFloatABS(line.x - centerPoint.x) > testDistance) {
                selectedPoint = CGPointNotFound;
            }
        } else {
            CGFloat b = line.y - k * line.x;
            // Ax + By + C = 0
            CGFloat A = k;
            CGFloat B = -1;
            CGFloat C = b;
            CGFloat dis = CGFloatABS(A * centerPoint.x + B * centerPoint.y + C) / sqrt(A * A + B * B);
            if (dis > testDistance) {
                selectedPoint = CGPointNotFound;
            }
        }
    }
    
    return selectedPoint;
}

CGPoint CGPointCenterFromPoints(CGPoint point1, CGPoint point2) {
    return CGPointMake((point1.x + point2.x) / 2, (point1.y + point2.y) / 2);
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
