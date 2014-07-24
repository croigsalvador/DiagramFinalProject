//
//  CRMapListViewController.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 20/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#pragma mark - Controller imports
#import "CRMapListViewController.h"
#import "CRMapParentViewController.h"

#pragma mark - View imports
#import "CRDocumentNameView.h"

#pragma mark - Collection imports
#import "CRMapCollectionViewCell.h"
#import "CRMapCollectionFlowLayout.h"

#pragma mark - Model imports
#import "CRNodeMap.h"
#import "CRMapList.h"

#import "CRManagedDocument.h"
#import "UIFont+Common.h"

static NSString * const kFilePathComponent                = @"sqlite";
static NSString * const kMainStoryBoardNameID             = @"Main";
static NSString * const kMapParentViewControllerID        = @"MapParentViewController";
static UIEdgeInsets const kCollectionInsets               = {100.0, 0.0 , 0.0 ,0.0};
static UIEdgeInsets kFlowLayoutInsets                     = {30.0, 127.0, 70.0, 127.0};

static CGPoint const kDocumentViewPoint                   = {212.0f, 100.0f};
static CGSize const kDocumentViewSize                     = {600.0f, 200.0f};


@interface CRMapListViewController ()<DocumentNameViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *mapTitle;
@property (copy, nonatomic) NSArray *mapListArray;
@property (strong,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) CRMapList *mapList;
@property (strong,nonatomic) CRDocumentNameView *documentNameView;
@property (assign,nonatomic, getter = isShowed) BOOL showed;
@end

@implementation CRMapListViewController

#pragma mark - ViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapListArray = [self.mapList mapList];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Colección" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.mapTitle.font = [UIFont montSerratBoldForCollectionTitle];
    [self setupCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setGradient];
    [self.view addSubview:self.documentNameView];
    

}

#pragma mark - Custom Getters

- (CRMapList *)mapList {
    if (!_mapList) {
        _mapList = [[CRMapList alloc] init];
    }
    return _mapList;
}

- (CRDocumentNameView *)documentNameView {
    if (!_documentNameView) {
        _documentNameView = [[CRDocumentNameView alloc] initWithFrame:CGRectMake(212, -200 , 600, 200)];
        _documentNameView.delegate = self;
        _documentNameView.hidden = YES;
    }
    return _documentNameView;
}

#pragma mark - UIElements Setup

- (void) setGradient {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = @[(id)[UIColor flatSilverColor].CGColor, (id)[UIColor flatCloudsColor].CGColor,(id)[UIColor flatSilverColor].CGColor];
    [self.view.layer insertSublayer:gradient atIndex:0];
}

- (void)setupCollectionView {
    CGRect collectionFrame = UIEdgeInsetsInsetRect(self.view.frame, kCollectionInsets);
    NSLog(@"View Frame %@", NSStringFromCGRect(collectionFrame));

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(250,180);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

    flowLayout.sectionInset = kFlowLayoutInsets;
    self.collectionView = [[UICollectionView alloc]initWithFrame:collectionFrame collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
     self.collectionView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[CRMapCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([CRMapCollectionViewCell class])];
    [self.view addSubview:self.collectionView];
}

#pragma mark - CollectionView Delegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self setupNextViewControllerWithName:self.mapListArray[indexPath.row]];
}

#pragma mark - CollectionView Datasource Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.mapListArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CRMapCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CRMapCollectionViewCell class]) forIndexPath:indexPath];
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configCell:(CRMapCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSArray *colorArray = [UIColor flatColorsArray];
    NSUInteger index = indexPath.row;
    NSUInteger colorIndex = index%10;
    cell.backgroundColor = [UIColor colorFromText:colorArray[colorIndex]];
    
    cell.cellText = self.mapListArray[indexPath.row];
}

#pragma mark - Private Methods 

- (void)createManagedDocumentAndLaunchNextControllerWithName:(NSString *)name {
    if (name) {
        [self.mapList addMapToPlist:name];
        self.mapListArray = self.mapList.mapList;
        [self.collectionView reloadData];
        [self setupNextViewControllerWithName:name];
    }
    self.documentNameView.hidden = YES;
}

- (void)setupNextViewControllerWithName:(NSString *)name {
    CRManagedDocument *managedDocument = [self setupManagedDocumentWithName:name];
    CRNodeMap *nodeMap = [[CRNodeMap alloc] init];
    
    UIStoryboard *mapStoryboard = [UIStoryboard storyboardWithName:kMainStoryBoardNameID bundle:[NSBundle mainBundle]];
    
    CRMapParentViewController *mapParentViewController =(CRMapParentViewController *)[mapStoryboard instantiateViewControllerWithIdentifier:kMapParentViewControllerID];
    mapParentViewController.managedDocument = managedDocument;
    mapParentViewController.nodeMap = nodeMap;
//    [self presentViewController:mapParentViewController animated:YES completion:nil];
    [self.navigationController pushViewController:mapParentViewController animated:YES];
}

#pragma mark - IBAction Methods

- (IBAction)addNewDocument:(UIButton *)sender {
    if (self.documentNameView.hidden) {
        self.documentNameView.hidden = NO;
        [self animatePopUpDisplay];
    }
}

- (void)animatePopUpDisplay {
    [UIView animateWithDuration:.4 animations:^{
        CGRect popFrmae = CGRectMake(kDocumentViewPoint.x, kDocumentViewPoint.y, kDocumentViewSize.width, kDocumentViewSize.height);
        self.documentNameView.frame = popFrmae;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - DocumentNameView Delegate Methods

- (void)buttonPressedInDocument:(CRDocumentNameView *)documentNameView withTag:(NSUInteger)tag andText:(NSString *)name{
  CGRect frame = CGRectMake(kDocumentViewPoint.x, -kDocumentViewSize.height, kDocumentViewSize.width, kDocumentViewSize.height);
    self.documentNameView.frame = frame;
    switch (tag) {
        case 1:
            self.documentNameView.hidden = YES;
            break;
        case 2:
            if (name || ![name isEqualToString:@""]) {
                [self createManagedDocumentAndLaunchNextControllerWithName:name];
            }
            break;
    }
}

#pragma mark - Initialize UIManagedDocument

- (CRManagedDocument *)setupManagedDocumentWithName:(NSString *)fileName {
    NSURL *fileURL =[self urlForUIManagedDocumentWithName:fileName];
    
    CRManagedDocument *managedDocument = [[CRManagedDocument alloc] initWithFileURL:fileURL];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[fileURL path]]) {
        [managedDocument openWithCompletionHandler:^(BOOL success) {
            if (!success) {
                NSLog(@"No se pudo abrir aq%@", managedDocument);
            } else {
                 NSLog(@"No se pudo abrir aq%@", managedDocument);
            }
        }];
    } else {
        [managedDocument saveToURL:fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"Success");
            }
            NSLog(@"No se pudo abrir %@", managedDocument);
        }];
    }
    return managedDocument;
}

#pragma mark - Document Path

- (NSURL *)urlForUIManagedDocumentWithName:(NSString *)fileName {
    
    NSArray *paths = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsURL = [paths lastObject];
    NSURL *fileURL = [documentsURL URLByAppendingPathComponent:fileName];
    return fileURL;
}

#pragma mark - Touches Method

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


@end
