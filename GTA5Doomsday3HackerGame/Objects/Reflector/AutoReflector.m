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
    SKSpriteNode *backgroundNode;
    SKSpriteNode *shooterNode;
}

- (void)dealloc {
    [_timer invalidate];
}

+ (instancetype)autoReflectorWithPosition:(CGPoint)position {
    AutoReflector *reflec = [AutoReflector spriteNodeWithTexture:nil
                                                            size:OBJ_BLOCK_SIZE];
    reflec->backgroundNode = [SKSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"AutoReflector"] size:OBJ_BLOCK_SIZE];
    [reflec addChild:reflec->backgroundNode];
    reflec->shooterNode = [SKSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"AutoReflectorShooter"] size:OBJ_BLOCK_SIZE];
    reflec->shooterNode.zPosition = reflec->backgroundNode.zPosition + 1;
    [reflec addChild:reflec->shooterNode];
    reflec.position = position;
    [reflec startRotate];
    return reflec;
}

- (void)setZRotation:(CGFloat)zRotation {
    [super setZRotation:zRotation];
    backgroundNode.zRotation = -zRotation;
}

- (void)startRotate {
    __weak typeof(self) weakSelf = self;
    _timer = [NSTimer db_scheduledTimerWithTimeInterval:0.8 repeats:YES block:^(NSTimer *timer) {
        weakSelf.zRotation += M_PI_4;
    }];
}

- (ZZLine)getNewLineWithOldLine:(ZZLine)oldLine {
    CGFloat shootingOffset = OBJ_BLOCK_WIDTH * 0.1;
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
