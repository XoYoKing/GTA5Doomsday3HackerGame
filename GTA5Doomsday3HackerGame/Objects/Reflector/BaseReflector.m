//
//  BaseReflector.m
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/28.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "BaseReflector.h"
#import "LazerParticle.h"

@implementation BaseReflector

- (CGFloat)realZRotation {
    return self.zRotation;
}

- (void)addHiddenChildren {
    // add children
}

- (BOOL)simpleIntersectsNode:(SKNode *)node {
    return CGRectIntersectsRect(self.frame, node.frame);
}

- (BOOL)accurateIntersectsNode:(SKNode *)node {
    if (![self simpleIntersectsNode:node]) {
        return NO;
    }
    NSArray *children = self.children;
    for (SKSpriteNode *hiddenNode in children) {
        CGPoint pointToParent = [self convertPoint:hiddenNode.position toNode:self.parent];
        CGRect frameToParent = CGRectMake(pointToParent.x - hiddenNode.size.width / 2, pointToParent.y - hiddenNode.size.height / 2, hiddenNode.size.width, hiddenNode.size.height);
        if (CGRectIntersectsRect(frameToParent, node.frame)) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)intersectsNode:(SKNode *)node {
    return [self accurateIntersectsNode:node];
}

- (void)testWithObject:(BaseSprite *)object {
    if (![self intersectsNode:object]) {
        return;
    }
    if (![object isMemberOfClass:[LazerParticle class]]) {
        return;
    }
    // 如何计算斜边上的反射？
    LazerParticle *laz = (LazerParticle *)object;
    if (laz.hitObjects.lastObject == self) {
        return;
    }
    
    ZZLine lazLine = ZZLineMake(laz.position.x, laz.position.y, laz.zRotation);
    
    CGFloat selfRealRotation = self.realZRotation;
    ZZLine selfLine = ZZLineMake(self.position.x, self.position.y, selfRealRotation);
    
    CGPoint intersectionPoint = CGPointIntersectionFromLines(lazLine, selfLine);
    if (!CGRectContainsPoint(self.frame, intersectionPoint)) {
        return;
    }
    
    CGFloat reflectedZRotation = (selfRealRotation - laz.zRotation) + selfRealRotation;
    CGFloat deltaRotation = reflectedZRotation - laz.zRotation + M_PI;
    CGPoint reflectedPosition = CGPointRotatePoint(laz.position, intersectionPoint, deltaRotation);
    
    laz.zRotation = reflectedZRotation;
    laz.position = reflectedPosition;
    
    [laz.hitObjects addObject:self];
    
    //    BaseSprite *testPointSpr = [BaseSprite spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(2, 2)];
    //    testPointSpr.position = intersectionPoint;
    //    [self.parent addChild:testPointSpr];
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [testPointSpr removeFromParent];
    //    });
    
}

@end
