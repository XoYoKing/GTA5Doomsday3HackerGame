//
//  FirePacket.m
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/28.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "FirePacket.h"

@implementation FirePacket

+ (instancetype)firePacketWithPosition:(CGPoint)position {
    FirePacket *pack = [FirePacket spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"FirePacket"] size:OBJ_BLOCK_SIZE];
    pack.position = position;
    return pack;
}

@end
