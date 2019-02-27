//
//  MyTextureAtlas.m
//  thisarrow
//
//  Created by iMac206 on 16/12/13.
//  Copyright © 2016年 jamstudio. All rights reserved.
//

#import "MyTextureAtlas.h"

static NSDictionary* textureDictionary;
static MyTextureAtlas* sharedTextureAtlasInstancetype;

@implementation MyTextureAtlas

+ (void)load {
    [self sharedTextureAtlas];
    [self sharedTextureDictionary];
}

+(instancetype)sharedTextureAtlas
{
    if (sharedTextureAtlasInstancetype==nil) {
        sharedTextureAtlasInstancetype=[MyTextureAtlas atlasNamed:@"texture.atlas"];
    }
    return sharedTextureAtlasInstancetype;
}

+(NSDictionary*)sharedTextureDictionary
{
    if (textureDictionary==nil) {
        NSMutableDictionary* dict=[NSMutableDictionary dictionary];
        NSArray* names=[MyTextureAtlas sharedTextureAtlas].textureNames;
        for (NSString* na in names) {
            SKTexture* texture=[[MyTextureAtlas sharedTextureAtlas]textureNamed:na];
            NSString *key = [na stringByReplacingOccurrencesOfString:@".png" withString:@""];
            key = [key stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
            key = [key stringByReplacingOccurrencesOfString:@"@3x" withString:@""];
            [dict setValue:texture forKey:key];
        }
        textureDictionary=[NSDictionary dictionaryWithDictionary:dict];
    }
    return textureDictionary;
}

+(SKTexture*)textureNamed:(NSString *)name
{
    SKTexture* texture=[[MyTextureAtlas sharedTextureDictionary]valueForKey:name];
    //[[MyTextureAtlas sharedTextureAtlas]textureNamed:name];
    return texture;
}


@end
