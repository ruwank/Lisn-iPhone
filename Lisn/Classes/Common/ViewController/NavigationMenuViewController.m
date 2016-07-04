//
//  NavigationMenuViewController.m
//  Lisn
//
//  Created by Rasika Kumara on 3/25/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "NavigationMenuViewController.h"
#import "LoginViewController.h"
#import "DataSource.h"

@interface NavigationMenuViewController () <UITableViewDelegate, UITableViewDataSource, LoginViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NavigationMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([[DataSource sharedInstance] isUserLogin]){
        return 7;

    }else{
        return 6;

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"home";
    
    
    switch ( indexPath.row )
    {
        case 0:
            CellIdentifier = @"home";
            break;
            
        case 1:
            CellIdentifier = @"store";
            break;
            
        case 2:
            CellIdentifier = @"mybooks";
            break;
        case 3:
            CellIdentifier = @"feedback";
            break;
        case 4:
            CellIdentifier = @"aboutus";
            break;
        case 5:
            CellIdentifier = @"contactus";
            break;
        case 6:
            CellIdentifier = @"logout";
            break;
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if ([identifier isEqualToString:@"my_books_segue_id"]) {
        
        if (![[DataSource sharedInstance] isUserLogin]) {
            
            LoginViewController * viewController = [LoginViewController getInstance];
            viewController.delegate = self;
            [self presentViewController:viewController animated:YES completion:nil];

            return NO;
        }
    }else if([identifier isEqualToString:@"logout_segue_id"]){
        [[DataSource sharedInstance] logOutUser];
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

#pragma mark - LoginViewControllerDelegate

- (void)loginSucceeded {
    [self performSegueWithIdentifier:@"my_books_segue_id" sender:nil];
}

- (void)loginCancelled {
    [_tableView reloadData];
    [self performSegueWithIdentifier:@"home_segue_id" sender:nil];
}

@end
