//
//  CRNodeMap.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 15/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRNodeMap.h"
#import "Node+Model.h"

@interface CRNodeMap ()
@property (strong,nonatomic) NSMutableDictionary *mutableMapDictionary;
@property (strong,nonatomic) NSMutableArray *mutableMapArray;
@property (strong,nonatomic) NSDictionary *mappings;

@end

@implementation CRNodeMap

#pragma mark - Lazy Getters

- (NSMutableDictionary *)mutableMapDictionary {
    if (!_mutableMapDictionary) {
        _mutableMapDictionary = [[NSMutableDictionary alloc] init];
    }
    return _mutableMapDictionary;
}

- (NSMutableArray *)mutableMapArray {
    if (!_mutableMapArray) {
        _mutableMapArray = [[NSMutableArray alloc] init];
    }
    return _mutableMapArray;
}

- (NSDictionary *)mapDictionary {
    return [self.mutableMapDictionary copy];
}

#pragma mark - Public Methods

- (void)addChild:(Node *)node toParent:(Node *)parentNode {
    
}

- (void)removeChild:(Node *)node fromParent:(Node *)parentNode {
    
}

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

- (void)lanzaderaParaElmetodo:(Node *)node {
    [self listedArrayOfNodesWithParentNode:node];
    NSLog(@"%@", self.mutableMapArray);
}

- (NSDictionary *)listedArrayOfNodesWithParentNode:(Node *)node {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:node.title forKey:kTitlePropertyName];
    [dict setValue:[node objectID]   forKey:@"idNode"];
    
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


@end
