//
//  LazerParticle.m
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/27.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "LazerSource.h"
#import "LazerParticle.h"
#import "BaseReflector.h"
#import "AutoReflector.h"
#import "BasePacket.h"
#import "FirePacket.h"

@implementation LazerParticle {
    CGFloat startZRotation;
    BOOL drawed;
    __weak NSArray *testObjects;
}

+ (instancetype)lazerParticleWithZRotation:(CGFloat)zRotation position:(CGPoint)position {
    LazerParticle *par = [LazerParticle node];
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
    
    // 找出上述直线与objects的所有碰撞点，然后挑选最近的点为碰撞点作为下一个的起点
    ZZLine lastLine = ZZLineMake(self.position.x, self.position.y, startZRotation); // 射线和反射线
    BaseSprite *lastHitSpr = nil; // 撞到的物体
    
    BOOL ended = NO;
    NSInteger testTime = 0;
    while (!ended) {
        testTime ++;
        if (testTime > 100) { // 防止死循环
            ended = YES;
            break;
        }
        CGFloat testMinDistance = 1000000;
        CGPoint thisHitPoint = CGPointNotFound;
        NSMutableArray *objectsWithoutLastOne = [NSMutableArray arrayWithArray:testObjects];
        if (lastHitSpr) {
            [objectsWithoutLastOne removeObject:lastHitSpr]; // 移除上次撞过的物体（通常是Reflector），防止重复检测
        }
        BaseSprite *thisHitSpr = nil;
        for (BaseSprite *tSpr in objectsWithoutLastOne) {
            CGRect testRect = tSpr.frame;
            CGPoint hitPoint = CGPointIntersectionFromRectToLine(testRect, lastLine);
            if (!CGPointEqualToPoint(hitPoint, CGPointNotFound)) { // 看看他们是否有机会撞上
                if ([tSpr isKindOfClass:[BaseReflector class]]) { // Reflector反应
                    ZZLine thisReflectedLine = [((BaseReflector*)tSpr) getNewLineWithOldLine:lastLine];
                    if (ZZLineEqualsToLine(thisReflectedLine, lastLine)) { // 无反射现象就直接下一个
                        continue;
                    }
                    if ([tSpr isMemberOfClass:[AutoReflector class]]) {
                        // 是特殊拐弯射线
                    } else {
                        // 是镜子反射
                        hitPoint = CGPointMake(thisReflectedLine.x, thisReflectedLine.y);
                    }
                }
//                [self showPoint:hitPoint]; // 显示可能的所有碰撞点
                CGFloat thisDistance = CGDistanceFromPoints(CGPointMake(lastLine.x, lastLine.y), hitPoint);
                if (thisDistance < testMinDistance) {
                    testMinDistance = thisDistance;
                    thisHitPoint = hitPoint;
                    thisHitSpr = tSpr;
                }
            }
        }
        if (thisHitSpr == nil) { // 未撞到任何东西，与场景边框测试碰撞点
            thisHitPoint = CGPointIntersectionFromRectToLine(parentRect, lastLine);
        }
        // 拿lastLine的起始点与thisHitPoint画条线
        [self drawLazerFromPoint:CGPointMake(lastLine.x, lastLine.y) toPoint:thisHitPoint];
        
        lastHitSpr = thisHitSpr;
        if ([thisHitSpr isKindOfClass:[BaseReflector class]]) {
            lastLine = [((BaseReflector*)thisHitSpr) getNewLineWithOldLine:lastLine];
        } else {
            if ([thisHitSpr isKindOfClass:[BasePacket class]]) {
                [((BasePacket *)thisHitSpr) getHurt];
            }
            ended = YES;
            [self drawSparkAtPoint:thisHitPoint];
            
            LazerSource.turnedRed = [thisHitSpr isMemberOfClass:[FirePacket class]]; // 撞到红点要变成红色
        }
//        [self showPoint:thisHitPoint];
    }
    
}

- (void)drawLazerFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
    // 先把点的坐标系从parent转成self
    fromPoint = CGPointOffset(fromPoint, -self.position.x, -self.position.y);
    toPoint = CGPointOffset(toPoint, -self.position.x, -self.position.y);
//    [self showPoint:fromPoint];
//    [self showPoint:toPoint];
    
    CGPoint center = CGPointCenterFromPoints(fromPoint, toPoint);
    CGFloat distance = CGDistanceFromPoints(fromPoint, toPoint);
    CGFloat zRotation = atan2(fromPoint.y - toPoint.y, fromPoint.x - toPoint.x);
    
    SKSpriteNode *lazerNode = [SKSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"LazerParticle"] size:CGSizeMake(distance, 10)];
    lazerNode.zPosition = 100;
    lazerNode.position = center;
    lazerNode.zRotation = zRotation;
    
    [self blendColorWithSprite:lazerNode];
    
    [self addChild:lazerNode];
}

- (void)drawSparkAtPoint:(CGPoint)atPoint {
    atPoint = CGPointOffset(atPoint, -self.position.x, -self.position.y);
    SKSpriteNode *lazerSpark = [SKSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"LazerSpark"] size:OBJ_BLOCK_SIZE];
    lazerSpark.zPosition = 100;
    lazerSpark.position = atPoint;
    lazerSpark.zRotation = M_PI * ZZRandom_1_0_1();
    
    [self blendColorWithSprite:lazerSpark];
    
    [self addChild:lazerSpark];
}

- (void)showPoint:(CGPoint)point {
    SKSpriteNode *testPointSpr = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(4, 4)];
    testPointSpr.position = CGPointOffset(point, -self.position.x, -self.position.y);
    testPointSpr.zPosition = 10000;
    [self addChild:testPointSpr];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [testPointSpr removeFromParent];
    });
}

- (void)blendColorWithSprite:(SKSpriteNode *)sprite {
    sprite.color = LazerSource.turnedRed ? [SKColor redColor] : [SKColor cyanColor];
    sprite.colorBlendFactor = 1;
}

@end
