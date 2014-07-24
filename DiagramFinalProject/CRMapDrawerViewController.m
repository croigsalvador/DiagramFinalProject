//
//  CRMapDrawerViewController.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 20/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRMapDrawerViewController.h"
#import "CRColoursView.h"
//#import "CRCustomFigureView.h"
#import "CRSquareMapView.h"
#import "CRFiguresView.h"
#import "CRMap.h"
#import "CRManagedDocument.h"

#import "CRNodeMap.h"
#import "Node+Model.h"

static CGSize kScrollViewContainerSize                  = {5000.0f, 3333.0f};

@interface CRMapDrawerViewController ()<ColorViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate, CRFigureDrawerDelegate, FigureViewDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet CRColoursView *colorsView;
@property (nonatomic, assign) CGPoint currentTouch;
@property (nonatomic, strong) CRFigureDrawerFactory *selectedView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (copy,nonatomic) NSArray *nodeList;

@property (strong,nonatomic) UIView *containerView;
@property (strong,nonatomic) Node *lastNodeInserted;

@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (copy, nonatomic ) NSMutableArray *deleteIndexs;
@property (copy, nonatomic ) NSMutableArray *deletedNodes;
@property (assign,nonatomic, getter = isDeleting) BOOL deleting;
@end

@implementation CRMapDrawerViewController

#pragma mark - ViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.colorsView.delegate = self;
    [self setupScrollView];
    [self setupContainerView];
    [self setupCurrentMap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Set up the minimum & maximum zoom scales
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = 1.0f;
    self.scrollView.zoomScale = minScale * 1.3f;
    
    [self centerScrollViewContents];
    self.fetchedResultsController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.scrollView.contentSize = kScrollViewContainerSize;
    self.fetchedResultsController.delegate = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setGradient];
}

#pragma mark - Custom Getters

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

#pragma mark - Setting up UIElements

- (void) setGradient {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = @[(id)[UIColor grayCustomForGradient2].CGColor, (id)[UIColor grayCustomForGradient1].CGColor,(id)[UIColor grayCustomForGradient2].CGColor];
    [self.view.layer insertSublayer:gradient atIndex:0];
}

- (void)setupContainerView {
    self.containerView = [[UIView alloc] initWithFrame:(CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=kScrollViewContainerSize}];
    self.containerView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.containerView addGestureRecognizer:tapGesture];
    
    [self.scrollView addSubview:self.containerView];
}

- (void)setupScrollView {
    self.scrollView.contentSize = kScrollViewContainerSize;
}

- (void)setupCurrentMap {
    NSArray *listOfNodes = [Node fetchAllNodesFromContext:self.managedDocument.managedObjectContext];
    for (Node *node in listOfNodes){
        [self createFigure:node];
    }
}

#pragma mark - Resizing

- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.containerView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    self.containerView.frame = contentsFrame;
}

#pragma mark - UI Methods

- (void)addGesturesToNewView:(CRFigureDrawerFactory *)newView {
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handlePinchGesture:)];
    [pinchGesture setDelegate:self];
    [newView addGestureRecognizer:pinchGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [newView addGestureRecognizer:panGesture];
}

- (void)lightSelectedView {
    self.selectedView.alpha = 1.0;
}

- (void)unLightSelectedView {
    self.selectedView.alpha = 0.6;
    self.selectedView = nil;
}

- (void)createFigure:(Node *)node {
    [self.containerView addSubview:[self createViewWithFigure:node]];
}

- (CRFigureDrawerFactory *)createViewWithFigure:(Node *)node {
    CGRect figureFrame = CGRectMake([node.xPosition floatValue], [node.yPosition floatValue],[node.width floatValue],[node.height floatValue]);
    CRFigureDrawerFactory *figureView = [[CRFigureDrawerFactory alloc] initWithFrame:figureFrame andNode:node];
    figureView.delegate = self;
    figureView.alpha = 0.6;
    [self addGesturesToNewView:figureView];
    return figureView;
}

#pragma mark - Private Model Methods
- (void)addNewNodeFromList:(Node *)node {
    self.lastNodeInserted = node;
    [self createFigure:node];
}

- (void)removeFigure {
    Node *node = self.selectedView.node;
    [self.managedDocument.managedObjectContext deleteObject:node];
    [self unLightSelectedView];
}

- (void)updateNode:(Node *)node frame:(CGRect)nodeFrame {
    node.width =   @(nodeFrame.size.width);
    node.height = @(nodeFrame.size.height);
    node.xPosition = @(nodeFrame.origin.x);
    node.yPosition = @(nodeFrame.origin.y);
}

- (void)updateNode:(Node *)node colorText:(NSString *)color{
    node.color = color;
    self.selectedView.node = node;
}

