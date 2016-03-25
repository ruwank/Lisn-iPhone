//
//  NavigationMenuViewController.m
//  Lisn
//
//  Created by Rasika Kumara on 3/25/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "NavigationMenuViewController.h"

@interface NavigationMenuViewController ()<UITableViewDelegate,UITableViewDataSource>

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
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
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    return cell;
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
