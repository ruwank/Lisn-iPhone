//
//  MainMenuViewController.m
//  Lisn
//
//  Created by Rasika Kumara on 7/8/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "MainMenuViewController.h"
#import "PlayerViewController.h"
#import "DataSource.h"
#import "LoginViewController.h"

@interface MainMenuViewController ()<UITabBarControllerDelegate,LoginViewControllerDelegate>

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate=self;
    /*
    UIImage *buttonImage = [UIImage imageNamed:@"btn_play_start"];
    UIImage *highlightImage = [UIImage imageNamed:@"btn_play_start"];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    [self.view addSubview:button];
     */
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController
shouldSelectViewController:(UIViewController *)viewController{
   // return YES;
    if ([viewController class] ==[PlayerViewController class]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

        if([[DataSource sharedInstance] isUserLogin]){
            NSMutableDictionary *userBook=[[DataSource sharedInstance] getUserBook];
            NSArray *uesrBook=[userBook allValues];
            
            if([uesrBook count]>0){
        PlayerViewController * playerViewController = [storyboard instantiateViewControllerWithIdentifier:@"PlayerViewControllerId"];
       // [viewController setAudioBook:_audioBook.book_id andFileIndex:chapterIndex];
        
        [tabBarController presentViewController:playerViewController animated:YES completion:nil];
            }else{
                [self showMybookEmptyMessage];

            }
        }else{
            LoginViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewControllerId"];
            viewController.delegate = self;
            [tabBarController presentViewController:viewController animated:YES completion:nil];
        }
        //[tabBarController presentModalViewController:navController animated:YES];
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - LoginViewControllerDelegate

- (void)loginSucceeded {
    
    NSMutableDictionary *userBook=[[DataSource sharedInstance] getUserBook];
    NSArray *uesrBook=[userBook allValues];
    
    if([uesrBook count]>0){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        PlayerViewController * playerViewController = [storyboard instantiateViewControllerWithIdentifier:@"PlayerViewControllerId"];
        // [viewController setAudioBook:_audioBook.book_id andFileIndex:chapterIndex];
        
        [self presentViewController:playerViewController animated:YES completion:nil];
    }else{
        [self showMybookEmptyMessage];
    }
    
}

- (void)loginCancelled {
    
}
-(void)showMybookEmptyMessage{
   [[[UIAlertView alloc] initWithTitle:@"" message:@"First download book from store" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