- (void)createNewNodeForParent:(Node *)parentNode andShapeType:(NSUInteger)shapeType {
    Node *node = [Node createNodeInManagedObjectContext:self.managedDocument.managedObjectContext withParent:parentNode];
    node.shapeType = @(shapeType);
    [self insertNewNode:node];
    [self.managedDocument updateChangeCount:UIDocumentChangeDone];
}

- (void)insertNewNode:(Node *)node {
    if (![node isEqual:self.lastNodeInserted]) {
        self.lastNodeInserted = node;
        CRMap *map = [[CRMap alloc] initWithManagedObjectContext:node.managedObjectContext];
        [map calculateNewNodePositionFromParent:node withCompletionBlock:^(CGRect frame) {
            node.xPosition = @(frame.origin.x) ;
            node.yPosition = @(frame.origin.y) ;
        }];
        NSIndexPath * myIndexPath = [self.nodeMap indexPathNewForNode:node];
        [self.nodeMap addChild:node atIndex:myIndexPath.row];
        //    self.nodeList = self.nodeMap.mapList;
        [self addNewNodeFromList:node];
    }
}

- (void)removeNodes {
    [self.nodeMap deleteNodesAtIndex:[self.deleteIndexs copy]];
    self.deleting = NO;
    self.deleteIndexs = nil;
    self.nodeList = self.nodeMap.mapList;
    [self removeFiguresWithOutNode:self.deletedNodes];
}

-  (void)removeFiguresWithOutNode:(NSArray *)deletingNodes {
    NSArray *viewsArray = [self.containerView subviews];
    for (CRFigureDrawerFactory *view in viewsArray) {
        for (int i = 0; i < [deletingNodes count]; i++) {
            if ( [view.node isEqual:deletingNodes[i]]) {
                [view removeFromSuperview];
            }
        }
    }
    self.deletedNodes = nil;
}

#pragma mark - Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.containerView endEditing:YES];
}

#pragma mark - Gesture Methods

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer {
    
    static float initialDifference = 0.0;
    static float oldScale = 1.0;
    
    if (recognizer.state == UIGestureRecognizerStateBegan){
        initialDifference = oldScale - recognizer.scale;
    }
    
    CGFloat scale = oldScale - (oldScale - recognizer.scale) + initialDifference;
    self.selectedView.transform = CGAffineTransformScale(self.view.transform, scale, scale);
    [self updateNode:self.selectedView.node frame:self.selectedView.frame];
    
    oldScale = scale;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    CGPoint center;
    switch (recognizer.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan:
            [self unLightSelectedView];
            self.selectedView = (CRFigureDrawerFactory *)recognizer.view;
            [self lightSelectedView];
            break;
        case UIGestureRecognizerStateChanged:
            center = [recognizer locationInView:self.containerView];
            self.selectedView.center = center;
            break;
        case UIGestureRecognizerStateEnded:
            [self updateNode:self.selectedView.node frame:self.selectedView.frame];
            break;
        case UIGestureRecognizerStateCancelled:
            break;
        case UIGestureRecognizerStateFailed:
            break;
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *) recognizer {
    [self.view endEditing:YES];
    [self unLightSelectedView];
}

#pragma mark - Delegate Methods
#pragma mark - UIScrollViewDelegate

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that we want to zoom
    return self.containerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so we need to re-center the contents
    [self centerScrollViewContents];
}

#pragma mark - Figure Delegate Methods

- (void)changeSelectedView:(CRFigureDrawerFactory *)view {
    if (self.selectedView != view) {
        [self unLightSelectedView];
        self.selectedView = view;
        //        [self addLineBetweenSelectedAndNewView:view];
        [self lightSelectedView];
    }
}

#pragma mark - ColorView Delegate

- (void)sendInView:(CRColoursView *)colorView selectedColor:(NSString *)color {
    [self updateNode:self.selectedView.node colorText:color];
}

#pragma mark - Figures Delegate
- (void)sendTappedView:(CRFigureDrawerFactory *)selectedView withTag:(NSUInteger)tag {
    [self createNewNodeForParent:self.selectedView.node andShapeType:tag];
}

- (void)deleteButtonPressed:(CRFiguresView *)figureDrawer {
    if (!self.selectedView) {
        NSString *message = @"No hay ningún elemento seleccionado";
        [self showAlertErrorWithTitle:@"Error" message:message andCancelTitle:@"Aceptar"];
    } else {
        [self  removeFigure];
    }
}

- (void)writeButtonPressed:(CRFiguresView *)figureDrawer {
    NSLog(@"Typing");
}

#pragma mark - FetchedResultsController Methods

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        _fetchedResultsController = [[NSFetchedResultsController  alloc] initWithFetchRequest:[Node fetchAllNodes] managedObjectContext:self.managedDocument.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultsController.delegate = self;
        if (![_fetchedResultsController performFetch:nil]){
        }
    }
    return _fetchedResultsController;
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    switch(type) {
        case NSFetchedResultsChangeInsert:{
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
}

@end
