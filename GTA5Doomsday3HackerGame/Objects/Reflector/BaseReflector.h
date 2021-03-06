//
//  BaseReflector.h
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/28.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "BaseSprite.h"
#import "LazerParticle.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseReflector : BaseSprite

@property (nonatomic, assign, readonly) CGFloat realZRotation;

- (BOOL)isPointInSelf:(CGPoint)point;

- (ZZLine)getNewLineWithOldLine:(ZZLine)oldLine;

@end

NS_ASSUME_NONNULL_END
