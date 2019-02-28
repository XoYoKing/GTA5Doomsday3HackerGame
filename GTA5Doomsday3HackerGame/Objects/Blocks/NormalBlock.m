//
//  NormalBlock.m
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/28.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "NormalBlock.h"

@implementation NormalBlock

+ (instancetype)normalBlockWithFacing:(DirectionFacing)facing position:(CGPoint)position type:(BlockType)type {
    id texture = [MyTextureAtlas textureNamed:type == BlockTypeChip ? @"NormalBlockChip" : @"NormalBlockResistance"];
    NormalBlock *block = [NormalBlock spriteNodeWithTexture:texture size:OBJ_BLOCK_SIZE];
    block.position = position;
    if (facing == DirectionFacingUp) {
        block.zRotation = M_PI_2;
    }
    return block;
}

@end
