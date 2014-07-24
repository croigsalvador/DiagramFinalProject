//
//  CRViewController.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 14/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRNodeListViewController.h"
#import "CREditNodeViewController.h"
#import "CRNodeTableViewCell.h"
#import "CRAddNodeHeaderSection.h"
#import "SWTableViewCell.h"
#import "CRNodeMap.h"
#import "Node+Model.h"
#import "CRMap.h"
#import "CRManagedDocument.h"
#import "CRAddNodeView.h"

static NSString * const NodeCellIdentifier               = @"NodeCellIdentifier";
static NSString * const AddNodeCellIdentifier            = @"AddNodeCellIdentifier";
static NSString *const kSegueAddNode                     = @"AddNodeSegue";
static NSString *const kSegueEditNode                    = @"EditNodeSegue";
static NSString *const kMainStoryBoardNameID             = @"Main";
static NSString *const kEditViewControllerID             = @"EditNavViewController";
static NSString *const kDeletingActionName               = @"DeleteAction";

static CGPoint const kDocumentViewPoint                  = {212.0f, 100.0f};
static CGSize  const kDocumentViewSize                   = {600.0f, 230.0f};

@interface CRNodeListViewController ()<NSFetchedResultsControllerDelegate, SWTableViewCellDelegate, AddNodeHeaderDelegate, AddNodeDelegate>

@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (copy,nonatomic) NSArray * nodeList;
@property (strong,nonatomic) Node  *insertedNode;
@property (strong,nonatomic) Node  *deletedNode;
@property (assign,nonatomic, getter = isAlreadyNotificated) BOOL alreadyNotificated;
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (copy, nonatomic ) NSMutableArray *deleteIndexs;
@property (copy, nonatomic ) NSMutableArray *deletedNodes;
@property (strong,nonatomic) CRAddNodeView *addNodeView;
@property (strong,nonatomic) NSIndexPath *parentIndexPath;
@property (assign,nonatomic, getter = isDeleting) BOOL deleting;

@end

@implementation CRNodeListViewController

#pragma mark - Initializer

- (instancetype)initWithDocument:(CRManagedDocument *)document andNodeMap:(CRNodeMap *)nodeMap {
    if (self = [super init]) {
        _managedDocument = document;
        _nodeMap = nodeMap;
    }
    return self;
}

#pragma mark - ViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(populateNodeList:) name:UIDocumentStateChangedNotification object:self.managedDocument];
    self.tableView.backgroundColor = [UIColor lightGrayCustom];
    [self.view addSubview:self.addNodeView];
}

/**
 *  fetchedResultsController delegate set to self
 *  separating between ViewControllers;
 *
 *  @param animated
 */

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.nodeList = self.nodeMap.mapList;
    self.fetchedResultsController = self.fetchedResultsController;
    [self.tableView reloadData];
}

/**
 *  Setting fetchedResultsController delegate
 * to nil so that not notify  the other viewController
 *
 *  @param animated
 */

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.fetchedResultsController.delegate = nil;
    self.fetchedResultsController = nil;
}

#pragma mark - Custom Getters

- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        _managedObjectContext = self.managedDocument.managedObjectContext;
    }
    return _managedObjectContext;
}

- (NSMutableArray *)deleteIndexs {
    if (!_deleteIndexs) {
        _deleteIndexs = [[NSMutableArray alloc] init];
    }
    return _deleteIndexs;
}
- (NSMutableArray *)deletedNodes {
    if (!_deletedNodes) {
        _deletedNodes = [[NSMutableArray alloc] init];
    }
    return _deletedNodes;
}

- (CRAddNodeView *)addNodeView{
    if (!_addNodeView) {
        _addNodeView = [[CRAddNodeView alloc] initWithFrame:CGRectMake(kDocumentViewPoint.x, -kDocumentViewPoint.y , kDocumentViewSize.width, kDocumentViewSize.height)];
        _addNodeView.delegate = self;
        _addNodeView.hidden = YES;
    }
    return _addNodeView;
}

#pragma mark - Private Methods

- (void)populateNodeList:(NSNotification *)notification {
    if (!self.isAlreadyNotificated) {
        NSArray *nodes = [Node rootNodeListInContext:self.managedObjectContext];
        for (Node *node in nodes) {
            [self.nodeMap populateMapListForRootNode:node];
        }
        self.nodeList = self.nodeMap.mapList;
        self.fetchedResultsController = self.fetchedResultsController;
        [self.tableView reloadData];
        self.alreadyNotificated = YES;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDocumentStateChangedNotification object:self.managedDocument];
    }
}

- (void)addChildNodeToParentAtIndexPath:(NSIndexPath *)indexPath andName:(NSString *)title {
    [self.managedObjectContext.undoManager beginUndoGrouping];
    Node *parentNode  = nil;
    if (self.parentIndexPath) {
        parentNode = [self nodeFromFetchedResultsControllerAtIndexPath:indexPath];
    }
    self.insertedNode = [Node createNodeInManagedObjectContext:self.managedObjectContext withParent:parentNode];
    self.insertedNode.title = title;
    self.parentIndexPath = nil;
    [self.managedObjectContext.undoManager endUndoGrouping];
}

- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.managedObjectContext.undoManager beginUndoGrouping];
    
    Node *node = [self nodeFromFetchedResultsControllerAtIndexPath:indexPath];
    self.deletedNode = node;
    [self.managedObjectContext deleteObject:node];
    
    [self.managedObjectContext.undoManager setActionName:kDeletingActionName];
    [self.managedObjectContext.undoManager endUndoGrouping];
}

