//
//  NormalReflector.m
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/27.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "NormalReflector.h"
#import "LazerParticle.h"

@implementation NormalReflector {
    DirectionFacing _facing;
}

+ (instancetype)normalReflectorWithFacing:(DirectionFacing)facing position:(CGPoint)position {
    NormalReflector *reflec = [NormalReflector spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"NormalReflector"] size:OBJ_BLOCK_SIZE];
    reflec.position = position;
    if (facing == DirectionFacingQuadrantTwo) {
        reflec.zRotation = M_PI_2;
    } else if (facing == DirectionFacingQuadrantThree) {
        reflec.zRotation = M_PI;
    } else if (facing == DirectionFacingQuadrantFour) {
        reflec.zRotation = -M_PI_2;
    } else {
        reflec.zRotation = 0;
    }
    reflec.zRotation = reflec.zRotation - M_PI/3;
    reflec -> _facing = facing;
    return reflec;
}

- (void)testWithObject:(BaseSprite *)object {
    if (![super intersectsNode:object]) {
        return;
    }
    if (![object isKindOfClass:[LazerParticle class]]) {
        return;
    }
    // 如何计算斜边上的反射？
    LazerParticle *laz = (LazerParticle *)object;
    if (laz.hitObjects.lastObject == self) {
        return;
    }
    
    ZZLine lazLine = ZZLineMake(laz.position.x, laz.position.y, laz.zRotation);
    
    CGFloat selfRealRotation = self.zRotation - M_PI_4;
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
    
    BaseSprite *testPointSpr = [BaseSprite spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(2, 2)];
    testPointSpr.position = intersectionPoint;
    [self.parent addChild:testPointSpr];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [testPointSpr removeFromParent];
    });
    
}

@end
