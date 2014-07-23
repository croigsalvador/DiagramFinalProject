//
//  CREditNodeViewController.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 14/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CREditNodeViewController.h"
#import "Node+Model.h"

@interface CREditNodeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *nodeTextField;
@property (nonatomic, assign, getter = isModified) BOOL modified;
@property (nonatomic,copy) NSString *colorString;

@end

@implementation CREditNodeViewController

#pragma mark - ViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDefaultValues];
    self.view.backgroundColor = [UIColor flatCloudsColor];
    self.view.alpha = 0.8;
}

#pragma mark - Setup Methods

- (void)setupDefaultValues {
    self.titleTextField.text = self.node.title;
    self.nodeTextField.text = self.node.text;
}

#pragma mark - Private Methods

- (void)saveNodeProperties {
    self.modified = YES;
    [self.view endEditing:YES];
    self.node.title = self.titleTextField.text;
    self.node.text = self.nodeTextField.text;
    self.node.shapeType = CRNodeTypeShapeSquare;
}

#pragma mark - IBAction Methods

- (IBAction) cancel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(dismissEditNodeViewController:modifiedData:)]) {
        [self.delegate dismissEditNodeViewController:self modifiedData:NO];
    }
}

- (IBAction) save:(id)sender {
    if ([self.delegate respondsToSelector:@selector(dismissEditNodeViewController:modifiedData:)]) {
        [self saveNodeProperties];
        [self.delegate dismissEditNodeViewController:self modifiedData:YES];
    }
}

#pragma mark -
#pragma mark - Observer Method

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    Node *node = (Node *) object;
    if ([keyPath isEqualToString:kTitlePropertyName]) {
        self.titleTextField.text = node.title;
    } else if ([keyPath isEqualToString:kTextPropertyName]) {
        self.nodeTextField.text = node.text;
    }
}

#pragma mark - Touches Method

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}



@end
