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
#import "ManualReflector.h"
#import "NormalBlock.h"
#import "DataPacket.h"
#import "FirePacket.h"
#import "AutoReflector.h"

#import "NSTimer+HICategory.h"

@implementation GameScene {
    ManualReflector *currentManualReflector;
    BaseSprite *currentIndicator;
    
    NSInteger _leftLifes;
    NSInteger _leftSeconds;
    GameState _currentGameState;
    
    NSTimer *_timer;
    
    NSInteger totalDataPacketCount;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_timer invalidate];
    NSLog(@"dealloc: %@", self);
}

- (void)didMoveToView:(SKView *)view {
    // init
    _leftLifes = 2;
    _leftSeconds = 300;
    _currentGameState = GameStatePlaying;
    __weak typeof(self) weakSelf = self;
    _timer = [NSTimer db_scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer *timer) {
        [weakSelf reduceLeftSeconds];
    }];
    self.backgroundColor = view.backgroundColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotationActionNotification:) name:RotationActionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didHitFirePacketNotification:) name:FirePacketExplosedNotification object:nil];
    
    [self loadObjectsFromFile];

    // test line Intersects Rect
/**
    ZZLine line = ZZLineMake(0, 200, M_PI / 4);
    CGRect rect = CGRectMake(100, 100, 100, 100);
    BOOL inter = CGRectIntersectsLine(rect, line);
    CGPoint point = CGPointIntersectionFromRectToLine(rect, line);
    NSLog(@"inter :%@ POINT: %@", inter ? @"YES" : @"NO", NSStringFromCGPoint(point));
    
    SKSpriteNode *rectSpr = [SKSpriteNode spriteNodeWithColor:[SKColor grayColor] size:rect.size];
    rectSpr.position = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    [self addChild:rectSpr];
    
    SKSpriteNode *pointerSpr = [SKSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"Pointer"]];
    pointerSpr.position = CGPointMake(line.x, line.y);
    pointerSpr.zRotation = line.alpha;
    pointerSpr.zPosition = 50;
    [self addChild:pointerSpr];
    
    SKSpriteNode *intersectSpr = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(4, 4)];
    intersectSpr.position = point;
    intersectSpr.zPosition = 100;
    [self addChild:intersectSpr];
//*/
}

- (void)reduceLeftSeconds {
    _leftSeconds --;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint pointInSelf = [touch locationInNode:self];
    NSArray *children = self.children;
    for (BaseSprite *node in children) {
        if ([node isMemberOfClass:[ManualReflector class]]) {
            if (CGRectContainsPoint(node.frame, pointInSelf)) {
                [self setCurrentManualReflector:(ManualReflector *)node];
                return;
            }
        }
    }
}

- (void)setCurrentManualReflector:(ManualReflector *)reflector {
    currentManualReflector = reflector;
    if (currentIndicator == nil) {
        currentIndicator = [BaseSprite spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"CurrentIndicator"] size:CGSizeMake(OBJ_BLOCK_WIDTH + 4, OBJ_BLOCK_WIDTH + 4)];
        currentIndicator.zPosition = 10;
        [self addChild:currentIndicator];
    }
    currentIndicator.position = currentManualReflector.position;
}

- (void)loadObjectsFromFile {
    NSArray *jsonPaths = [NSBundle.mainBundle pathsForResourcesOfType:@"json" inDirectory:nil];
    NSString *filePath = [jsonPaths objectAtIndex:arc4random() % jsonPaths.count];
    
    // test
    // filePath = [NSBundle.mainBundle pathForResource:@"mission10" ofType:@"json"];
    
    self.missionFile = [[filePath lastPathComponent] stringByDeletingPathExtension];
    NSData *dataFromFile = [NSData dataWithContentsOfFile:filePath];
    NSArray *objects = [NSJSONSerialization JSONObjectWithData:dataFromFile options:NSJSONReadingAllowFragments error:nil];
    //    NSLog(@"%@", objects);
    
    for (NSDictionary *dic in objects) {
        NSString *name = [dic valueForKey:@"name"];
        CGFloat x = [[dic valueForKey:@"x"] floatValue];
        CGFloat y = [[dic valueForKey:@"y"] floatValue];
        NSInteger face = [[dic valueForKey:@"face"] integerValue];
        NSInteger type = [[dic valueForKey:@"type"] integerValue];
        BOOL disabled = [[dic valueForKey:@"disabled"] boolValue];
        CGPoint realPosition = CGPointMake(OBJ_BLOCK_WIDTH / 2 + x * OBJ_BLOCK_WIDTH, OBJ_BLOCK_WIDTH / 2 + y * OBJ_BLOCK_WIDTH);
        Class class = NSClassFromString(name);
        if (class == [LazerSource class]) {
            [self addChild:[LazerSource lazerSourceWithFacing:face position:realPosition disabled:disabled]];
        } else if (class == [ManualReflector class]) {
            ManualReflector *reflector = [ManualReflector manualReflectorWithFacing:face position:realPosition];
            [self addChild:reflector];
            if (currentManualReflector == nil) {
                [self setCurrentManualReflector:reflector];
            }
        } else if (class == [NormalReflector class]) {
            [self addChild:[NormalReflector normalReflectorWithFacing:face position:realPosition]];
        } else if (class == [AutoReflector class]) {
            [self addChild:[AutoReflector autoReflectorWithPosition:realPosition]];
        } else if (class == [NormalBlock class]) {
            [self addChild:[NormalBlock normalBlockWithFacing:face position:realPosition type:type]];
        } else if (class == [DataPacket class]) {
            [self addChild:[DataPacket dataPacketWithPosition:realPosition]];
            totalDataPacketCount ++;
        } else if (class == [FirePacket class]) {
            [self addChild:[FirePacket firePacketWithPosition:realPosition]];
        }
    }
}

