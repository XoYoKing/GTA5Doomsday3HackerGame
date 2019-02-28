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

@implementation GameScene {
    CFTimeInterval lastUpdateTime;
    ManualReflector *currentReflector;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    self.backgroundColor = view.backgroundColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotationActionNotification:) name:RotationActionNotificatioin object:nil];
    
    [self loadObjectsFromFile];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint pointInSelf = [touch locationInNode:self];
    NSArray *children = self.children;
    for (BaseSprite *node in children) {
        if ([node isMemberOfClass:[ManualReflector class]]) {
            if (CGRectContainsPoint(node.frame, pointInSelf)) {
                currentReflector = (ManualReflector *)node;
                return;
            }
        }
    }
}

- (void)rotationActionNotification:(NSNotification *)notification {
    NSNumber *num = notification.object;
    currentReflector.zRotation += (-num.integerValue) * M_PI / 48;
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
            [self addChild:[ManualReflector manualReflectorWithFacing:face position:realPosition]];
        } else if (class == [NormalReflector class]) {
            [self addChild:[NormalReflector normalReflectorWithFacing:face position:realPosition]];
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
