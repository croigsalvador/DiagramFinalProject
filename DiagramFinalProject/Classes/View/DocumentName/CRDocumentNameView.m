//
//  CRDocumentNameView.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 20/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRDocumentNameView.h"
#import "UIFont+Common.h"

static CGFloat const kMarginLeft                            = 30.0f;
static CGFloat const kTextFieldHeight                       = 40.0f;
static CGSize  const kButtonSize                            = { 100.0f, 40.0f };

static NSString * const kNameString                         = @"Nombre:";
static NSString * const kCancelButtonName                   = @"Cancelar";
static NSString * const kAcceptButtonName                   = @"Aceptar";

@interface CRDocumentNameView ()
@property (strong,nonatomic) UITextField *nameTextField;
@end

@implementation CRDocumentNameView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayCustomForGradient1];
        [self setupNameTextField];
        [self setupButtons];
    }
    return self;
}

- (void)setupNameTextField {
    
    CGRect labelFrame = CGRectMake(kMarginLeft, kMarginLeft, 130, 30);
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:labelFrame];
    titleLbl.textColor = [UIColor darkGrayCustom];
    titleLbl.font =  [UIFont montSerratBoldForCollectionCell];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.text = kNameString;
    [self addSubview:titleLbl];
    
    CGRect textFieldFrame = labelFrame;
    textFieldFrame.origin.x = CGRectGetMaxX(labelFrame) + 10.0;
    textFieldFrame.size.width = self.frame.size.width - (2 * kMarginLeft) - CGRectGetMaxX(labelFrame);
    textFieldFrame.size.height = kTextFieldHeight;
    
    self.nameTextField = [[UITextField alloc] initWithFrame:textFieldFrame];
    self.nameTextField.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.nameTextField];
}

- (void)setupButtons {
    CGRect buttonFrame =  {
        .origin.x = self.frame.size.width/1.8,
        .origin.y = CGRectGetMaxY(self.nameTextField.frame) + 80,
        .size.width = kButtonSize.width ,
        .size.height = kButtonSize.height
    };
    
    UIButton *acceptButton = [[UIButton alloc] initWithFrame:buttonFrame];
    acceptButton.tag = 2;
    [acceptButton setTitle:kAcceptButtonName forState:UIControlStateNormal];
    [acceptButton setBackgroundColor:[UIColor darkGrayCustom]];
    [acceptButton addTarget:self action:@selector(pressedButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:acceptButton];
    
    buttonFrame.origin.x = CGRectGetMaxX(buttonFrame) + 10;
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:buttonFrame];
    [cancelButton setTitle:kCancelButtonName forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor darkGrayCustom]];
    [cancelButton addTarget:self action:@selector(pressedButton:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.tag = 1;
    [self addSubview:cancelButton];
}

- (void)pressedButton:(UIButton *)sender {
    [self.nameTextField resignFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(buttonPressedInDocument:withTag:andText:)]) {
        [self.delegate buttonPressedInDocument:self withTag:sender.tag andText:self.nameTextField.text];
    }
    self.nameTextField.text = @"";
}

@end
