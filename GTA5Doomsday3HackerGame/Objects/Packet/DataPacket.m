//
//  DataPacket.m
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/28.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "DataPacket.h"
#import "LazerParticle.h"

const NSInteger hitsToDie = 1000;

@implementation DataPacket {
    NSInteger hits;
    BOOL dying;
}

+ (instancetype)dataPacketWithPosition:(CGPoint)position {
    DataPacket *pack = [DataPacket spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"DataPacket"] size:OBJ_BLOCK_SIZE];
    pack.position = position;
    return pack;
}

- (void)testWithObject:(BaseSprite *)object {
    if ([self intersectsNode:object] && [object isMemberOfClass:[LazerParticle class]] && ![self isMemberOfClass:[LazerParticle class]]) {
        [object crash];
        hits ++;
        self.anchorPoint = CGPointMake(0.5 + 0.05 * ZZRandom_1_0_1(), 0.5 + 0.05 * ZZRandom_1_0_1());
        if (hits >= hitsToDie) {
            [self crash];
        }
    }
}

- (BOOL)intersectsNode:(SKNode *)node {
    if (![super intersectsNode:node]) {
        return NO;
    }
    CGFloat dx = node.position.x - self.position.x;
    CGFloat dy = node.position.y - self.position.y;
    return (self.size.width * self.size.width / 4) > (dx * dx + dy * dy);
}

- (void)crash {
    if (dying) {
        return;
    }
    dying = YES;
    self.zRotation = ZZRandom_0_1() * M_PI * 2;
    self.xScale = 1.5;
    self.yScale = 1.5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromParent];
    });
}

@end
