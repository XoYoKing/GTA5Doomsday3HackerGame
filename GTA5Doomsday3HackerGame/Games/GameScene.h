//
//  GameScene.h
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/27.
//  Copyright © 2019 Jam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSInteger, GameState) {
    GameStateFail = -1,
    GameStatePlaying = 0,
    GameStateSuccess = 1,
};

@interface GameScene : SKScene

@property (nonatomic, readonly) NSInteger leftLifes;
@property (nonatomic, readonly) NSInteger leftSeconds;

@end
