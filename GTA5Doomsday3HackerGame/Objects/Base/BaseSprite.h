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
    
    //
    DirectionFacingQuadrantOne = -1,
    DirectionFacingQuadrantTwo = -2,
    DirectionFacingQuadrantThree = -3,
    DirectionFacingQuadrantFour = -4,
};

NS_ASSUME_NONNULL_BEGIN

@interface BaseSprite : SKSpriteNode

- (void)run;
- (void)crash;

- (void)testWithObject:(BaseSprite *)object;

@end

NS_ASSUME_NONNULL_END
