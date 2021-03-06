//
//  Node+Model.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 14/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "Node+Model.h"

NSString * const kNodeEntityName                    = @"Node";
NSString * const kTitlePropertyName                 = @"title";
NSString * const kTextPropertyName                  = @"text";
NSString * const kShapeTypePropertyName             = @"shapeType";
NSString * const kLevelPropertyName                 = @"level";
NSString * const kHeightPropertyName                = @"height";
NSString * const kWidthPropertyName                 = @"width";
NSString * const kXPositionPropertyName             = @"xPosition";
NSString * const kYPositionPropertyName             = @"yPosition";

@implementation Node (Model)

#pragma mark - Creating Node

+ (instancetype)createNodeInManagedObjectContext:(NSManagedObjectContext *)context {
    Node *node = [NSEntityDescription insertNewObjectForEntityForName:kNodeEntityName inManagedObjectContext:context];
    node.shapeType = @(CRNodeTypeShapeSquare);
    
    return node;
}

+ (instancetype)createNodeInManagedObjectContext:(NSManagedObjectContext *)context withParent:(Node *)parentNode {
    Node *node = [self createNodeInManagedObjectContext:context];
    node.parent = parentNode;
    node.level = @([parentNode.level intValue] + 1);
    
    return node;
}

+ (NSArray *)rootNodeListInContext:(NSManagedObjectContext *)context {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"level == %@",@1];
    NSFetchRequest *fetchRequest = [Node fetchAllNodesByNameWithPredicate:predicate];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
    return matches;
}

+ (NSArray *)fetchAllNodesFromContext:(NSManagedObjectContext *)context {
    NSArray *matches = [context executeFetchRequest:[Node fetchAllNodes] error:NULL];
    return matches;
}

#pragma mark - Fetch requests

+ (NSFetchRequest *) fetchAllNodes {
    NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor  sortDescriptorWithKey:kTitlePropertyName ascending:YES];
    NSFetchRequest *fetchRequest = [Node fetchAllNodesWithSortDescriptors:@[nameSortDescriptor]];
    
    return fetchRequest;
}

+ (NSFetchRequest *) fetchAllNodesWithSortDescriptors:(NSArray *)sortDescriptors {
    NSFetchRequest *fetchRequest = [Node baseFetchRequest];
    fetchRequest.sortDescriptors = sortDescriptors;
    
    return fetchRequest;
}

+ (NSFetchRequest *) fetchAllNodesByNameWithPredicate:(NSPredicate *)predicate {
    NSFetchRequest *fetchRequest = [Node fetchAllNodes];
    fetchRequest.predicate = predicate;
    
    return fetchRequest;
}

+ (NSFetchRequest *) baseFetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kNodeEntityName];
    fetchRequest.fetchBatchSize = 20;
    
    return fetchRequest;
}


@end
