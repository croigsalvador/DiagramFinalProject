//
//  CRAddNodeView.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 24/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRAddNodeView.h"
#import "UIFont+Common.h"

static CGFloat const kMarginLeft                            = 30.0f;
static CGFloat const kTextFieldHeight                       = 40.0f;
static CGSize  const kButtonSize                            = { 100.0f, 40.0f };

static NSString * const kNameString                         = @"Nombre:";
static NSString * const kCancelButtonName                   = @"Cancelar";
static NSString * const kAcceptButtonName                   = @"Añadir";

@interface CRAddNodeView ()
@property (strong,nonatomic) UITextField *nameTextField;
@property (strong,nonatomic) UITextField *subTitleTextField;
@end

@implementation CRAddNodeView

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
    
    labelFrame.origin.y = CGRectGetMaxY(labelFrame) + 20;
    UILabel *subTitleLbl = [[UILabel alloc] initWithFrame:labelFrame];
    subTitleLbl.textColor = [UIColor darkGrayCustom];
    subTitleLbl.font =  [UIFont montSerratBoldForCollectionCell];
    subTitleLbl.backgroundColor = [UIColor clearColor];
    subTitleLbl.text = kNameString;
    [self addSubview:subTitleLbl];
    
    textFieldFrame.origin.y = CGRectGetMaxY(textFieldFrame) + 20;
    textFieldFrame.size.width = self.frame.size.width - (2 * kMarginLeft) - CGRectGetMaxX(labelFrame);
    textFieldFrame.size.height = kTextFieldHeight;
    
    self.subTitleTextField = [[UITextField alloc] initWithFrame:textFieldFrame];
    self.subTitleTextField.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.subTitleTextField];
}

- (void)setupButtons {
    CGRect buttonFrame =  {
        .origin.x = self.frame.size.width/1.8,
        .origin.y = CGRectGetMaxY(self.nameTextField.frame) + 100,
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
    [self.subTitleTextField resignFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(buttonPressedInView:withTag:andText:)]) {
        [self.delegate buttonPressedInView:self withTag:sender.tag andText:self.nameTextField.text];
    }
    self.nameTextField.text = @"";
}

@end