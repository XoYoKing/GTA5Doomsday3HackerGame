//
//  DataPacket.h
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/28.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "BaseSprite.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataPacket : BaseSprite

+ (instancetype)dataPacketWithPosition:(CGPoint)position;

@property (nonatomic, strong, readonly) SKTexture *explosionTexture;

@end

NS_ASSUME_NONNULL_END
