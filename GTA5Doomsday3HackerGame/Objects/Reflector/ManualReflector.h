//
//  ManualReflector.h
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/27.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "BaseReflector.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ReflectorRotation) {
    ReflectorRotationNone = 0,
    ReflectorRotationCounterClockwise = 1,
    ReflectorRotationClockwise = -1,
};

@interface ManualReflector : BaseReflector

+ (instancetype)manualReflectorWithFacing:(DirectionFacing)facing position:(CGPoint)position;

- (void)rotateWithRotation:(ReflectorRotation)reflecRotation;

@end

NS_ASSUME_NONNULL_END
