//
//  BaseSprite.h
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/27.
//  Copyright © 2019 Jam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSInteger, DirectionFacing) {
    DirectionFacingRight = 0,
    DirectionFacingUp = 1,
    DirectionFacingLeft = 2,
    DirectionFacingDown = 3,
    
    // NormalReflector
    DirectionFacingQuadrantOne = 1,
    DirectionFacingQuadrantTwo = 2,
    DirectionFacingQuadrantThree = 3,
    DirectionFacingQuadrantFour = 4,
    
    // ManualReflector
    DirectionFacingAngle00 = 0,
    DirectionFacingAngle45 = 1,
    DirectionFacingAngle90 = 2,
    DirectionFacingAngle135 = 3,
};

NS_ASSUME_NONNULL_BEGIN

@interface BaseSprite : SKSpriteNode

- (void)run;
- (void)crash;

@end

NS_ASSUME_NONNULL_END
