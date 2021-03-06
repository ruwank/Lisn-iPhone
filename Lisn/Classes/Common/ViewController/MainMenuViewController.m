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
#import "MyBooksViewController.h"
#import "AppUtils.h"
#import "AudioPlayer.h"

@interface MainMenuViewController ()<UITabBarControllerDelegate,LoginViewControllerDelegate>{
    int selectedTab;
}

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
    //if ([viewController class] == [PlayerViewController class]) {
    if(viewController == [tabBarController.viewControllers objectAtIndex:2]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        if([[DataSource sharedInstance] isUserLogin]){
            NSMutableDictionary *userBook=[[DataSource sharedInstance] getUserBook];
            NSArray *uesrBook = [userBook allValues];
            
            if([uesrBook count]>0){
                if([AudioPlayer getSharedInstance].isPlaying){
                    PlayerViewController * playerViewController = [storyboard instantiateViewControllerWithIdentifier:@"PlayerViewControllerId"];
                    [tabBarController presentViewController:playerViewController animated:YES completion:nil];
                    
                }else{
                    PlayerViewController * playerViewController = [storyboard instantiateViewControllerWithIdentifier:@"PlayerViewControllerId"];
                    
                    NSString *lastPlayBookId= [AppUtils appDelegate].lastPlayBookId;
                    if(lastPlayBookId){
                        AudioBook *lastPlayAudioBook = [userBook objectForKey:lastPlayBookId];
                        if(lastPlayAudioBook){
                            [playerViewController setAudioBook:lastPlayBookId andFileIndex:lastPlayAudioBook.lastPlayChapterIndex];
                            [tabBarController presentViewController:playerViewController animated:YES completion:nil];
                        }else{
                            [[[UIAlertView alloc] initWithTitle:@"" message:@"No book playing" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                        }
                        
                        
                    }
                }
            }else{
                [self showMybookEmptyMessage];
            }
        }else{
            selectedTab=2;
            LoginViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewControllerId"];
            viewController.delegate = self;
            [tabBarController presentViewController:viewController animated:YES completion:nil];
        }
        //[tabBarController presentModalViewController:navController animated:YES];
        return NO;
    }
    else if (viewController == [tabBarController.viewControllers objectAtIndex:3] )
    {
        if(![[DataSource sharedInstance] isUserLogin]){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            selectedTab=3;
            LoginViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewControllerId"];
            viewController.delegate = self;
            [tabBarController presentViewController:viewController animated:YES completion:nil];
            return NO;
        }else{
            return YES;
        }
        
    }
    else {
        return YES;
    }
}

#pragma mark - LoginViewControllerDelegate

- (void)loginSucceeded {
    
    if(selectedTab==2){
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
    else if(selectedTab==3){
        self.selectedIndex=3;
    }
    
    
}

- (void)loginCancelled {
    
}
-(void)showMybookEmptyMessage{
    [[[UIAlertView alloc] initWithTitle:@"" message:@"First download book from store" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
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
