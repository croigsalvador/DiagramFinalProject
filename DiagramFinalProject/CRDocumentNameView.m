//
//  CRDocumentNameView.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 20/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRDocumentNameView.h"

static CGFloat const kMarginLeft                            = 20.0f;
static CGFloat const kTextFieldHeight                       = 30.0f;
static CGSize  const kButtonSize                            = { 100.0f, 40.0f };

static NSString * const kNameString                         = @"Nombre";
static NSString * const kCancelButtonName                   = @"Cancelar";
static NSString * const kAcceptButtonName                   = @"Aceptar";

@interface CRDocumentNameView ()
@property (strong,nonatomic) UITextField *nameTextField;
@end

@implementation CRDocumentNameView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        [self setupNameTextField];
        [self setupButtons];
    }
    return self;
}

- (void)setupNameTextField {
    
    CGRect labelFrame = CGRectMake(kMarginLeft, kMarginLeft, 100, 20);
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:labelFrame];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.font =  [UIFont systemFontOfSize:16];
    titleLbl.backgroundColor = [UIColor blueColor];
    titleLbl.text = kNameString;
    [self addSubview:titleLbl];
    
    CGRect textFieldFrame = labelFrame;
    textFieldFrame.origin.x = CGRectGetMaxX(labelFrame) + 10.0;
    textFieldFrame.size.width = self.frame.size.width - (2 * kMarginLeft) - CGRectGetMaxX(labelFrame);
    textFieldFrame.size.height = kTextFieldHeight;
    
    self.nameTextField = [[UITextField alloc] initWithFrame:textFieldFrame];
    self.nameTextField.placeholder = kNameString;
    self.nameTextField.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.nameTextField];
}

- (void)setupButtons {
    CGRect buttonFrame =  {
        .origin.x = self.frame.size.width/2,
        .origin.y = CGRectGetMaxY(self.nameTextField.frame) + kMarginLeft,
        .size.width = kButtonSize.width ,
        .size.height = kButtonSize.height
    };
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:buttonFrame];
    [cancelButton setTitle:kCancelButtonName forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor flatAmethystColor]];
    [cancelButton addTarget:self action:@selector(pressedButton:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.tag = 1;
    [self addSubview:cancelButton];
    
    buttonFrame.origin.x = CGRectGetMaxX(buttonFrame) + 10;
    
    UIButton *acceptButton = [[UIButton alloc] initWithFrame:buttonFrame];
    acceptButton.tag = 2;
    [acceptButton setTitle:kCancelButtonName forState:UIControlStateNormal];
    [acceptButton setBackgroundColor:[UIColor flatAmethystColor]];
    [acceptButton addTarget:self action:@selector(pressedButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:acceptButton];
}

- (void)pressedButton:(UIButton *)sender {
    [self.nameTextField resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(buttonPressedInDocument:withTag:andText:)]) {
        [self.delegate buttonPressedInDocument:self withTag:sender.tag andText:self.nameTextField.text];
    }
}

@end
