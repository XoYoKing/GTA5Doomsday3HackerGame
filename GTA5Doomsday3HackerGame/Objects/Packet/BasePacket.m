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
}

- (SKTexture *)explosionTexture {
    return nil;
}

- (void)getHurt {
    hits ++;
    //        self.colorBlendFactor = (CGFloat)hits / (CGFloat)hitsToDie;
    self.anchorPoint = CGPointMake(0.5 + 0.05 * ZZRandom_1_0_1(), 0.5 + 0.05 * ZZRandom_1_0_1());
    if (hits >= hitsToDie) {
        [self crash];
    }
}

- (void)crash {
    if (dying) {
        return;
    }
    dying = YES;
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
