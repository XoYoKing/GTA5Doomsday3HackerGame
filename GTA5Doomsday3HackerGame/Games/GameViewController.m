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
    SKView* skView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Configure the view.
    
    CGFloat w = self.view.frame.size.width;
    CGFloat h = self.view.frame.size.height;
    
    skView = [[SKView alloc] initWithFrame:CGRectMake(0, 0, w > h ? w : h, w < h ? w : h)];
    [self.view addSubview:skView];
    
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.showsDrawCount=YES;
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

@end
