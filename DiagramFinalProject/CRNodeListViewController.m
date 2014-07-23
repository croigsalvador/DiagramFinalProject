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

static NSString * const NodeCellIdentifier               = @"NodeCellIdentifier";
static NSString * const AddNodeCellIdentifier            = @"AddNodeCellIdentifier";
static NSString *const kSegueAddNode                     = @"AddNodeSegue";
static NSString *const kSegueEditNode                    = @"EditNodeSegue";
static NSString *const kMainStoryBoardNameID             = @"Main";
static NSString *const kEditViewControllerID             = @"EditNavViewController";
static NSString *const kDeletingActionName               = @"DeleteAction";

@interface CRNodeListViewController ()<NSFetchedResultsControllerDelegate, SWTableViewCellDelegate, EditNodeDelegate, AddNodeHeaderDelegate>

@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (copy,nonatomic) NSArray * nodeList;
@property (strong,nonatomic) Node  *insertedNode;
@property (strong,nonatomic) Node  *deletedNode;
@property (assign,nonatomic, getter = isAlreadyNotificated) BOOL alreadyNotificated;
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (copy, nonatomic ) NSMutableArray *deleteIndexs;
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

- (void)prepareViewControllerFromStoryBoardWithNewNode:(Node *)node {
    UIStoryboard *mapStoryboard = [UIStoryboard storyboardWithName:kMainStoryBoardNameID bundle:[NSBundle mainBundle]];
    
    UINavigationController *nextVC = [mapStoryboard instantiateViewControllerWithIdentifier:kEditViewControllerID];
    CREditNodeViewController *editViewController =(CREditNodeViewController *) [nextVC topViewController];
    editViewController.delegate = self;
    editViewController.node = node;
    
    [self presentViewController:nextVC animated:YES completion:nil];
}

- (void)addChildNodeToParentAtIndexPath:(NSIndexPath *)indexPath {
    [self.managedObjectContext.undoManager beginUndoGrouping];
    Node *parentNode = [self nodeFromFetchedResultsControllerAtIndexPath:indexPath];
    self.insertedNode = [Node createNodeInManagedObjectContext:self.managedObjectContext withParent:parentNode];
    [self prepareViewControllerFromStoryBoardWithNewNode:self.insertedNode];
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
    
    self.insertedNode = nil;
    return myIndexPath;
}

#pragma mark - Navigation Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:kSegueAddNode]) {
        CREditNodeViewController *nodeEditViewController = (CREditNodeViewController *)[segue.destinationViewController topViewController];
        [self prepareEditNodeViewController:nodeEditViewController withNode:nil];
    } else if ([[segue identifier] isEqualToString:kSegueEditNode]) {
        UINavigationController *navViewController = [segue destinationViewController];
        CREditNodeViewController *nodeEditViewControlle=  [navViewController.viewControllers lastObject];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        Node *node = [self nodeFromFetchedResultsControllerAtIndexPath:selectedIndexPath];
        [self prepareEditNodeViewController:nodeEditViewControlle withNode:node];
    }
}

- (void)prepareEditNodeViewController:(CREditNodeViewController *)editNodetViewController withNode:(Node *)node {
    [self.managedObjectContext.undoManager beginUndoGrouping];
    if (!node) {
        Node *newNode = [Node createNodeInManagedObjectContext:self.managedObjectContext withParent:nil];
        self.insertedNode = newNode;
        editNodetViewController.node = newNode;
    } else {
        editNodetViewController.node = node;
    }
    editNodetViewController.delegate = self;
}

#pragma mark - TableView Delegate Methods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:kSegueEditNode sender:nil];
    }
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
    [self performSegueWithIdentifier:kSegueAddNode sender:nil];
}

#pragma mark - EditNode Delegate Methods

- (void)dismissEditNodeViewController:(CREditNodeViewController *)editNodeViewController modifiedData:(BOOL)modifiedData {
    [self.managedObjectContext.undoManager setActionName:@"Bad Action"];
    [self.managedObjectContext.undoManager endUndoGrouping];
    if (!modifiedData) {
        [self.managedObjectContext.undoManager undo];
    } else {
        // TODO SAVE DATA
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SWTableView Delegate Methods

- (void)swipeableTableViewCell:(CRNodeTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    switch (index) {
        case 0:
            [self addChildNodeToParentAtIndexPath:cellIndexPath];
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


@end
