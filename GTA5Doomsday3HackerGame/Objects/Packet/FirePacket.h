//
//  FirePacket.h
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/28.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "DataPacket.h"

NS_ASSUME_NONNULL_BEGIN

@interface FirePacket : DataPacket

+ (instancetype)firePacketWithPosition:(CGPoint)position;

@end

NS_ASSUME_NONNULL_END
