//
//  CRNodeMap.h
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 15/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kNodeIDKey;

@class Node;

@interface CRNodeMap : NSObject

@property (copy,nonatomic,readonly) NSArray  *mapList;

- (void)addChild:(Node *)node atIndex:(NSUInteger)index;
- (void)removeChildAtIndex:(NSUInteger)index;
- (void)updateNode:(Node *)node atIndex:(NSUInteger)index;

- (void)populateMapListForRootNode:(Node *)node;

- (NSIndexPath *)indexPathNewForNode:(Node *)node;
- (NSIndexPath *)indexPathForCurrentNode:(Node *)node;

- (void)deleteNodesAtIndex:(NSArray *)deleteIndexs;

//- (CGPoint)calculateFreeRectForNode:(Node *)node;
- (CGPoint)calculateFreeRectForNode:(Node *)node point:(CGPoint)point;
@end
