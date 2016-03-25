//
//  LisnBaseViewController.m
//  Lisn
//
//  Created by Rasika Kumara on 3/25/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "LisnBaseViewController.h"
#import "SWRevealViewController.h"

@interface LisnBaseViewController ()<SWRevealViewControllerDelegate>
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;


@end

@implementation LisnBaseViewController

- (void)navigationMenuSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.revealButtonItem setTarget: self.revealViewController];
        [self.revealButtonItem setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        revealViewController.delegate=self;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationMenuSetup];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    NSLog(@"revealController");
    if(position == FrontViewPositionLeft) {
        //self.view.userInteractionEnabled = YES;
        _sidebarMenuOpen = NO;
    } else {
        //self.view.userInteractionEnabled = NO;
        _sidebarMenuOpen = YES;
    }
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        //self.view.userInteractionEnabled = YES;
        _sidebarMenuOpen = NO;
    } else {
        //self.view.userInteractionEnabled = NO;
        _sidebarMenuOpen = YES;
    }
}
-(void)revealToggleAnimated{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [revealViewController revealToggleAnimated:YES];
    }
}

@end
