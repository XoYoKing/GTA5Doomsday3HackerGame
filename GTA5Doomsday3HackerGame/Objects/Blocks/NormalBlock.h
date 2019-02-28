//
//  NormalBlock.h
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/28.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "BaseSprite.h"

typedef NS_ENUM(NSInteger, BlockType) {
    BlockTypeChip,
    BlockTypeResistance,
};

NS_ASSUME_NONNULL_BEGIN

@interface NormalBlock : BaseSprite

+ (instancetype)normalBlockWithFacing:(DirectionFacing)facing position:(CGPoint)position type:(BlockType)type;

@end

NS_ASSUME_NONNULL_END
