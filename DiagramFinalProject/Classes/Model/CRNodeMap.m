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
@property (copy,nonatomic) NSMutableArray *mutableDictArray;
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
- (NSMutableArray *)mutableDictArray {
    if (!_mutableDictArray) {
        _mutableDictArray = [[NSMutableArray alloc] init];
    }
    return _mutableDictArray;
}

- (NSArray *)mapList {
    return [self.mutableMapArray copy];
}

#pragma mark - Public Methods

- (void)addChild:(Node *)node atIndex:(NSUInteger)index {
    [self.mutableMapArray insertObject:[self createNodeDictionaryForNode:node] atIndex:index];
}

- (void)removeChildAtIndex:(NSUInteger)index{
    [self.mutableMapArray removeObjectAtIndex:index];
}

- (void)updateNode:(Node *)node atIndex:(NSUInteger)index {
    [self.mutableMapArray replaceObjectAtIndex:index withObject:[self createNodeDictionaryForNode:node]];
}

/**
 *  Launch listeArrayOfNodes
 *
 *  @param node Root Node
 */
- (void)populateMapListForRootNode:(Node *)node; {
    [self listedArrayOfNodesWithParentNode:node];
}

- (NSIndexPath *)indexPathNewForNode:(Node *)node {
    NSIndexPath *indexPath;
    if (node.parent) {
        indexPath = [NSIndexPath indexPathForRow:[self newIndexForNewOfNode:node.parent]  inSection:0];
    } else {
        indexPath = [NSIndexPath indexPathForRow:([self.mutableMapArray count]) inSection:0];
    }
    return indexPath;
}

- (NSIndexPath *)indexPathForCurrentNode:(Node *)node {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self indexForNode:node]  inSection:0];
    return indexPath;
}

- (void)deleteNodesAtIndex:(NSArray *)deleteIndexs {
    NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: NO];
    NSArray *indexs = [deleteIndexs  sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]];
    for (NSNumber *index in indexs) {
        [self removeChildAtIndex:[index intValue]];
    }
}

- (CGPoint)calculateFreeRectForNode:(Node *)node point:(CGPoint)point {
    if (!node.parent) {
        CGPoint newPoint;
        NSDictionary *nodeDict = [self createNodeDictionaryForNode:node];
        int i = 0;
        for (NSDictionary *dict in [self brotherParentsInContext:node.managedObjectContext]) {
            if ([nodeDict isEqualToDictionary:dict]) {
                newPoint.y = [node.level intValue] * (100 + 100);
                newPoint.x = point.x + (i* 200) ;
            }
        }
        return newPoint;
    }
    [self listedArrayOfNodesForAParentNode:node.parent];
    NSDictionary *currentNodeDict = [self createNodeDictionaryForNode:node];
    
    CGPoint nodePoint;
    int countInNodeLevel = -1;
    for(NSDictionary *dictnode in self.mutableDictArray){
        if ([dictnode[kLevelPropertyName] isEqualToNumber:currentNodeDict[kLevelPropertyName]]) {
            countInNodeLevel++;
            if ([currentNodeDict isEqualToDictionary:dictnode]) {
                nodePoint.y = [node.parent.yPosition floatValue] + 150 ;
                nodePoint.x = [node.parent.xPosition floatValue] - (countInNodeLevel * [node.width floatValue]) + (countInNodeLevel * 100);
            }
        }
        countInNodeLevel++;
    }
    self.mutableDictArray = nil;
    return nodePoint;
}

#pragma mark - Private Methods

- (NSArray *)brotherParentsInContext:(NSManagedObjectContext *)context {
    NSArray *parentsNodes = [Node rootNodeListInContext:context];
    NSMutableArray *dictArray = [[NSMutableArray alloc] init];
    for (Node *node in parentsNodes) {
        [dictArray addObject:[self createNodeDictionaryForNode:node]];
    }
    return [dictArray copy];
}

- (CGRect)rectFromNodeDictionary:(NSDictionary *)dict {
    CGRect frameCurrentNode = {
        .origin.x = [dict[kXPositionPropertyName] floatValue],
        .origin.y = [dict[kYPositionPropertyName] floatValue],
        .size.width = [dict[kWidthPropertyName] floatValue],
        .size.height = [dict[kHeightPropertyName] floatValue],
    };
    return frameCurrentNode;
}

- (NSDictionary *)createNodeDictionaryForNode:(Node *)node {
    NSMutableDictionary *nodeDict = [NSMutableDictionary dictionary];
    [nodeDict setValue:node.level forKey:kLevelPropertyName];
    [nodeDict setValue:[node objectID] forKey:kNodeIDKey];
    [nodeDict setValue:node.xPosition forKey:kXPositionPropertyName];
    [nodeDict setValue:node.yPosition forKey:kYPositionPropertyName];
    
    return [nodeDict copy];
}

- (NSInteger)newIndexForNewOfNode:(Node *)node {
    NSUInteger index = [self indexForNode:node];
    [self listedArrayOfNodesForAParentNode:node];
    index += [self.mutableDictArray count] - 1;
    self.mutableDictArray = nil;
    return index;
}

- (NSInteger)indexForNode:(Node *)node {
    NSUInteger index = 0;
    for (NSDictionary *dict in self.mutableMapArray) {
        if ([[node objectID] isEqual:dict[kNodeIDKey]]) {
            index = ([self.mutableMapArray indexOfObject:dict]);
        }
    }
    return index;
}

- (NSDictionary *)listedArrayOfNodesWithParentNode:(Node *)node {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:node.level forKey:kLevelPropertyName];
    [dict setValue:[node objectID] forKey:kNodeIDKey];
    [dict setValue:node.xPosition forKey:kXPositionPropertyName];
    [dict setValue:node.yPosition forKey:kYPositionPropertyName];
    
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
- (NSDictionary *)listedArrayOfNodesForAParentNode:(Node *)node {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:node.level forKey:kLevelPropertyName];
    [dict setValue:[node objectID] forKey:kNodeIDKey];
    [dict setValue:node.xPosition forKey:kXPositionPropertyName];
    [dict setValue:node.yPosition forKey:kYPositionPropertyName];
    
    [self.mutableDictArray addObject:dict];
    
    if ([node.childs count] <= 0) {
        return dict;
    } else {
        for (Node *childNode in node.childs) {
            [self listedArrayOfNodesForAParentNode:childNode];
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
