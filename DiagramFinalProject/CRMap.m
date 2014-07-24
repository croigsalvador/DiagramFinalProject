//
//  CRMap.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 22/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRMap.h"
#import "Node+Model.h"


@interface CRMap ()
@property (strong,nonatomic) NSManagedObjectContext *context;
@end

@implementation CRMap

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context {
    if (self = [super init]){
        _context = context;
    }
    return self;
}

#pragma mark - Public Methods
- (void)calculateNewNodePositionFromParent:(Node *)parentNode withCompletionBlock:(void(^)(CGRect))completionBlock {
    if (parentNode.parent) {
        
        CGRect parentFrame = [self frameForNode:parentNode.parent];
        CGRect newNodeFrame = CGRectMake(parentFrame.origin.x - 300, parentFrame.origin.y + parentFrame.size.height + 150, 150,150);
        
        for (Node *node in parentNode.parent.childs) {
            CGRect childFrame = [self frameForNode:node];
            if (CGRectIntersectsRect(newNodeFrame, childFrame)) {
                newNodeFrame.origin.x += 300.0f;
            }
        }
        
        completionBlock(newNodeFrame);
        
    } else {
        
        CGRect newNodeParentFrame = CGRectMake(700, 250, 150,150);
        NSArray *parents = [self fetchAllParents];
        for (Node *node in parents) {
            CGRect parentFrame = [self frameForNode:node];
            if (CGRectIntersectsRect(newNodeParentFrame, parentFrame)) {
                newNodeParentFrame.origin.x += 700.0f;
            }
        }
        
        completionBlock(newNodeParentFrame);
    }
}

#pragma mark - Private Methods

- (NSArray *)fetchAllParents {
    NSArray *parents = [Node rootNodeListInContext:self.context];
    return parents;
}


- (CGRect)frameForNode:(Node *)node {
    return CGRectMake([node.xPosition floatValue], [node.yPosition floatValue], [node.width floatValue],[node.width floatValue]);
}

@end
