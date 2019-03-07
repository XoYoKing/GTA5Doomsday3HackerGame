//
//  NormalReflector.m
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/27.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "NormalReflector.h"
#import "LazerParticle.h"

@implementation NormalReflector

+ (instancetype)normalReflectorWithFacing:(DirectionFacing)facing position:(CGPoint)position {
    NormalReflector *reflec = [NormalReflector spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"NormalReflector"] size:OBJ_BLOCK_SIZE];
//    NormalReflector *reflec = [NormalReflector spriteNodeWithColor:[SKColor clearColor] size:OBJ_BLOCK_SIZE];
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
    return reflec;
}

- (CGFloat)realZRotation {
    return self.zRotation - M_PI_4;
}

- (BOOL)isPointInDarkSide:(CGPoint)point {
//    return YES;
    return (point.x * -1) - 1 > point.y;
}

- (CGRect)frame {
    CGRect rect = super.frame;
    CGFloat shrinkValue = rect.size.width * 0.05;
    return CGRectInset(rect, shrinkValue, shrinkValue);
}

@end
