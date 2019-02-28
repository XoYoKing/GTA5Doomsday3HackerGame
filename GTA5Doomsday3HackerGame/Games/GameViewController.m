//
//  GameViewController.m
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/27.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@implementation GameViewController {
    IBOutlet SKView* skView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Configure the view.
    
    skView.frame = CGRectMake(0, 0, OBJ_BLOCK_WIDTH * OBJ_HORIZONTAL_COUNT, OBJ_BLOCK_WIDTH * OBJ_VERTICAL_COUNT);
    skView.center = self.view.center;
    [self.view insertSubview:skView atIndex:0];
    
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
//    skView.showsDrawCount=YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    GameScene *scene = [GameScene sceneWithSize:skView.frame.size];
    scene.scaleMode = SKSceneScaleModeResizeFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)pressLeft:(id)sender {
    [self sendRotationNotification:-1];
}

- (IBAction)pressRight:(id)sender {
    [self sendRotationNotification:1];
}

- (void)sendRotationNotification:(NSInteger)rota {
    [[NSNotificationCenter defaultCenter] postNotificationName:RotationActionNotificatioin object:@(rota)];
}

@end
