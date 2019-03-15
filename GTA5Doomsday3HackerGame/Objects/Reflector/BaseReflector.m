//
//  BaseReflector.m
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/2/28.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "BaseReflector.h"

@implementation BaseReflector

+ (instancetype)spriteNodeWithTexture:(SKTexture *)texture size:(CGSize)size {
    BaseReflector *spr = [super spriteNodeWithTexture:texture size:size];
    spr.zPosition = BaseZPositionReflector;
    return spr;
}

- (CGFloat)realZRotation {
    return self.zRotation;
}

- (BOOL)isPointInSelf:(CGPoint)point {
    return CGRectContainsPoint(self.frame, point);
}

- (ZZLine)getNewLineWithOldLine:(ZZLine)oldLine {
    CGFloat selfRealRotation = self.realZRotation;
    ZZLine selfLine = ZZLineMake(self.position.x, self.position.y, selfRealRotation);
    
    CGPoint intersectionPoint = CGPointIntersectionFromLines(oldLine, selfLine);
    if (![self isPointInSelf:intersectionPoint]) {
        return oldLine;
    }
    
    CGFloat reflectedZRotation = (selfRealRotation - oldLine.alpha) + selfRealRotation;
//    CGFloat deltaRotation = reflectedZRotation -  oldLine.alpha + M_PI;
    return ZZLineMake(intersectionPoint.x, intersectionPoint.y, reflectedZRotation);
}

@end
