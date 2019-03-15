//
//  GameScene.h
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/27.
//  Copyright © 2019 Jam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene

@property (nonatomic, readonly) NSInteger leftLifes;
@property (nonatomic, readonly) NSInteger leftSeconds;
@property (nonatomic, strong) NSString *missionFile;

@end
