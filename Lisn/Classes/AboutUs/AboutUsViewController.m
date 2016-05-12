//
//  AboutUsViewController.m
//  Lisn
//
//  Created by Rasika Kumara on 3/25/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"aboutus" ofType:@"html"]];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
