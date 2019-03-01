//
//  LazerParticle.m
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/27.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "LazerParticle.h"
#import "BaseReflector.h"

@implementation LazerParticle {
    CGFloat startZRotation;
    __weak NSArray *testObjects;
}

+ (instancetype)lazerParticleWithZRotation:(CGFloat)zRotation position:(CGPoint)position {
    LazerParticle *par = [LazerParticle spriteNodeWithColor:[SKColor yellowColor] size:CGSizeMake(10, 10)];
    par->startZRotation = zRotation;
    par.position = position;
    return par;
}

- (void)run {
    [self drawAndCrash];
}

- (void)drawAndCrash {
    [self removeFromParent];
}

- (void)testWithObjects:(NSArray *)objects {
    if (testObjects) {
        return;
    }
    CGRect parentRect = self.parent.frame;
    parentRect.origin = CGPointZero;
    testObjects = objects;
    ZZLine lastLine = ZZLineMake(self.position.x, self.position.y, startZRotation);
    BaseSprite *lastObject = nil;
    for (BaseSprite *testObj in testObjects) {
        if (testObj == lastObject) {
            continue;
        }
        lastObject = testObj;
        CGPoint hitPoint = CGPointIntersectionFromLineToRect(lastLine, lastObject.frame);
        if (CGRectContainsPoint(parentRect, hitPoint)) {
            if ([lastObject isKindOfClass:[BaseReflector class]]) {
                BaseReflector *reflector = (BaseReflector *)lastObject;
                ZZLine newLine = [reflector getNewLineWithOldLine:lastLine];
                hitPoint = CGPointMake(newLine.x, newLine.y);
            }
            
            [self showPoint:hitPoint];
        } else {
            // end of lazer
        }
    }
}

- (void)showPoint:(CGPoint)point {
    BaseSprite *testPointSpr = [BaseSprite spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(4, 4)];
    testPointSpr.position = point;
    [self.parent addChild:testPointSpr];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [testPointSpr removeFromParent];
    });
}

@end
