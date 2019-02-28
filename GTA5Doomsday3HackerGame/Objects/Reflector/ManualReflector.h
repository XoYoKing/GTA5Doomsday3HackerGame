//
//  ManualReflector.h
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/27.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "BaseReflector.h"

NS_ASSUME_NONNULL_BEGIN

@interface ManualReflector : BaseReflector

+ (instancetype)manualReflectorWithFacing:(DirectionFacing)facing position:(CGPoint)position;

@end

NS_ASSUME_NONNULL_END
