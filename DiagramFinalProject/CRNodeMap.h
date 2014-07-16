//
//  CRNodeMap.h
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 15/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Node;

@interface CRNodeMap : NSObject

@property (strong,nonatomic,readonly) NSDictionary *mapDictionary;
@property (strong,nonatomic,readonly) NSArray  *mapList;

- (void)addChild:(Node *)node toParent:(Node *)parentNode;
- (void)removeChild:(Node *)node fromParent:(Node *)parentNode;
- (NSDictionary *)serializedDictionaryWithParentNode:(Node *)node;
- (void)lanzaderaParaElmetodo:(Node *)node;

@end
