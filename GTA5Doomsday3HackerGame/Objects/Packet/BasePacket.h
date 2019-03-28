//
//  BasePacket.h
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/3/4.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "BaseSprite.h"

NS_ASSUME_NONNULL_BEGIN

@interface BasePacket : BaseSprite

@property (nonatomic, strong, readonly) SKTexture *tintTexture; 
@property (nonatomic, strong, readonly) SKTexture *explosionTexture;
- (void)getHurt;

- (void)didFinishedCrash;

@end

NS_ASSUME_NONNULL_END
