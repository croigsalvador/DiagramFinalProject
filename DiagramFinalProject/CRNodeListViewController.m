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
#import "SWTableViewCell.h"

#import "CRNodeMap.h"

#import "Node+Model.h"

static NSString * const NodeCellIdentifier               = @"NodeCellIdentifier";

static NSString *const kSegueAddNode                     = @"AddNodeSegue";
static NSString *const kSegueEditNode                    = @"EditNodeSegue";

static NSString *const kMainStoryBoardNameID             = @"Main";
static NSString *const kEditViewControllerID             = @"EditNavViewController";


static NSString *const kDeletingActionName               = @"DeleteAction";



@interface CRNodeListViewController ()<NSFetchedResultsControllerDelegate, SWTableViewCellDelegate, EditNodeDelegate>

@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (copy,nonatomic) NSArray * nodeList;
@property (strong,nonatomic) Node  *insertedNode;
@property (strong,nonatomic) Node  *deletedNode;
@property (assign,nonatomic, getter = isAlreadyNotificated) BOOL alreadyNotificated;

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation CRNodeListViewController

#pragma mark - ViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(populateNodeList:) name:UIDocumentStateChangedNotification object:self.managedDocument];
    //    [self populateNodeList];
}


#pragma mark - Custom Getters

- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        _managedObjectContext = self.managedDocument.managedObjectContext;
    }
    return _managedObjectContext;
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
//    for (Node *childNode in node.childs) {
//        self.deletedNode = node;
//        [self.managedObjectContext deleteObject:childNode];
//    }
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

#pragma mark - Navigation Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:kSegueAddNode]) {
        CREditNodeViewController *nodeEditViewController = (CREditNodeViewController *)[segue.destinationViewController topViewController];
        [self prepareEditNodeViewController:nodeEditViewController withNode:nil];
    } else if ([[segue identifier] isEqualToString:kSegueEditNode]) {
        UINavigationController *navViewController = [segue destinationViewController];
        CREditNodeViewController *nodeEditViewControlle=  [navViewController.viewControllers lastObject];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        Node *node = [self.fetchedResultsController objectAtIndexPath:selectedIndexPath];
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


#pragma mark - TableView Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.nodeList count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRNodeTableViewCell *cell = (CRNodeTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:NodeCellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = (CRNodeTableViewCell *)[[CRNodeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NodeCellIdentifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(CRNodeTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Node *node = [self nodeFromFetchedResultsControllerAtIndexPath:indexPath];
    
    cell.nodeTitleLabel.text = node.title;
    cell.rightUtilityButtons = [self rightButtons];
    cell.nodeTextLabel.text = node.text;
    
    [UIColor flatEmeraldColor];
    
    [cell configureCellWithColor:@"flatEmeraldColor" figure:[node.shapeType integerValue] andLevel:[node.level integerValue]];
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

- (void)swipeableTableViewCell:(CRNodeTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
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
            // hanfle error
        }
    }
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
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
            NSIndexPath * myIndexPath = [self.nodeMap indexPathNewForNode:self.insertedNode];
            
            [self.nodeMap addChild:self.insertedNode atIndex:myIndexPath.row];
            self.nodeList = self.nodeMap.mapList;
            [tableView insertRowsAtIndexPaths:@[myIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete:{
//            NSArray *deleteIndexPaths = [self.nodeMap deleteIndexPathsFor:self.deletedNode];
            NSIndexPath *delIndexPath = [self.nodeMap indexPathForCurrentNode:anObject];
            [self.nodeMap removeChildAtIndex:delIndexPath.row];

            self.nodeList = self.nodeMap.mapList;
            [tableView deleteRowsAtIndexPaths:@[delIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
//            NSIndexPath *updateIndexPath =  [self.nodeMap indexPathForCurrentNode:self.insertedNode];
//            CRNodeTableViewCell *currentCell = (CRNodeTableViewCell*)[self tableView:self.tableView cellForRowAtIndexPath:updateIndexPath];
//            if (currentCell.nodeTitleLabel.superview == nil) {
//                [currentCell setNeedsLayout];
//            }
            break;
        }
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    [self.tableView reloadData];
}


@end
