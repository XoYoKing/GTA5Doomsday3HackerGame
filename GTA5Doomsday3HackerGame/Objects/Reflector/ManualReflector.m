//
//  ManualReflector.m
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/27.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "ManualReflector.h"
#import "LazerParticle.h"

@implementation ManualReflector

+ (instancetype)manualReflectorWithFacing:(DirectionFacing)facing position:(CGPoint)position {
    ManualReflector *reflec = [ManualReflector spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"ManualReflector"] size:OBJ_BLOCK_SIZE];
//    ManualReflector *reflec = [ManualReflector spriteNodeWithColor:[SKColor clearColor] size:OBJ_BLOCK_SIZE];
    reflec.position = position;
    if (facing == DirectionFacingAngle90) {
        reflec.zRotation = M_PI_2;
    } else if (facing == DirectionFacingAngle135) {
        reflec.zRotation = M_PI_2 + M_PI_4;
    } else if (facing == DirectionFacingAngle45) {
        reflec.zRotation = M_PI_4;
    } else {
        reflec.zRotation = 0;
    }
    return reflec;
}

- (void)rotateWithRotation:(ReflectorRotation)reflecRotation {
    CGFloat rotation = M_PI / 48;
    if (reflecRotation == ReflectorRotationNone) {
        return;
    } else if (reflecRotation == ReflectorRotationClockwise) {
        rotation = -rotation;
    }
    [self runAction:[SKAction rotateByAngle:rotation duration:0.25]];
}

- (BOOL)isPointInSelf:(CGPoint)point {
    return self.frame.size.width / 2 >= CGDistanceFromPoints(self.position, point);
}

@end
