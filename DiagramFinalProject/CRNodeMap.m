//
//  CRNodeMap.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 15/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRNodeMap.h"
#import "Node+Model.h"

NSString * const kNodeIDKey             = @"nodeID";

@interface CRNodeMap ()

@property (copy,nonatomic) NSMutableDictionary *mutableMapDictionary;
@property (copy,nonatomic) NSMutableArray *mutableMapArray;
@property (copy,nonatomic) NSDictionary *mappings;

@end

@implementation CRNodeMap

#pragma mark - Lazy Getters

- (NSMutableArray *)mutableMapArray {
    if (!_mutableMapArray) {
        _mutableMapArray = [[NSMutableArray alloc] init];
    }
    return _mutableMapArray;
}

- (NSArray *)mapList {
    return self.mutableMapArray;
}

#pragma mark - Public Methods

- (void)addChild:(Node *)node atIndex:(NSUInteger)index {
    NSDictionary *nodeDictionary = @{kLevelPropertyName : node.level,
                                     kTitlePropertyName : @"Prueba" ,
                                             kNodeIDKey : [node objectID]};
    
    [self.mutableMapArray insertObject:nodeDictionary atIndex:index];
}

- (void)removeChildAtIndex:(NSUInteger)index{
    [self.mutableMapArray removeObjectAtIndex:index];
}


/**
 *  Launch listeArrayOfNodes
 *
 *  @param node Root Node
 */
- (void)populateMapListForRootNode:(Node *)node; {
    [self listedArrayOfNodesWithParentNode:node];
}

- (NSIndexPath *)indexPathForNode:(Node *)node {
    NSIndexPath *indexPath;
    if (node.parent) {
        indexPath = [NSIndexPath indexPathForRow:[self indexOfNode:node.parent]  inSection:0];
    } else {
        indexPath = [NSIndexPath indexPathForRow:([self.mutableMapArray count]-1) inSection:0];
    }
    return indexPath;
}

#pragma mark - Private Methods

- (NSInteger)indexOfNode:(Node *)node {
    NSUInteger index = [node.childs count];
    for (NSDictionary *dict in self.mutableMapArray) {
        if ([[node objectID] isEqual:dict[kNodeIDKey]]) {
            index += ([self.mutableMapArray indexOfObject:dict]);
        }
    }
    return index;
}

- (NSDictionary *)listedArrayOfNodesWithParentNode:(Node *)node {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:node.level forKey:kLevelPropertyName];
    [dict setValue:node.title forKey:kTitlePropertyName];
    [dict setValue:[node objectID] forKey:kNodeIDKey];
    
    [self.mutableMapArray addObject:dict];
    
    if ([node.childs count] <= 0) {
        return dict;
    } else {
        for (Node *childNode in node.childs) {
            [self listedArrayOfNodesWithParentNode:childNode];
        }
        return  dict;
    }
}

/**
 *  Serialize MAP Into NSDictionary
 *
 *  @param node Nodo
 *
 *  @return Node Dictionary
 */

- (NSDictionary *)serializedDictionaryWithParentNode:(Node *)node {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:node.title forKey:kTitlePropertyName];
    [dict setValue:@"Por poner algo" forKey:kTextPropertyName];
    [dict setValue:node.shapeType forKey:kShapeTypePropertyName];
    
    if ([node.childs count] <= 0) {
        return dict;
    } else {
        NSMutableArray *childArray = [[NSMutableArray alloc] init];
        for (Node *childNode in node.childs) {
            NSDictionary *childDict = [self serializedDictionaryWithParentNode:childNode];
            if (childDict == nil) return nil;
            [childArray addObject:childDict];
        }
        [dict setValue:childArray forKey:@"childs"];
        return  dict;
    }
}
@end
