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

#import "Node+Model.h"

static NSString * const NodeCellIdentifier               = @"NodeCellIdentifier";

static NSString *const kSegueAddNode                     = @"AddNodeSegue";
static NSString *const kSegueEditNode                    = @"EditNodeSegue";

@interface CRNodeListViewController ()<NSFetchedResultsControllerDelegate, SWTableViewCellDelegate, EditNodeDelegate>

@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation CRNodeListViewController

#pragma mark - ViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.managedDocument.documentState == UIDocumentStateNormal) {
        
    }
}

#pragma mark - Private Methods

- (void)prepareViewControllerFromStoryBoardWithNewNode:(Node *)node {
    UIStoryboard *mapStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    UINavigationController *nextVC = [mapStoryboard instantiateViewControllerWithIdentifier:@"EditNavViewController"];
    CREditNodeViewController *editViewController =(CREditNodeViewController *) [nextVC topViewController];
    editViewController.delegate = self;
    editViewController.node = node;
    
    [self presentViewController:nextVC animated:YES completion:nil];
}

- (void)addChildNodeToParentAtIndexPath:(NSIndexPath *)indexPath {
    [self.managedDocument.managedObjectContext.undoManager beginUndoGrouping];
    
    Node *parentNode = [self.fetchedResultsController objectAtIndexPath:indexPath];
    Node *node = [Node createNodeInManagedObjectContext:self.managedDocument.managedObjectContext withParent:parentNode];
    
    [self prepareViewControllerFromStoryBoardWithNewNode:node];
}

- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath {
    Node * node = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSManagedObjectContext *context = self.managedDocument.managedObjectContext;

    for (Node *childNode in node.childs) {
        [context deleteObject:childNode];
    }
    [context deleteObject:node];
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
    [self.managedDocument.managedObjectContext.undoManager beginUndoGrouping];
    if (!node) {
        Node *newNode = [Node createNodeInManagedObjectContext:self.managedDocument.managedObjectContext];
        editNodetViewController.node = newNode;
    } else {
        editNodetViewController.node = node;
    }
    editNodetViewController.delegate = self;
}


#pragma mark - TableView Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        CRNodeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NodeCellIdentifier forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
}

- (void)configureCell:(CRNodeTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Node * node = [self.fetchedResultsController objectAtIndexPath:indexPath];
    Node *parent = node.parent;
    if (parent) {
       cell.nodeTitleLabel.text = [NSString stringWithFormat:@"%@ Hijo de: %@", node.title, parent.title];
    }else {
        cell.nodeTitleLabel.text = node.title;
    }
    cell.rightUtilityButtons = [self rightButtons];
    cell.nodeTextLabel.text = node.text;
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
    [self.managedDocument.managedObjectContext.undoManager setActionName:@"Bad Action"];
    [self.managedDocument.managedObjectContext.undoManager endUndoGrouping];
    if (!modifiedData) {
        [self.managedDocument.managedObjectContext.undoManager undo];
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
        case 1:
            [self deleteItemAtIndexPath:cellIndexPath];
            break;
    }
}


#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        
        _fetchedResultsController = [[NSFetchedResultsController  alloc] initWithFetchRequest:[Node fetchAllNodesByTitle] managedObjectContext:self.managedDocument.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
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
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
            
        case NSFetchedResultsChangeUpdate:
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


@end
