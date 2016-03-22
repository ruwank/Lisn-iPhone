//
//  MainViewController.m
//  PINKCampusRep
//
//  Created by IOT on 3/4/16.
//  Copyright © 2016 IronOneTech. All rights reserved.
//

#import "MainViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "AppConstant.h"
#import "AppUtils.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self downloadNewReleaseBookList];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)downloadNewReleaseBookList{
  
    AFHTTPSessionManager *manager = [AppUtils getAFHTTPSessionManager];
    
    [manager POST:home_book_list_url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responseObject != NULL){
            NSArray *dataArray=(NSArray*)responseObject;
            for (int i=0; i<[dataArray count]; i++) {
                NSDictionary *dataDic=(NSDictionary*)[dataArray objectAtIndex:i];
                NSLog(@"dataDic %@",dataDic);
            }
        }
        NSLog(@"class %@",[responseObject class]);
        NSLog(@"success! %@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
    }];
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
