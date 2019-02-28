//
//  LazerParticle.m
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/27.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "LazerParticle.h"

const CGFloat _lazer_particle_flying_speed = 300; // points per second

@implementation LazerParticle {
    BOOL dying;
}

+ (instancetype)lazerParticleWithZRotation:(CGFloat)zRotation position:(CGPoint)position {
    LazerParticle *par = [LazerParticle spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(1, 1)];
    par.zRotation = zRotation;
    par.position = position;
    BaseSprite *light = [BaseSprite spriteNodeWithColor:[SKColor cyanColor] size:CGSizeMake(6, 3)];
    [par addChild:light];
    return par;
}

- (void)run {
    if (dying) {
        return;
    }
    CGFloat zRota = self.zRotation;
    CGFloat speedInAFrame = _lazer_particle_flying_speed / GAME_FPS;
    CGFloat speedX = speedInAFrame * cos(zRota);
    CGFloat speedY = speedInAFrame * sin(zRota);
    self.position = CGPointOffset(self.position, speedX, speedY);
    
    [self crashIfNeed];
}

- (void)crashIfNeed {
    CGRect rect = self.parent.frame;
    rect.origin = CGPointZero;
//    rect = CGRectInset(rect, 50, 50);
    if (!CGRectContainsPoint(rect, self.position)) {
        [self crash];
    }
}

- (void)crash {
    if (dying) {
        return;
    }
    dying = YES;
    self.zRotation = ZZRandom_0_1() * M_PI * 2;
    self.xScale = 2;
    self.yScale = 2;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromParent];
    });
}

- (NSMutableArray *)hitObjects {
    if (_hitObjects == nil) {
        _hitObjects = [NSMutableArray array];
    }
    return _hitObjects;
}

@end
