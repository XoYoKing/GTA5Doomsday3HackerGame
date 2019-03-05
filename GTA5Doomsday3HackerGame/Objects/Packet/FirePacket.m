//
//  FirePacket.m
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/28.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "FirePacket.h"
#import "LazerSource.h"

@implementation FirePacket {
    BOOL postNotification;
}

+ (instancetype)firePacketWithPosition:(CGPoint)position {
    FirePacket *pack = [FirePacket spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"FirePacket"] size:OBJ_BLOCK_SIZE];
    pack.position = position;
//    pack.color = [SKColor whiteColor];
    return pack;
}

- (SKTexture *)explosionTexture {
    return [MyTextureAtlas textureNamed:@"RedExplosion"];
}

- (void)crash {
    NSArray *parentsChildren = self.parent.children;
    for (LazerSource *lazSour in parentsChildren) {
        if ([lazSour isMemberOfClass:[LazerSource class]]) {
            [lazSour stopShootingForAWhile]; // 打爆了红点要稍微暂停一下下
        }
    }
    [super crash];
    
    if (postNotification) {
        return;
    }
    postNotification = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:FirePacketExplosedNotification object:nil];
}

@end
