//
//  LazerParticle.h
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/27.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "BaseSprite.h"

NS_ASSUME_NONNULL_BEGIN

@interface LazerParticle : BaseSprite

@property (nonatomic, strong) NSMutableArray *hitObjects;

+ (instancetype)lazerParticleWithZRotation:(CGFloat)zRotation position:(CGPoint)position;

- (void)testWithObjects:(NSArray *)objects;

@end

NS_ASSUME_NONNULL_END
