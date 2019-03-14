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

//- (void)dealloc {
//    if (![self isMemberOfClass:[LazerParticle class]]) {
//        NSLog(@"dealloc: %@", self);
//    }
//}

+ (instancetype)spriteNodeWithTexture:(SKTexture *)texture size:(CGSize)size {
    BaseSprite *spr = [super spriteNodeWithTexture:texture size:size];
    spr.zPosition = BaseZPositionObjects;
    return spr;
}

- (void)run {
    // do nothing
}

- (void)crash {
    // do nothing
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
