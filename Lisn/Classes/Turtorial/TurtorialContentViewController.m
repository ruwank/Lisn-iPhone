//
//  TurtorialContentViewController.m
//  Lisn
//
//  Created by Rasika Kumara on 7/29/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "TurtorialContentViewController.h"

@interface TurtorialContentViewController ()

@end

@implementation TurtorialContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
