//
//  PlayerViewController.m
//  Lisn
//
//  Created by A M S Sumanasooriya on 7/2/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "PlayerViewController.h"

@interface PlayerViewController ()

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLbl;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;


@end

@implementation PlayerViewController

- (IBAction)playButtonTapped:(id)sender {
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
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
