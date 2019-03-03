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

@implementation GameScene {
    CFTimeInterval lastUpdateTime;
    ManualReflector *currentManualReflector;
    BaseSprite *currentIndicator;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    self.backgroundColor = view.backgroundColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotationActionNotification:) name:RotationActionNotificatioin object:nil];
    
//    [self loadObjectsFromFile];
    
    // test line Intersects Rect
    ZZLine line = ZZLineMake(70, 50, M_PI_4);
    CGRect rect = CGRectMake(0, 0, 100, 100);
    BOOL inter = CGRectIntersectsLine(rect, line);
    CGPoint point = CGPointIntersectionFromRectToLine(rect, line);
    NSLog(@"inter :%@ POINT: %@", inter ? @"YES" : @"NO", NSStringFromCGPoint(point));
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

- (void)rotationActionNotification:(NSNotification *)notification {
    NSNumber *num = notification.object;
    [currentManualReflector rotateWithRotation:num.integerValue];
}

- (void)update:(CFTimeInterval)currentTime {
    
    lastUpdateTime = currentTime;
    
    NSMutableArray *lazers = [NSMutableArray array];
    NSMutableArray *others = [NSMutableArray array];
    
    NSArray *children = self.children;
    for (BaseSprite *node in children) {
        [node run];
        if ([node isMemberOfClass:[LazerParticle class]]) {
            [lazers addObject:node];
        } else if (node != currentIndicator){
            [others addObject:node];
        }
    }
    
    // test hits
    for (LazerParticle *par in lazers) {
        [par testWithObjects:others];
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
    NSData *dataFromFile = [NSData dataWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"Mission01" ofType:@"json"]];
    NSArray *objects = [NSJSONSerialization JSONObjectWithData:dataFromFile options:NSJSONReadingAllowFragments error:nil];
//    NSLog(@"%@", objects);
    
    for (NSDictionary *dic in objects) {
        NSString *name = [dic valueForKey:@"name"];
        NSInteger x = [[dic valueForKey:@"x"] integerValue];
        NSInteger y = [[dic valueForKey:@"y"] integerValue];
        NSInteger face = [[dic valueForKey:@"face"] integerValue];
        NSInteger type = [[dic valueForKey:@"type"] integerValue];
        CGPoint realPosition = CGPointMake(OBJ_BLOCK_WIDTH / 2 + x * OBJ_BLOCK_WIDTH, OBJ_BLOCK_WIDTH / 2 + y * OBJ_BLOCK_WIDTH);
        Class class = NSClassFromString(name);
        if (class == [LazerSource class]) {
            [self addChild:[LazerSource lazerSourceWithFacing:face position:realPosition]];
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
        } else if (class == [FirePacket class]) {
            [self addChild:[FirePacket firePacketWithPosition:realPosition]];
        }
    }
}

@end
