//
//  GameViewController.m
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/27.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "NSTimer+HICategory.h"

@interface GameViewController()

@property (weak, nonatomic) IBOutlet UIButton *turnLeftButton;
@property (weak, nonatomic) IBOutlet UIButton *turnRightButton;

@end

@implementation GameViewController {
    
    __weak IBOutlet SKView* skView;
    
    __weak IBOutlet UILabel *leftTimeLabel;
    __weak IBOutlet UILabel *leftLifeLabel;
    
    NSTimer *_timer;
}

- (void)dealloc {
    [_timer invalidate];
    NSLog(@"dealloc: %@", self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Configure the view.
    
//    skView.frame = CGRectMake(0, 0, 16 * 10, 9 * 10);
//    skView.center = self.view.center;
//    [self.view insertSubview:skView atIndex:0];
    
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.showsDrawCount=YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    GameScene *scene = [GameScene sceneWithSize:OBJ_GAME_SCENE_SIZE];
    [skView presentScene:scene];

    __weak typeof(self) weakSelf = self;
    _timer = [NSTimer db_scheduledTimerWithTimeInterval:0.25 repeats:YES block:^(NSTimer *timer) {
        if (weakSelf.turnLeftButton.isTouchInside) {
            [weakSelf turnLeft:nil];
        }
        if (weakSelf.turnRightButton.isTouchInside) {
            [weakSelf turnRight:nil];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveGamingInfoNotification:) name:GamingInformationNotification object:nil];
}

- (IBAction)turnLeft:(id)sender {
    [self sendRotationNotification:1];
}

- (IBAction)turnRight:(id)sender {
    [self sendRotationNotification:-1];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)sendRotationNotification:(NSInteger)rota {
    [[NSNotificationCenter defaultCenter] postNotificationName:RotationActionNotification object:@(rota)];
}

- (void)receiveGamingInfoNotification:(NSNotification *)notification {
    GameScene *scene = notification.object;
    if ([scene isMemberOfClass:[GameScene class]]) {
        NSInteger lifes = scene.leftLifes;
        NSInteger seconds = scene.leftSeconds;
        leftLifeLabel.text = [NSString stringWithFormat:@"%ld", (long)lifes];
        leftTimeLabel.text = [NSString stringWithFormat:@"%ld:%02ld", seconds / 60, seconds % 60];
    }
}

@end
