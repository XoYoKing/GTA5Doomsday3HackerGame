//
//  NormalReflector.h
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/27.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "BaseSprite.h"

NS_ASSUME_NONNULL_BEGIN

@interface NormalReflector : BaseSprite

+ (instancetype)normalReflectorWithFacing:(DirectionFacing)facing position:(CGPoint)position;

@end

NS_ASSUME_NONNULL_END
