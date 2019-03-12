//
//  DataPacket.m
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/28.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "DataPacket.h"

@implementation DataPacket

+ (instancetype)dataPacketWithPosition:(CGPoint)position {
    DataPacket *pack = [DataPacket spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"DataPacket"] size:OBJ_BLOCK_SIZE];
    pack.position = position;
//    pack.color = [SKColor whiteColor];
    return pack;
}

- (SKTexture *)explosionTexture {
    return [MyTextureAtlas textureNamed:@"CyanExplosion"];
}

- (SKTexture *)tintTexture {
    return [MyTextureAtlas textureNamed:@"DataPacketTint"];
}

@end
