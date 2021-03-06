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

extern NSString * const kTextPropertyName;
extern NSString * const kShapeTypePropertyName;
extern NSString * const kLevelPropertyName;
extern NSString * const kHeightPropertyName;
extern NSString * const kWidthPropertyName;
extern NSString * const kXPositionPropertyName;
extern NSString * const kYPositionPropertyName;


typedef NS_ENUM(NSUInteger, CRNodeTypeShape) {
    CRNodeTypeShapeSquare,
    CRNodeTypeShapeCircle,
    CRNodeTypeShapeTriangle,
    CRNodeTypeShapePolygon,
};

@interface Node (Model)

+ (Node *)createNodeInManagedObjectContext:(NSManagedObjectContext *)context;
+ (Node *)createNodeInManagedObjectContext:(NSManagedObjectContext *)context withParent:(Node *)parentNode;
+ (NSArray *)rootNodeListInContext:(NSManagedObjectContext *)context;
+ (NSArray *)fetchAllNodesFromContext:(NSManagedObjectContext *)context;

+ (NSFetchRequest *) fetchAllNodes;
+ (NSFetchRequest *) fetchAllNodesWithSortDescriptors:(NSArray *)sortDescriptors;
+ (NSFetchRequest *) fetchAllNodesByNameWithPredicate:(NSPredicate *)predicate;
+ (NSFetchRequest *) baseFetchRequest;

@end
