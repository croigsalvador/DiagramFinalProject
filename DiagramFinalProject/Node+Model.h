//
//  Node+Model.h
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 14/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "Node.h"

extern NSString * const kNodeEntityName;
extern NSString * const kTitlePropertyName;

@interface Node (Model)

+ (Node *)createNodeInManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSFetchRequest *) fetchAllNodesByTitle;
+ (NSFetchRequest *) fetchAllNodesWithSortDescriptors:(NSArray *)sortDescriptors;
+ (NSFetchRequest *) fetchAllAgentsByNameWithPredicate:(NSPredicate *)predicate;
+ (NSFetchRequest *) baseFetchRequest;

@end
