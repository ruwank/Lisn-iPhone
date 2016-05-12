//
//  FeedbackViewController.m
//  Lisn
//
//  Created by Rasika Kumara on 3/25/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "FeedbackViewController.h"
#import "AppConstant.h"
#import "AppUtils.h"

@interface FeedbackViewController () <UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *fieldBgView;
@property (weak, nonatomic) IBOutlet UITextField *subjectField;
@property (weak, nonatomic) IBOutlet UITextView *messageView;
@property (weak, nonatomic) IBOutlet UITextField *msgField;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;


@end

@implementation FeedbackViewController

- (IBAction)submitButtonTapped:(id)sender {
    NSString *subject = [AppUtils trimmedStringOfString:_subjectField.text];
    NSString *message = [AppUtils trimmedStringOfString:_messageView.text];
    
    if (message.length > 0 && subject.length > 0) {
        
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _fieldBgView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:159/255.0 blue:31/255.0 alpha:1.0].CGColor;
    _fieldBgView.layer.borderWidth = 1.5;
    
    _messageView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:159/255.0 blue:31/255.0 alpha:1.0].CGColor;
    _messageView.layer.borderWidth = 1.5;
    
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed)];
    
    [keyboardToolbar setItems:[NSArray arrayWithObjects:flexibleSpace, cancelButton, nil]];
    [_messageView setInputAccessoryView:keyboardToolbar];
}

- (void)doneButtonPressed
{
    [_messageView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _msgField.hidden = YES;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (textView.text == nil || textView.text.length == 0) {
        _msgField.hidden = NO;
    }
    return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];

    return YES;
}

@end
