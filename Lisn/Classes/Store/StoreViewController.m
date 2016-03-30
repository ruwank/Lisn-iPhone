//
//  StoreViewController.m
//  Lisn
//
//  Created by Rasika Kumara on 3/25/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "StoreViewController.h"
#import "TopTabsScrollView.h"
#import "AppConstant.h"

@interface StoreViewController ()

@property (weak, nonatomic) IBOutlet TopTabsScrollView *topTabScrollView;
@property (weak, nonatomic) IBOutlet UIView *tabSelect1;
@property (weak, nonatomic) IBOutlet UIView *tabSelect2;
@property (weak, nonatomic) IBOutlet UIView *tabSelect3;
@property (weak, nonatomic) IBOutlet UIView *tabSelect4;
@property (weak, nonatomic) IBOutlet UIView *tabSelect5;
@property (weak, nonatomic) IBOutlet UIView *tabSelect6;



@end

@implementation StoreViewController

- (IBAction)tabButtonTapped:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    _tabSelect1.backgroundColor = RGBA(238, 159, 31, 1);
    _tabSelect2.backgroundColor = RGBA(238, 159, 31, 1);
    _tabSelect3.backgroundColor = RGBA(238, 159, 31, 1);
    _tabSelect4.backgroundColor = RGBA(238, 159, 31, 1);
    _tabSelect5.backgroundColor = RGBA(238, 159, 31, 1);
    _tabSelect6.backgroundColor = RGBA(238, 159, 31, 1);
    
    switch (btn.tag) {
        case 1:
            _tabSelect1.backgroundColor = RGBA(255, 255, 255, 1);
            break;
        case 2:
            _tabSelect2.backgroundColor = RGBA(255, 255, 255, 1);
            break;
        case 3:
            _tabSelect3.backgroundColor = RGBA(255, 255, 255, 1);
            break;
        case 4:
            _tabSelect4.backgroundColor = RGBA(255, 255, 255, 1);
            break;
        case 5:
            _tabSelect5.backgroundColor = RGBA(255, 255, 255, 1);
            break;
        case 6:
            _tabSelect6.backgroundColor = RGBA(255, 255, 255, 1);
            break;
            
        default:
            break;
    }
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
