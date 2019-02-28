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
//    reflec.zRotation = reflec.zRotation - M_PI/3;
    reflec -> _facing = facing;
    
    [reflec addHiddenChildren];
    
    return reflec;
}

- (void)addHiddenChildren {
    NSInteger rows = 3;
    CGFloat width = self.size.width;
    CGFloat widthForBlock = width / rows;
    CGFloat halfWidth = width / 2;
    CGFloat halfWidthForBlock = widthForBlock / 2;
    for (NSInteger i = 0; i < rows; i ++) {
        NSInteger blocksForRow = rows - i;
        for (NSInteger c = 0; c < blocksForRow; c++) {
            SKSpriteNode *hiddenNode = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(widthForBlock, widthForBlock)];
            [self addChild:hiddenNode];
            hiddenNode.position = CGPointMake(-halfWidth + i * widthForBlock + halfWidthForBlock, -halfWidth + c * widthForBlock + halfWidthForBlock);
        }
    }
}

- (CGFloat)realZRotation {
    return self.zRotation - M_PI_4;
}

@end
