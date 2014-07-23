//
//  CRMap.h
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 22/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Node;

@interface CRMap : NSObject

@property (strong,nonatomic) NSMutableArray *nodeList;
- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context;
- (void)calculateNewNodePositionFromParent:(Node *)parentNode withCompletionBlock:(void(^)(CGRect))completionBlock;

@end
