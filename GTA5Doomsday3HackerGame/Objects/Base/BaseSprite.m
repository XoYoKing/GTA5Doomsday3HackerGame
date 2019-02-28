//
//  BaseSprite.m
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/27.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "BaseSprite.h"
#import "LazerParticle.h"

ZZLine ZZLineMake(CGFloat x, CGFloat y, CGFloat alpha) {
    ZZLine line;
    line.x = x;
    line.y = y;
    line.alpha = alpha;
    return line;
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

CGPoint CGPointRotatePoint(CGPoint targetPoint, CGPoint originPoint, CGFloat radius) {
    CGPoint tempVector = CGPointMake(targetPoint.x - originPoint.x, targetPoint.y - originPoint.y);
    CGPoint rotatedVector = CGPointRotateVector(tempVector, radius);
    CGPoint newPoint = CGPointMake(rotatedVector.x + originPoint.x, rotatedVector.y + originPoint.y);
    return newPoint;
}

@implementation BaseSprite

- (void)run {
    // do nothing
}

- (void)crash {
    // do nothing
}

- (void)testWithObject:(BaseSprite *)object {
    if ([self intersectsNode:object] && [object isMemberOfClass:[LazerParticle class]] && ![self isMemberOfClass:[LazerParticle class]]) {
        [object crash];
    }
}

- (BOOL)intersectsNode:(SKNode *)node {
    return CGRectIntersectsRect(self.frame, node.frame);
}

@end
