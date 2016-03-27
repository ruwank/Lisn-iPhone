//
//  MainViewController.m
//  PINKCampusRep
//
//  Created by IOT on 3/4/16.
//  Copyright © 2016 IronOneTech. All rights reserved.
//

#import "MainViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "WebServiceURLs.h"
#import "AppUtils.h"
#import "AppDelegate.h"
#import "BookCategory.h"

@interface MainViewController (){
    bool finishDelay,finishDownload;
    int downloadCount,finishCount;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(finishSplash:) withObject:nil afterDelay:3.0 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];

    [self downloadInitialData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark

-(void)loadHomeScreen{
    
    if(finishDelay && finishDownload){
        [self performSegueWithIdentifier:@"segue_main" sender:nil];
    }

}

-(void)finishSplash:(id)sender{
    finishDelay=TRUE;
    [self loadHomeScreen];

}
-(void)finishDownload{
    finishCount ++;
    if (downloadCount == finishCount) {
        finishDownload=TRUE;
        [_activityIndicator stopAnimating];

        [self loadHomeScreen];
    }
}
-(void)downloadInitialData{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

   // if ([appDelegate isNetworkRechable]) {
        finishDownload=FALSE;
        downloadCount=4;
        finishCount=0;
    
    AFHTTPSessionManager *manager = [AppUtils getAFHTTPSessionManager];
    
    [_activityIndicator startAnimating];
    
    [manager POST:book_category_list_url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responseObject != NULL && [responseObject isKindOfClass:[NSArray class]]){
            NSMutableArray *dataArray=(NSMutableArray*)responseObject;
            NSMutableArray *categoryArray=[[NSMutableArray alloc] init];
            for (int i=0; i<[dataArray count]; i++) {
                NSDictionary *dataDic=[dataArray objectAtIndex:i];
                BookCategory *bookCategory=[[BookCategory alloc] initWithDataDic:dataDic];
                [categoryArray addObject:bookCategory];
            }
            appDelegate.bookCategories=categoryArray;
            [self finishDownload];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self finishDownload];

    }];
    
    [manager POST:top_release_book_list_url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responseObject != NULL && [responseObject isKindOfClass:[NSArray class]]){
            NSMutableArray *dataArray=(NSMutableArray*)responseObject;
            appDelegate.topReleaseBookList=dataArray;
            [self finishDownload];

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self finishDownload];

    }];
    
    [manager POST:top_rated_book_list_url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responseObject != NULL && [responseObject isKindOfClass:[NSArray class]]){
            NSMutableArray *dataArray=(NSMutableArray*)responseObject;
            appDelegate.topRatedBookList=dataArray;
            [self finishDownload];

            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self finishDownload];

    }];
    
    [manager POST:top_download_book_list_url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responseObject != NULL && [responseObject isKindOfClass:[NSArray class]]){
            NSMutableArray *dataArray=(NSMutableArray*)responseObject;
            appDelegate.topDownloadedBookList=dataArray;
            [self finishDownload];

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self finishDownload];

    }];
//    }else{
//        finishDownload=TRUE;
//        [self loadHomeScreen];
//    }
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
