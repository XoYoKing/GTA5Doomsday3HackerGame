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
    if (facing == DirectionFacingUp) {
        reflec.zRotation = M_PI_2;
    } else if (facing == DirectionFacingQuadrantThree) {
        reflec.zRotation = M_PI_2 + M_PI_4;
    } else if (facing == DirectionFacingQuadrantOne) {
        reflec.zRotation = M_PI_4;
    } else {
        reflec.zRotation = 0;
    }
    [reflec addHiddenChildren];
    return reflec;
}

- (void)addHiddenChildren {
    NSInteger count = 2;
    CGFloat width = self.size.width;
    CGFloat widthForBlock = width / count;
    CGFloat halfWidth = width / 2;
    CGFloat halfWidthForBlock = widthForBlock / 2;
    for (NSInteger i = 0; i < count; i ++) {
        SKSpriteNode *hiddenNode = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(widthForBlock, widthForBlock)];
        hiddenNode.position = CGPointMake(-halfWidth + i * widthForBlock + halfWidthForBlock, 0);
        [self addChild:hiddenNode];
    }
}

@end
