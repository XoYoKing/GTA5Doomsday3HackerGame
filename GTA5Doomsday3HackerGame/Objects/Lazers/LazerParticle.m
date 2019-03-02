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
    BOOL drawed;
    __weak NSArray *testObjects;
}

+ (instancetype)lazerParticleWithZRotation:(CGFloat)zRotation position:(CGPoint)position {
    LazerParticle *par = [LazerParticle spriteNodeWithColor:[SKColor yellowColor] size:CGSizeMake(10, 10)];
    par->startZRotation = zRotation;
    par.position = position;
    return par;
}

- (void)run {
    if (drawed) {
        [self removeFromParent];
    }
}

- (void)testWithObjects:(NSArray *)objects {
    if (testObjects) {
        return;
    }
    if (drawed) {
        return;
    }
    drawed = YES;
    CGRect parentRect = self.parent.frame;
    parentRect.origin = CGPointZero;
    testObjects = objects;
    ZZLine lastLine = ZZLineMake(self.position.x, self.position.y, startZRotation);
    
    // 找出上述直线与objects的所有碰撞点，然后挑选最近的点为碰撞点作为下一个的起点
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