#pragma mark - getter

- (NSInteger)leftSeconds {
    return _leftSeconds;
}

- (NSInteger)leftLifes {
    return _leftLifes;
}

#pragma mark - Notifications

- (void)rotationActionNotification:(NSNotification *)notification {
    NSNumber *num = notification.object;
    [currentManualReflector rotateWithRotation:num.integerValue];
}

- (void)didHitFirePacketNotification:(NSNotification *)notification {
    _leftLifes--;
}

#pragma mark - Game logic

- (void)update:(CFTimeInterval)currentTime {
    
    if (_currentGameState != GameStatePlaying) {
        return;
    }
    
    NSMutableArray *lazers = [NSMutableArray array];
    NSMutableArray *others = [NSMutableArray array];
    
    NSArray *children = self.children;
    for (BaseSprite *node in children) {
        if ([node isKindOfClass:[BaseSprite class]]) {
            [node run];
            if ([node isMemberOfClass:[LazerParticle class]]) {
                [lazers addObject:node];
            } else if (node != currentIndicator){
                [others addObject:node];
            }
        }
    }
    
    // test hits
    for (LazerParticle *par in lazers) {
        [par testWithObjects:others];
    }
    
    [self postCurrentGamingInfo];
    [self checkIfGameOver];
}

- (void)postCurrentGamingInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:GamingInformationNotification object:self];
}

- (void)checkIfGameOver {
    if (_leftSeconds <= 0 || _leftLifes <= 0) {
        _currentGameState = GameStateFail;
    } else if (totalDataPacketCount > 0){
        NSInteger leftDataPacketCount = 0;
        NSArray *myChildren = self.children;
        for (SKNode *node in myChildren) {
            if ([node isMemberOfClass:[DataPacket class]]) {
                leftDataPacketCount ++;
            }
        }
        if (leftDataPacketCount == 0) {
            _currentGameState = GameStateSuccess;
        }
    }

    [self showResultIfNeed];
}

- (void)showResultIfNeed {
    if (_currentGameState != GameStatePlaying) {
        BOOL isWon = (_currentGameState == GameStateSuccess);
        
        SKSpriteNode *labelContent = [SKSpriteNode spriteNodeWithColor:isWon ? [SKColor colorWithRed:0 green:0.4 blue:0 alpha:1] : [SKColor colorWithRed:0.4 green:0 blue:0 alpha:1] size:self.size];
        labelContent.position = CGPointMake(self.size.width / 2, self.size.height / 2);
        labelContent.zPosition = 100000;
        [self addChild:labelContent];
        
        SKLabelNode *label = [SKLabelNode labelNodeWithText:isWon ? @"成功" : @"失败"];
        label.fontSize = 65;
        label.fontName = @"Chalkduster";
        label.fontColor = [SKColor whiteColor];
        [labelContent addChild:label];
        [label runAction:[SKAction sequence:[NSArray arrayWithObjects:
                                             [SKAction fadeAlphaTo:0 duration:0.25],
                                             [SKAction fadeAlphaTo:1 duration:0.25],
                                             [SKAction fadeAlphaTo:0 duration:0.25],
                                             [SKAction fadeAlphaTo:1 duration:0.25],
                                             nil]]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            GameScene *scene = [GameScene sceneWithSize:OBJ_GAME_SCENE_SIZE];
            [self.view presentScene:scene];
        });
    }
}

@end
