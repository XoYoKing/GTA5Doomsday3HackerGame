//
//  BasePacket.m
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/3/4.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "BasePacket.h"

const NSInteger hitsToDie = 150;

@implementation BasePacket {
    NSInteger hits;
    BOOL dying;
    SKSpriteNode *normalChild;
    SKSpriteNode *tintChild;
}

- (SKTexture *)explosionTexture {
    return nil;
}

- (SKTexture *)tintTexture {
    return nil;
}

+ (instancetype)spriteNodeWithTexture:(SKTexture *)texture size:(CGSize)size {
    BasePacket *ba = [super spriteNodeWithTexture:nil size:size];
    ba->normalChild = [SKSpriteNode spriteNodeWithTexture:texture size:size];
    [ba addChild:ba->normalChild];
    SKTexture *tinTex = ba.tintTexture;
    if (tinTex) {
        ba->tintChild = [SKSpriteNode spriteNodeWithTexture:tinTex size:size];
        ba->tintChild.alpha = 0;
        [ba addChild:ba->tintChild];
    }
    return ba;
}

- (void)getHurt {
    hits ++;
    normalChild.anchorPoint = CGPointMake(0.5 + 0.05 * ZZRandom_1_0_1(), 0.5 + 0.05 * ZZRandom_1_0_1());
    tintChild.anchorPoint = normalChild.anchorPoint;
    tintChild.alpha = (CGFloat)hits / (CGFloat)hitsToDie;
    if (hits >= hitsToDie) {
        [self crash];
    }
}

- (void)crash {
    if (dying) {
        return;
    }
    dying = YES;
    [normalChild removeFromParent];
    [tintChild removeFromParent];
    self.zRotation = ZZRandom_0_1() * M_PI * 2;
    self.xScale = 1.5;
    self.yScale = 1.5;
    self.texture = self.explosionTexture;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromParent];
        [self didFinishedCrash];
    });
}

- (CGRect)frame {
    CGRect rect = super.frame;
    CGFloat shrinkValue = rect.size.width * 0.15;
    return CGRectInset(rect, shrinkValue, shrinkValue);
}

- (void)didFinishedCrash {
    
}

@end