- (Node *)nodeFromFetchedResultsControllerAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *nodeDictionary = self.nodeList[indexPath.row];
    NSManagedObjectID *nodeID = nodeDictionary[kNodeIDKey];
    Node *node =(Node *) [self.fetchedResultsController.managedObjectContext existingObjectWithID:nodeID error:nil];
    return node;
}

- (void)removeNodes {
    [self.nodeMap deleteNodesAtIndex:[self.deleteIndexs copy]];
    self.deleting = NO;
    self.deleteIndexs = nil;
    self.nodeList = self.nodeMap.mapList;
    self.removeNodeViewBlock(self.deletedNodes);
    self.deletedNodes = nil;
    
}

- (NSIndexPath *)indexPathAfterInsertNewNodeWithObject:(id)anObject {
    if (!self.insertedNode) {
        self.insertedNode = anObject;
    }
    CRMap *map = [[CRMap alloc] initWithManagedObjectContext:self.insertedNode.managedObjectContext];
    __weak typeof(self) weakSelf = self;
    [map calculateNewNodePositionFromParent:self.insertedNode withCompletionBlock:^(CGRect frame) {
        weakSelf.insertedNode.xPosition = @(frame.origin.x) ;
        weakSelf.insertedNode.yPosition = @(frame.origin.y) ;
    }];
    
    NSIndexPath * myIndexPath = [self.nodeMap indexPathNewForNode:self.insertedNode];
    [self.nodeMap addChild:self.insertedNode atIndex:myIndexPath.row];
    self.nodeList = self.nodeMap.mapList;
    
    // Paint node in Map
    self.addNewNodeHandlerBLock(self.insertedNode);
    
    self.insertedNode = nil;
    return myIndexPath;
}


#pragma mark - TableView Delegate Methods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Edit node
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CRAddNodeHeaderSection *headerSection = [[CRAddNodeHeaderSection alloc] initWithFrame:CGRectMake(0, 0, 1024, 100)];
    headerSection.delegate = self;
    return headerSection;
}

#pragma mark - TableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.nodeList count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRNodeTableViewCell *cell = (CRNodeTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:NodeCellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(CRNodeTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Node *node = [self nodeFromFetchedResultsControllerAtIndexPath:indexPath];
    cell.nodeTitleLabel.text = node.title;
    cell.rightUtilityButtons = [self rightButtons];
    cell.nodeTextLabel.text = node.text;
    [cell configureCellWithColor:node.color figure:[node.shapeType integerValue] andLevel:[node.level integerValue]];
    cell.delegate = self;
}

#pragma mark - UIElements Setup

- (NSArray *)rightButtons {
    NSMutableArray *rightUtilityButtons = [[NSMutableArray alloc]init];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"Add Child"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

#pragma mark - Delegate Methods
#pragma mark - HeaderSection Delegate

- (void)addNodeButtonPressed:(CRAddNodeHeaderSection *)headerSection {
    [self addNodeAction];
}


#pragma mark - SWTableView Delegate Methods

- (void)swipeableTableViewCell:(CRNodeTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    switch (index) {
        case 0:
            [self addNodeAction];
            self.parentIndexPath = cellIndexPath;
            [cell hideUtilityButtonsAnimated:YES];
            break;
        case 1:{
            [self deleteItemAtIndexPath:cellIndexPath];
            break;
        }
    }
}

#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        _fetchedResultsController = [[NSFetchedResultsController  alloc] initWithFetchRequest:[Node fetchAllNodes] managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultsController.delegate = self;
        if (![_fetchedResultsController performFetch:nil]){
        }
    }
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    switch(type) {
        case NSFetchedResultsChangeInsert:{
            [tableView insertRowsAtIndexPaths:@[[self indexPathAfterInsertNewNodeWithObject:anObject]] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete:{
            NSIndexPath *delIndexPath = [self.nodeMap indexPathForCurrentNode:anObject];
            [self.deletedNodes addObject:anObject];
            [self.deleteIndexs addObject:@(delIndexPath.row)];
            self.deleting = YES;
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            break;
        }
        case NSFetchedResultsChangeMove:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if (self.isDeleting) {
        [self removeNodes];
    }
    [self.tableView reloadData];
}

#pragma mark - PopApp Add Node Methods

- (void)addNodeAction {
    if (self.addNodeView.hidden) {
        self.addNodeView.hidden = NO;
        [self animatePopUpDisplay];
    }
}

- (void)animatePopUpDisplay {
    
    [UIView animateWithDuration:.4 animations:^{
        CGRect popFrmae = CGRectMake(kDocumentViewPoint.x, kDocumentViewPoint.y, kDocumentViewSize.width, kDocumentViewSize.height);
        self.addNodeView.frame = popFrmae;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - AddNode Delegate Methods

- (void)buttonPressedInView:(CRAddNodeView *)addNodeView withTag:(NSUInteger)tag andText:(NSString *)name{
    CGRect frame = CGRectMake(kDocumentViewPoint.x, -kDocumentViewSize.height, kDocumentViewSize.width, kDocumentViewSize.height);
    self.addNodeView.frame = frame;
    self.addNodeView.hidden = YES;
    switch (tag) {
        case 1:
            
            break;
        case 2:
            [self addChildNodeToParentAtIndexPath:self.parentIndexPath andName:name];
            break;
    }
}


@end
