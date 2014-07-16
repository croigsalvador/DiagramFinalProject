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

+ (Node *)rootNodeInContext:(NSManagedObjectContext *)context {
    Node *rootNode;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@", @"Map name"];
    NSFetchRequest *fetchRequest = [Node fetchAllNodesByNameWithPredicate:predicate];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
    NSLog(@"%@", matches);
    if ([matches count]== 1) {
        rootNode = [matches lastObject];
    } else {
        //TO DO ERROR
    }
    return rootNode;    
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
