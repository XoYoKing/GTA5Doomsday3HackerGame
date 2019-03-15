//
//  GameViewController.m
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/27.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@interface GameViewController()

@property (weak, nonatomic) IBOutlet UIButton *turnLeftButton;
@property (weak, nonatomic) IBOutlet UIButton *turnRightButton;

@property (nonatomic, strong) NSString *currentMissionFilePath;
@property (nonatomic, strong) NSMutableArray *missionFilePaths;

@end

@implementation GameViewController {
    
    __weak IBOutlet SKView* skView;
    
    __weak IBOutlet UILabel *leftTimeLabel;
    __weak IBOutlet UILabel *leftLifeLabel;
    __weak IBOutlet UILabel *missionNameLabel;
    
    NSTimer *_timer;
}

- (void)dealloc {
    [_timer invalidate];
    NSLog(@"dealloc: %@", self);
}

- (NSMutableArray *)missionFilePaths {
    if (_missionFilePaths.count == 0) {
        _missionFilePaths = [NSMutableArray array];
        
        NSArray *jsonPaths = [NSBundle.mainBundle pathsForResourcesOfType:@"json" inDirectory:nil];
        [_missionFilePaths addObjectsFromArray:jsonPaths.shuffledArray];
        
        if ([_missionFilePaths containsObject:self.currentMissionFilePath]) {
            [_missionFilePaths removeObject:self.currentMissionFilePath];
        }
    }
    return _missionFilePaths;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Configure the view.
    
//    skView.frame = CGRectMake(0, 0, 16 * 10, 9 * 10);
//    skView.center = self.view.center;
//    [self.view insertSubview:skView atIndex:0];
    
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
//    skView.showsDrawCount=YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    [self playNextMission];

    __weak typeof(self) weakSelf = self;
    _timer = [NSTimer db_scheduledTimerWithTimeInterval:HANDLE_DELAY_TIME repeats:YES block:^(NSTimer *timer) {
        if (weakSelf.turnLeftButton.isTouchInside) {
            [weakSelf turnLeft:nil];
        }
        if (weakSelf.turnRightButton.isTouchInside) {
            [weakSelf turnRight:nil];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveGamingInfoNotification:) name:GamingInformationNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveGameDidFinishNotification:) name:GameDidFinishNotification object:nil];
}

- (void)playNextMission {
    // Create and configure the scene.
    self.currentMissionFilePath = self.missionFilePaths.lastObject;
    [self.missionFilePaths removeLastObject];
    
    GameScene *scene = [GameScene sceneWithSize:OBJ_GAME_SCENE_SIZE];
    scene.missionFile = self.currentMissionFilePath;
    [skView presentScene:scene];
}

- (IBAction)turnLeft:(id)sender {
    [self sendRotationNotification:1];
}

- (IBAction)turnRight:(id)sender {
    [self sendRotationNotification:-1];
}

- (IBAction)skipMission:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    if ([longPressGestureRecognizer isKindOfClass:[UIGestureRecognizer class] ]) {
        if (longPressGestureRecognizer.state == UIGestureRecognizerStateRecognized) {
            [self playNextMission];
        }
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)sendRotationNotification:(NSInteger)rota {
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:HANDLE_DELAY_TIME]];
    [[NSNotificationCenter defaultCenter] postNotificationName:RotationActionNotification object:@(rota)];
}

- (void)receiveGamingInfoNotification:(NSNotification *)notification {
    GameScene *scene = notification.object;
    if ([scene isMemberOfClass:[GameScene class]]) {
        NSInteger lifes = scene.leftLifes;
        NSInteger seconds = scene.leftSeconds;
        leftLifeLabel.text = [NSString stringWithFormat:@"%ld", (long)lifes];
        leftTimeLabel.text = [NSString stringWithFormat:@"%ld:%02ld", (long)seconds / 60, (long)seconds % 60];
        missionNameLabel.text = scene.missionFile;
    }
}

- (void)receiveGameDidFinishNotification:(NSNotification *)notification {
    [self playNextMission];
}

@end
