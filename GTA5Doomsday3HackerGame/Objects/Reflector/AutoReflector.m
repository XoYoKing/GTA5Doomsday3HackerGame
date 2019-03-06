//
//  AutoRefector.m
//  GTA5Doomsday3HackerGame
//
//  Created by ZJam on 2019/2/28.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "AutoReflector.h"
#import "NSTimer+HICategory.h"

@implementation AutoReflector {
    NSTimer *_timer;
}

- (void)dealloc {
    [_timer invalidate];
}

+ (instancetype)autoReflectorWithPosition:(CGPoint)position {
    AutoReflector *reflec = [AutoReflector spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"AutoReflector"]
                                                            size:OBJ_BLOCK_SIZE];
    reflec.position = position;
    [reflec startRotate];
    return reflec;
}

- (void)startRotate {
    __weak typeof(self) weakSelf = self;
    _timer = [NSTimer db_scheduledTimerWithTimeInterval:0.8 repeats:YES block:^(NSTimer *timer) {
        weakSelf.zRotation += M_PI_4;
    }];
}

- (ZZLine)getNewLineWithOldLine:(ZZLine)oldLine {
    CGFloat shootingOffset = OBJ_BLOCK_WIDTH / 2;
    CGFloat zRota = self.zRotation;
    CGPoint shootingVector = CGPointMake(shootingOffset * cos(zRota), shootingOffset * sin(zRota));
    CGPoint shootingPoint = CGPointOffsetVector(self.position, shootingVector);
    return ZZLineMake(shootingPoint.x, shootingPoint.y, zRota);
}

- (CGRect)frame {
    CGRect rect = super.frame;
    CGFloat shrinkValue = rect.size.width * 0.15;
    return CGRectInset(rect, shrinkValue, shrinkValue);
}

@end
