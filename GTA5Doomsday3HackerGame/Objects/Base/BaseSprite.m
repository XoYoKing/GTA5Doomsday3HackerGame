//
//  BaseSprite.m
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/27.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "BaseSprite.h"
#import "LazerParticle.h"

@implementation BaseSprite

- (void)run {
    // do nothing
}

- (void)crash {
    // do nothing
}

- (void)testWithObject:(BaseSprite *)object {
    if ([self intersectsNode:object] && [object isMemberOfClass:[LazerParticle class]] && ![self isMemberOfClass:[LazerParticle class]]) {
        [object crash];
    }
}

- (BOOL)intersectsNode:(SKNode *)node {
    return CGRectIntersectsRect(self.frame, node.frame);
}

- (CGRect)frame {
    CGRect rect = CGRectZero;
    rect.origin = self.position;
    return CGRectInset(rect, -self.size.width / 2, -self.size.height / 2);
    
    // 原始的frame会根据scale、zRotation缩放。。。
}

@end
