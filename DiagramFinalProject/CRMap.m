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


#pragma mark - Custom Getter

- (NSMutableArray *)nodeList {
    if (!_nodeList) {
        _nodeList = [[NSMutableArray alloc] init];
        _nodeList = [[Node fetchAllNodesFromContext:self.context] mutableCopy];
    }
    return _nodeList;
}

#pragma mark - Public Methods
- (void)calculateNewNodePositionFromParent:(Node *)parentNode withCompletionBlock:(void(^)(CGRect))completionBlock {
    if (parentNode.parent) {
        CGRect parentFrame = [self frameForNode:parentNode];
        CGRect newNodeFrame = CGRectMake(parentFrame.origin.x - 200, parentFrame.origin.y + parentFrame.size.height + 50, 100,100);
        for (Node *node in parentNode.childs) {
            CGRect childFrame = [self frameForNode:node];
            if (!CGRectIntersectsRect(newNodeFrame, childFrame)) {
                completionBlock(newNodeFrame);
            } else {
                newNodeFrame.origin.x += 200.0f;
            }
        }
        completionBlock(newNodeFrame);
    } else {
        CGRect newNodeParentFrame = CGRectMake(1000, 250, 100,100);
        completionBlock(newNodeParentFrame);
    }
}

- (CGRect)frameForNode:(Node *)node {
    return CGRectMake([node.xPosition floatValue], [node.yPosition floatValue], [node.width floatValue],[node.width floatValue]);
}

@end
