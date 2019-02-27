//
//  GameScene.m
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/27.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "GameScene.h"
#import "BaseSprite.h"
#import "LazerSource.h"
#import "NormalReflector.h"
#import "LazerParticle.h"

@implementation GameScene {
    CFTimeInterval lastUpdateTime;
}

- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    
    LazerSource *source = [LazerSource lazerSourceWithFacing:DirectionFacingRight position:CGPointMake(100, 100)];
    [self addChild:source];
    
    NormalReflector *norRef = [NormalReflector normalReflectorWithFacing:DirectionFacingQuadrantThree position:CGPointMake(300, 103)];
    [self addChild:norRef];
}

-(void)update:(CFTimeInterval)currentTime {
    
    lastUpdateTime = currentTime;
    
    NSMutableArray *lazers = [NSMutableArray array];
    NSMutableArray *others = [NSMutableArray array];
    
    NSArray *children = self.children;
    for (BaseSprite *node in children) {
        [node run];
        if ([node isKindOfClass:[LazerParticle class]]) {
            [lazers addObject:node];
        } else {
            [others addObject:node];
        }
    }
    
    // test hits
    for (LazerParticle *par in lazers) {
        for (BaseSprite *oth in others) {
            [oth testWithObject:par];
        }
    }
}

@end
