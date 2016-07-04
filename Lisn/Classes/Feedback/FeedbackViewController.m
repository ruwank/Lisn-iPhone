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
#import "WebServiceURLs.h"
#import "DataSource.h"
#import "Messages.h"

@interface FeedbackViewController () <UITextViewDelegate, UITextFieldDelegate>{
    UIActivityIndicatorView *activityIndicator;

}

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
        AFHTTPSessionManager *manager = [AppUtils getAFHTTPSessionManager];
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        
        responseSerializer.acceptableContentTypes = nil;
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [activityIndicator startAnimating];
        NSString *userid=@"0";
        if([[DataSource sharedInstance] isUserLogin]){
            UserProfile *userProfile=[[DataSource sharedInstance] getProfileInfo];
            userid=userProfile.userId;
        }
        NSDictionary *params = @ {@"userid" :userid,@"title" :message,
            @"message" :message};
        [manager POST:user_feedback_url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [activityIndicator stopAnimating];

            [self showMessage:FEEDBACK_PUBLISH_SUCCESS];
            }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error %@",error);
             [activityIndicator startAnimating];
             [self showMessage:@"Feedback publish failed try again later"];

        }];

    }
}

-(void)showMessage:(NSString*)message{
   // NSString *message = @"You are being registered.";
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil                                                            message:message
                                                                                                                delegate:nil                                                  cancelButtonTitle:nil                                                  otherButtonTitles:nil, nil];
    toast.backgroundColor=[UIColor redColor];
    [toast show];
    int duration = 2; // duration in seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
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
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    activityIndicator.center = self.view.center;
    [self.view addSubview:activityIndicator];
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
