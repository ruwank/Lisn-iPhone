//
//  PurchaseViewController.m
//  Lisn
//
//  Created by Rasika Kumara on 7/2/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "PurchaseViewController.h"
#import "WebServiceURLs.h"

@interface PurchaseViewController ()<UIWebViewDelegate>{
    NSURLConnection *_urlConnection;
    NSURLRequest *_request;
    BOOL authenticated;
}
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (strong,nonatomic) NSString *urlAddress;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation PurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webview.delegate=self;
    NSURL *url = [NSURL URLWithString:_urlAddress];
    
    //URL Requst Object
    _request = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [_webview loadRequest:_request];
    [_activityIndicator startAnimating];
    // Do any additional setup after loading the view.
}
-(void)loadUrl:(NSString*)urlAddress{
    //Create a URL object.
    self.urlAddress=urlAddress;
   
}
-(void)paymentCompleted:(PaymentStatus)status{
    if(_delegate){
        [_delegate purchaseComplete:status];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
   // [self removeLoadingView];
    NSLog(@"finish");
    [_activityIndicator stopAnimating];

}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [_activityIndicator stopAnimating];
    NSLog(@"Error for WEBVIEW: %@", [error description]);
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"Did start loading: %@ auth:%d", [[request URL] absoluteString], authenticated);
    NSString *urlString=[[request URL] absoluteString];
    if (!authenticated) {
        authenticated = NO;
        
        _urlConnection = [[NSURLConnection alloc] initWithRequest:_request delegate:self];
        
        [_urlConnection start];
        
        return NO;
    }else{
        if([urlString isEqualToString:purchase_success_url] || [urlString isEqualToString:purchase_success_url_http]){
            [self paymentCompleted:RESULT_SUCCESS];
            return NO;
        }
        else if([urlString isEqualToString:purchase_failed_url] || [urlString isEqualToString:purchase_failed_url_http]){
            [self paymentCompleted:RESULT_ERROR];

            return NO;
        }
        else if([urlString isEqualToString:purchase_already_url] || [urlString isEqualToString:purchase_already_url_http]){
            [self paymentCompleted:RESULT_SUCCESS_ALREADY];

            return NO;
        }
        
    }

    return YES;
}
#pragma mark - NURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
{
    NSLog(@"WebController Got auth challange via NSURLConnection");
    
    if ([challenge previousFailureCount] == 0)
    {
        authenticated = YES;
        
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
        
    } else
    {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    NSLog(@"WebController received response via NSURLConnection");
    
    // remake a webview call now that authentication has passed ok.
    authenticated = YES;
    [_webview loadRequest:_request];
    
    // Cancel the URL connection otherwise we double up (webview + url connection, same url = no good!)
    [_urlConnection cancel];
}

// We use this method is to accept an untrusted site which unfortunately we need to do, as our PVM servers are self signed.
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
