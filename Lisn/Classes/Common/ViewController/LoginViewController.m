//
//  LoginViewController.m
//  Lisn
//
//  Created by A M S Sumanasooriya on 7/2/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "LoginViewController.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "AppUtils.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "WebServiceURLs.h"
#import "WebServiceManager.h"
#import "Messages.h"
#import "DataSource.h"

@interface LoginViewController () <UITextFieldDelegate, FBSDKLoginButtonDelegate>

@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *fbLoginButton;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPassBtn;
@property (weak, nonatomic) IBOutlet UIButton *createAccBtn;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UILabel *loadingText;

@end

@implementation LoginViewController

+ (LoginViewController *)getInstance
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewControllerId"];
    return viewController;
}

- (IBAction)cancelButtonTapped:(id)sender {
    if (_delegate) {
        [_delegate loginCancelled];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginButtonTapped:(id)sender {
    [self doLogin];
}

- (IBAction)forgotPasswordButtonTapped:(id)sender {
    
}

- (IBAction)createAccountButtonTapped:(id)sender {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _fbLoginButton.delegate = self;
    _fbLoginButton.readPermissions = @[@"public_profile", @"email"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doLogin
{
    NSString *email = [AppUtils trimmedStringOfString:_emailField.text];
    BOOL validEmail = email.length > 0;
    validEmail = [AppUtils isValidEmail:email];
    
    NSString *password = [AppUtils trimmedStringOfString:_passwordField.text];
    BOOL validPassword = password.length > 0;
    
    if (validEmail && validPassword) {
        [self sendLoginRequest];
    }else if (!validEmail) {
        [[[UIAlertView alloc] initWithTitle:@"Invalid Email." message:@"Please enter a valid email." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }else if (!validPassword) {
        [[[UIAlertView alloc] initWithTitle:@"Invalid Password." message:@"Please enter a valid Password." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

- (void)sendLoginRequest
{
    NSString *email = [AppUtils trimmedStringOfString:_emailField.text];
    NSString *password = [AppUtils trimmedStringOfString:_passwordField.text];
    
    //AFHTTPSessionManager *manager = [AppUtils getAFHTTPSessionManager];
    
    NSString *deviceId=[AppUtils getDeviceId];
    
    NSDictionary *params = @ {@"email" :email ,@"password":password,@"usertype":@"email",@"os":@"iPhone",@"device":deviceId};
    _loadingView.hidden=NO;

    [WebServiceManager loginUser:params withResponseHandeler:^(BOOL success, ErrorType errorType) {
        _loadingView.hidden=YES;

        if(success){
            [self userLoginCompleted:YES];
  
        }else{
            [self userLoginCompleted:NO];
 
        }
    }];
    
}

#pragma mark user login metods

- (void)createUserAccount:(NSDictionary*)jsonDic
{
    NSString *deviceId=[AppUtils getDeviceId];
    
    NSString *firstName=@"";
    NSString *lastName=@"";
    NSString *middle_name=@"";
    NSString *email=@"";
    NSString *fbid=@"";
    NSString *fburl=@"";
    
    if([jsonDic valueForKey:@"first_name"]!= nil)
        firstName = [jsonDic valueForKey:@"first_name"];
    if([jsonDic valueForKey:@"id"]!= nil)
        fbid = [jsonDic valueForKey:@"id"];
    if([jsonDic valueForKey:@"email"]!= nil)
        email = [jsonDic valueForKey:@"email"];
    if([jsonDic valueForKey:@"last_name"]!= nil)
        lastName = [jsonDic valueForKey:@"last_name"];
    if([jsonDic valueForKey:@"link"]!= nil)
        fburl = [jsonDic valueForKey:@"link"];
    if([jsonDic valueForKey:@"middle_name"]!= nil)
        middle_name = [jsonDic valueForKey:@"middle_name"];
    
    NSDictionary *params = @ {@"fname": firstName, @"lname": lastName ,@"mname":middle_name, @"email" :email ,@"password":@"NULL",@"usertype":@"fb",@"os":@"iPhone",@"device":deviceId ,@"username":@"NULL" ,@"fbname":@"NULL" ,@"loc":@"NULL", @"bday":@"NULL" ,@"mobile":@"NULL" ,@"age":@"NULL" ,@"pref":@"NULL" ,@"fbid":fbid  ,@"fburl":fburl};
    _loadingView.hidden=NO;

    [WebServiceManager createUserAcoount:params withResponseHandler:^(BOOL success, NSString *statusText, ErrorType errorType) {
        _loadingView.hidden=YES;

        if(success){
            [self userLoginCompleted:YES];
        }else{
            [[[UIAlertView alloc] initWithTitle:SERVER_ERROR_TITLE message:SERVER_ERROR_MESSAGE delegate:nil cancelButtonTitle:BUTTON_OK otherButtonTitles:nil] show];
            
        }
    }];
}

- (void)userLoginCompleted:(BOOL)status
{
    if(status){
        [self downloadUserBook];
    }else{
        [[[UIAlertView alloc] initWithTitle:SERVER_ERROR_TITLE message:SERVER_ERROR_MESSAGE delegate:nil cancelButtonTitle:BUTTON_OK otherButtonTitles:nil] show];
    }
}

- (void)downloadUserBook {
     _loadingView.hidden=NO;
    UserProfile *userProfile =  [[DataSource sharedInstance] getProfileInfo];
    
    NSDictionary *params = @ {@"userid" :userProfile.userId};
    
    AFHTTPSessionManager *manager = [AppUtils getAFHTTPSessionManager];
    
    [manager POST:user_book_list_url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        _loadingView.hidden=YES;
        if(responseObject != NULL && [responseObject isKindOfClass:[NSArray class]]){
            NSLog(@"responseObject %@",responseObject);
            NSMutableDictionary *userBook=[[NSMutableDictionary alloc] init];
            NSMutableArray *booksDataArray=(NSMutableArray*)responseObject;
            for (NSDictionary *dic in booksDataArray) {
                AudioBook *audioBook=[[AudioBook alloc] initWithDataDictionary:dic];
                
                [userBook setValue:audioBook forKey:audioBook.book_id];
            }
            [[DataSource sharedInstance] saveUserBook:userBook];
        }
        
        if (_delegate) {
            
            [_delegate loginSucceeded];
            [self dismissViewControllerAnimated:YES completion:nil];

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error);
         _loadingView.hidden=YES;
        if (_delegate) {
            [_delegate loginSucceeded];
            [self dismissViewControllerAnimated:YES completion:nil];

        }
    }];
}

#pragma mark - FBSDKLoginButtonDelegate

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if (result && result.grantedPermissions && [result.grantedPermissions containsObject:@"public_profile"] && [result.grantedPermissions containsObject:@"email"]) {
        
        if ([FBSDKAccessToken currentAccessToken]) {
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, email, birthday,middle_name"}]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result, NSError *error) {
                 if (!error) {
                     NSDictionary *userDic=(NSDictionary*)result;
                     NSLog(@"fetched userDic:%@", userDic);
                     [self createUserAccount:userDic];
                 }else {
                     [self userLoginCompleted:NO];
                 }
             }];
        }else {
            [self userLoginCompleted:NO];
        }
    }else if (result && result.declinedPermissions && [result.declinedPermissions containsObject:@"email"]) {
        [[FBSDKLoginManager new] logOut];
        [[[UIAlertView alloc] initWithTitle:@"Email not available." message:@"The email address is required for Lisn login process. Please allow it to continue login." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }else {
        [[[UIAlertView alloc] initWithTitle:@"Something went wrong." message:@"Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
}

- (BOOL)loginButtonWillLogin:(FBSDKLoginButton *)loginButton {
    return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    if ([textField isEqual:_emailField]) {
        [_passwordField becomeFirstResponder];
    }else if ([textField isEqual:_passwordField]) {
        [self doLogin];
    }
    
    return YES;
}

@end
