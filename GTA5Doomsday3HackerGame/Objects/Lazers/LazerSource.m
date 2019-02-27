//
//  LazerSource.m
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/27.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "LazerSource.h"
#import "LazerParticle.h"

@implementation LazerSource

+ (instancetype)lazerSourceWithFacing:(DirectionFacing)facing position:(CGPoint)position {
    LazerSource *sour = [LazerSource spriteNodeWithColor:[SKColor grayColor] size:OBJ_BLOCK_SIZE];
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
    return sour;
}

- (void)run {
    for (int i = 1; i < 5; i++) {
        CGFloat shootingOffset = self.size.width / 2 + 20 * ZZRandom_0_1() + 4;
        CGFloat zRota = self.zRotation;
        CGPoint shootingVector = CGPointMake(shootingOffset * cos(zRota), shootingOffset * sin(zRota));
        CGPoint shootingPoint = CGPointOffsetVector(self.position, shootingVector);
        
        // shoot a Particle
        LazerParticle *par = [LazerParticle lazerParticleWithZRotation:zRota position:shootingPoint];
        [self.parent addChild:par];
    }
}

@end
