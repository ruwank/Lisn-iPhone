//
//  SignUpViewController.m
//  Lisn
//
//  Created by A M S Sumanasooriya on 5/22/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "SignUpViewController.h"
#import "AppUtils.h"
#import "WebServiceURLs.h"
#import "WebServiceManager.h"
#import "Messages.h"
@interface SignUpViewController () <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *fNameField;
@property (weak, nonatomic) IBOutlet UITextField *lNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confPassField;

@end

@implementation SignUpViewController
- (IBAction)createAccButtonTapped:(id)sender {
    [self startCreateAccount];
}

- (IBAction)loginButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)keyboardHideTapped:(id)sender {
    [_fNameField resignFirstResponder];
    [_lNameField resignFirstResponder];
    [_emailField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_confPassField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startCreateAccount
{
    NSString *firstName = [AppUtils trimmedStringOfString:_fNameField.text];
    BOOL validFirstName = firstName.length > 0;
    
    NSString *email = [AppUtils trimmedStringOfString:_emailField.text];
    BOOL validEmail = email.length > 0;
    validEmail = [AppUtils isValidEmail:email];
    
    NSString *password = [AppUtils trimmedStringOfString:_passwordField.text];
    BOOL validPassword = password.length > 4;
    
    NSString *confPassword = [AppUtils trimmedStringOfString:_confPassField.text];
    BOOL passwordMatched = validPassword && [password isEqualToString:confPassword];
    
    if (validFirstName && validEmail && validPassword && passwordMatched) {
        [self sendCreateAccountRequest];
    }else if (!validFirstName) {
        [[[UIAlertView alloc] initWithTitle:@"Invalid First name." message:@"Please enter a valid name." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }else if (!validEmail) {
        [[[UIAlertView alloc] initWithTitle:@"Invalid Email." message:@"Please enter a valid email." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }else if (!validPassword) {
        [[[UIAlertView alloc] initWithTitle:@"Invalid Password." message:@"Please enter a valid Password. Password must contains more than 4 characters." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }else if (!passwordMatched) {
        [[[UIAlertView alloc] initWithTitle:@"Password mismatch." message:@"Both password should be matched." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

- (void)sendCreateAccountRequest
{
    NSString *firstName = [AppUtils trimmedStringOfString:_fNameField.text];
    NSString *lastName = [AppUtils trimmedStringOfString:_lNameField.text];
    NSString *email = [AppUtils trimmedStringOfString:_emailField.text];
    NSString *password = [AppUtils trimmedStringOfString:_passwordField.text];
    

    NSString *deviceId=[AppUtils getDeviceId];
    
    NSDictionary *params = @ {@"fname": firstName, @"lname": lastName, @"email" :email ,@"password":password,@"usertype":@"email",@"os":@"iPhone",@"device":deviceId ,@"username":@"NULL" ,@"fbname":@"NULL" ,@"loc":@"NULL", @"bday":@"NULL" ,@"mobile":@"NULL" ,@"age":@"NULL" ,@"pref":@"NULL" ,@"fbid":@"NULL" ,@"mname":@"NULL" ,@"fburl":@"NULL"};
    [WebServiceManager createUserAcoount:params withResponseHandler:^(BOOL success, NSString *statusText, ErrorType errorType){
        
        if(success){
            [[[UIAlertView alloc] initWithTitle:USER_EMAIL_SIGNUP_SUCCESS_TITLE message:USER_EMAIL_SIGNUP_SUCCESS_MESSAGE delegate:nil cancelButtonTitle:BUTTON_OK otherButtonTitles:nil] show];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            [[[UIAlertView alloc] initWithTitle:SERVER_ERROR_TITLE message:SERVER_ERROR_MESSAGE delegate:nil cancelButtonTitle:BUTTON_OK otherButtonTitles:nil] show];
        }
         }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    if ([textField isEqual:_fNameField]) {
        [_lNameField becomeFirstResponder];
    }else if ([textField isEqual:_lNameField]) {
        [_emailField becomeFirstResponder];
    }else if ([textField isEqual:_emailField]) {
        [_passwordField becomeFirstResponder];
    }else if ([textField isEqual:_passwordField]) {
        [_confPassField becomeFirstResponder];
    }else if ([textField isEqual:_confPassField]) {
        
    }
    
    return YES;
}

@end
