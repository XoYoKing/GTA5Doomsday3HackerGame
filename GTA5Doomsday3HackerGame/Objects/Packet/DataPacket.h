//
//  DataPacket.h
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/28.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "BasePacket.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataPacket : BasePacket

+ (instancetype)dataPacketWithPosition:(CGPoint)position;

@end

NS_ASSUME_NONNULL_END
