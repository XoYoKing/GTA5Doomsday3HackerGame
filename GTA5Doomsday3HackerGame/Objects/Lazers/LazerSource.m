//
//  LazerSource.m
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/27.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "LazerSource.h"
#import "LazerParticle.h"

static BOOL _turnedRed = NO;

@implementation LazerSource {
    BOOL stopped;
    BOOL disabled;
}

+ (void)setTurnedRed:(BOOL)turnedRed {
    _turnedRed = turnedRed;
}

+ (BOOL)turnedRed {
    return _turnedRed;
}

+ (instancetype)lazerSourceWithFacing:(DirectionFacing)facing position:(CGPoint)position disabled:(BOOL)disabled {
    LazerSource *sour = [LazerSource spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"LazerSource"] size:OBJ_BLOCK_SIZE];
    sour.position = position;
    if (facing == DirectionFacingUp) {
        sour.zRotation = M_PI_2;
    } else if (facing == DirectionFacingLeft) {
        sour.zRotation = M_PI;
    } else if (facing == DirectionFacingDown) {
        sour.zRotation = -M_PI_2;
    } else {
        sour.zRotation = 0;
    }
    sour->disabled = disabled;
    if (!disabled) {
        SKSpriteNode *shooter = [SKSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"LazerSourceShooter"] size:OBJ_BLOCK_SIZE];
        shooter.position = CGPointMake(OBJ_BLOCK_WIDTH / 2, 0);
        [sour addChild:shooter];
    }
    return sour;
}

- (void)run {
    if (stopped || disabled) {
        return;
    }
    CGFloat shootingOffset = self.size.width / 2 + 4;
    CGFloat zRota = self.zRotation;
    CGPoint shootingVector = CGPointMake(shootingOffset * cos(zRota), shootingOffset * sin(zRota));
    CGPoint shootingPoint = CGPointOffsetVector(self.position, shootingVector);
    
    // shoot a Particle
    LazerParticle *par = [LazerParticle lazerParticleWithZRotation:zRota position:shootingPoint];
    [self.parent addChild:par];
}

- (void)stopShootingForAWhile {
    stopped = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self->stopped = NO;
    });
}

@end
