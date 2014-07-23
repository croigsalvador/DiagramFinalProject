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

static NSString * const kFilePathComponent                = @"sqlite";
static NSString * const kMainStoryBoardNameID             = @"Main";
static NSString * const kMapParentViewControllerID        = @"MapParentViewController";
static UIEdgeInsets const kCollectionInsets               = {100.0, 0.0 , 0.0 ,0.0};

@interface CRMapListViewController ()<DocumentNameViewDelegate>
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
    [self setupCollectionView];
    [self.view addSubview:self.documentNameView];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Colección" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
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
        _documentNameView = [[CRDocumentNameView alloc] initWithFrame:CGRectMake(312, 64, 400, 200)];
        _documentNameView.delegate = self;
        _documentNameView.hidden = YES;
    }
    return _documentNameView;
}

#pragma mark - UIElements Setup

- (void)setupCollectionView {
    CGRect collectionFrame = UIEdgeInsetsInsetRect(self.view.bounds, kCollectionInsets);
    CRMapCollectionFlowLayout *flowLayout = [[CRMapCollectionFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:collectionFrame collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.backgroundColor = [UIColor flatCloudsColor];
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
    
    cell.backgroundColor = [UIColor blueColor];
    return cell;
}

#pragma mark - Private Methods 

- (void)createManagedDocumentAndLaunchNextControllerWithName:(NSString *)name {
    if (name) {
        [self.mapList addMapToPlist:name];
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
    }
}

#pragma mark - DocumentNameView Delegate Methods

- (void)buttonPressedInDocument:(CRDocumentNameView *)documentNameView withTag:(NSUInteger)tag andText:(NSString *)name{
    switch (tag) {
        case 1:
            self.documentNameView.hidden = YES;
            break;
        case 2:
            [self createManagedDocumentAndLaunchNextControllerWithName:name];
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
    [self buttonPressedInDocument:nil withTag:1 andText:nil];
}


@end
