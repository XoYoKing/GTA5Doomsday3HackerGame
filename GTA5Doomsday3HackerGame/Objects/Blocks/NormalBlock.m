//
//  NormalBlock.m
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/28.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "NormalBlock.h"

@implementation NormalBlock {
    BOOL changedTexture;
    BlockType myType;
    DirectionFacing myFacing;
}

+ (instancetype)normalBlockWithFacing:(DirectionFacing)facing position:(CGPoint)position type:(BlockType)type {
    id texture = [MyTextureAtlas textureNamed:type == BlockTypeChip ? @"NormalBlockChip" : @"NormalBlockResistance"];
    NormalBlock *block = [NormalBlock spriteNodeWithTexture:texture size:OBJ_BLOCK_SIZE];
    block.position = position;
    if (facing != DirectionFacingUp && facing != DirectionFacingRight) {
        facing = DirectionFacingRight;
    }
    if (facing == DirectionFacingUp) {
        block.zRotation = M_PI_2;
    }
    block->myType = type;
    block->myFacing = facing;
    return block;
}

- (void)run {
    if (myType == BlockTypeChip && changedTexture == NO) {
        changedTexture = YES;
        
        BOOL hasLeft = NO;
        BOOL hasRight = NO;
        BOOL hasTop = NO;
        BOOL hasBottom = NO;
        CGPoint leftPoint = CGPointOffset(self.position, -OBJ_BLOCK_WIDTH, 0);
        CGPoint rightPoint = CGPointOffset(self.position, OBJ_BLOCK_WIDTH, 0);
        CGPoint topPoint = CGPointOffset(self.position, 0, OBJ_BLOCK_WIDTH);
        CGPoint bottomPoint = CGPointOffset(self.position, 0, -OBJ_BLOCK_WIDTH);
        
        NSMutableArray *childrenWithoutMe = [NSMutableArray arrayWithArray:self.parent.children];
        [childrenWithoutMe removeObject:self];
        
        for (NormalBlock *node in childrenWithoutMe) {
            if ([node isMemberOfClass:self.class] && node->myType == self->myType) {
                CGRect rect = node.frame;
                if (CGRectContainsPoint(rect, leftPoint)) {
                    hasLeft = YES;
                }
                if (CGRectContainsPoint(rect, rightPoint)) {
                    hasRight = YES;
                }
                if (CGRectContainsPoint(rect, topPoint)) {
                    hasTop = YES;
                }
                if (CGRectContainsPoint(rect, bottomPoint)) {
                    hasBottom = YES;
                }
            }
        }
        
        if ((!hasLeft && !hasRight && self->myFacing == DirectionFacingRight) || (!hasTop && !hasBottom && self->myFacing == DirectionFacingUp)) {
            self.texture = [MyTextureAtlas textureNamed:@"NormalBlockChipSmall"];
        } else if (self->myFacing == DirectionFacingRight) {
            if (!(hasLeft && hasRight) && (hasLeft || hasRight)) {
                self.texture = [MyTextureAtlas textureNamed:@"NormalBlockChipHead"];
                if (hasLeft) {
                    self.zRotation = 0;
                } else {
                    self.zRotation = M_PI;
                }
            }
        } else if (self->myFacing == DirectionFacingUp) {
            if (!(hasTop && hasBottom) && (hasTop || hasBottom)) {
                self.texture = [MyTextureAtlas textureNamed:@"NormalBlockChipHead"];
                if (hasBottom) {
                    self.zRotation = M_PI_2;
                } else {
                    self.zRotation = -M_PI_2;
                }
            }
        }
    }
}

@end
