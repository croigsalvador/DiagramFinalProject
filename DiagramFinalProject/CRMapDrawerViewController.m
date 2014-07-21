//
//  CRMapDrawerViewController.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 20/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRMapDrawerViewController.h"
#import "CRColoursView.h"
#import "CRSquareFigureView.h"

#import "CRNodeMap.h"
#import "Node+Model.h"

static CGSize kScrollViewContainerSize                  = {2024.0f, 2024.0f};

@interface CRMapDrawerViewController ()<ColorViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate, CRCustomViewDelegate>
@property (weak, nonatomic) IBOutlet CRColoursView *colorsView;
@property (nonatomic, assign) CGPoint currentTouch;
@property (nonatomic, strong) UIView *selectedView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong,nonatomic) UIView *containerView;
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
    self.scrollView.zoomScale = minScale;
    
    [self centerScrollViewContents];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.scrollView = nil;
    self.containerView = nil;
}

#pragma mark - Setting up UIElements
- (void)setupContainerView {
    self.containerView = [[UIView alloc] initWithFrame:(CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=kScrollViewContainerSize}];
    self.containerView.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.containerView addGestureRecognizer:tapGesture];
    
    [self.scrollView addSubview:self.containerView];
}

- (void)setupScrollView {
    self.scrollView.contentSize = kScrollViewContainerSize;
}

- (void)setupCurrentMap {
    NSArray *allNodes = [Node fetchAllNodesFromContext:self.managedDocument.managedObjectContext];
    for (Node *node in allNodes){
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

#pragma mark - Private Methods

- (void)addGesturesToSelectedView {
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handlePinchGesture:)];
    [pinchGesture setDelegate:self];
    [self.selectedView addGestureRecognizer:pinchGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.selectedView addGestureRecognizer:panGesture];
}

- (void)lightSelectedView {
    self.selectedView.alpha = 0.6;
}

- (void)unLightSelectedView {
    self.selectedView.alpha = 1.0;
}

- (void)createFigure:(Node *)node {
    
    [self unLightSelectedView];
    self.selectedView = [self createViewWithFigure:node];
    [self.containerView addSubview:self.selectedView];
    [self addGesturesToSelectedView];
    [self lightSelectedView];
}

- (UIView *)createViewWithFigure:(Node *)node {
    CGRect figureFrame = CGRectMake([node.xPosition floatValue], [node.yPosition floatValue],[node.width floatValue],[node.height floatValue]);
    CRCustomFigureView *figureView = [[CRSquareFigureView alloc] initWithFrame:figureFrame andColor:[UIColor blueColor]];
    figureView.backgroundColor = [UIColor redColor];
    figureView.titleText = node.title;
    figureView.delegate = self;
    return figureView;
}

//- (UITextView *)textViewForFigure:(CGSize)figureSize {
//    CGRect textFrame = CGRectMake(0, 0, figureSize.width, figureSize.height);
//    UITextView *figureTextView = [[UITextView alloc] initWithFrame:CGRectInset(textFrame, 10, 20)];
//    figureTextView.editable = YES;
//    figureTextView.backgroundColor = [UIColor whiteColor];
//    NSLog(@"TextView: %@", NSStringFromCGRect(figureTextView.frame));
//    return figureTextView;
//}

//- (void)addLineBetweenSelectedAndNewView:(CRCustomFigureView *)figureView{
//    CAShapeLayer *line = [CAShapeLayer layer];
//    UIBezierPath *linePath=[UIBezierPath bezierPath];
//    [linePath moveToPoint: self.selectedView.center];
//    [linePath addLineToPoint:figureView.center];
//    line.path=linePath.CGPath;
//    line.fillColor = nil;
//    line.opacity = 1.0;
//    line.strokeColor = [UIColor redColor].CGColor;
//    [self.containerView.layer addSublayer:line];
//}

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
    oldScale = scale;
}


- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    CGPoint center;
    switch (recognizer.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan:
            [self unLightSelectedView];
            self.selectedView = recognizer.view;
            [self lightSelectedView];
            break;
        case UIGestureRecognizerStateChanged:
            center = [recognizer locationInView:self.containerView];
            self.selectedView.center = center;
            break;
        case UIGestureRecognizerStateEnded:
            break;
        case UIGestureRecognizerStateCancelled:
            break;
        case UIGestureRecognizerStateFailed:
            break;
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *) recognizer {
    [self.view endEditing:YES];
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

- (void)changeSelectedView:(CRCustomFigureView *)view {
    if (self.selectedView != view) {
        [self unLightSelectedView];
        self.selectedView = view;
        //        [self addLineBetweenSelectedAndNewView:view];
        [self lightSelectedView];
    }
}


#pragma mark - ColorView Delegate

- (void)sendInView:(CRColoursView *)colorView selectedColor:(NSString *)color {
    NSLog(@"Color seleccionado: %@", color);
}

@end
