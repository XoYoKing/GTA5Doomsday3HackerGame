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
    return sour;
}

- (void)run {
    CGFloat shootingOffset = self.size.width / 2 + 4;
    CGFloat zRota = self.zRotation;
    CGPoint shootingVector = CGPointMake(shootingOffset * cos(zRota), shootingOffset * sin(zRota));
    CGPoint shootingPoint = CGPointOffsetVector(self.position, shootingVector);
    
    // shoot a Particle
    LazerParticle *par = [LazerParticle lazerParticleWithZRotation:zRota position:shootingPoint];
    [self.parent addChild:par];
}

@end
