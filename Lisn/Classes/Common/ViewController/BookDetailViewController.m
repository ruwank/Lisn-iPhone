//
//  BookDetailViewController.m
//  Lisn
//
//  Created by A M S Sumanasooriya on 5/23/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "BookDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import <ResponsiveLabel.h>
#import "AppConstant.h"
#import "AppUtils.h"

@interface BookDetailViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *thumbDetailView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbDetailVH;
@property (weak, nonatomic) IBOutlet UIImageView *bgThumbView;
@property (weak, nonatomic) IBOutlet UIView *alphaView;

@property (weak, nonatomic) IBOutlet UIImageView *bookThumbView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bookThumbVW;

@property (weak, nonatomic) IBOutlet UIView *rankStarsView;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;

@property (weak, nonatomic) IBOutlet ResponsiveLabel *bookNameLbl;
@property (weak, nonatomic) IBOutlet ResponsiveLabel *booKAutherLbl;
@property (weak, nonatomic) IBOutlet ResponsiveLabel *bookReaderLbl;

@end

@implementation BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self adjustViewHeights];
    [self setInitialData];
}

- (void)adjustViewHeights
{
    float thumbW = (SCREEN_WIDTH)/3.0;
    _bookThumbVW.constant = thumbW;
    
    float thumbDetH = 161 + (thumbW * 1.5);
    _thumbDetailVH.constant = thumbDetH;
}

- (void)setInitialData
{
    if (_audioBook == nil) {
        return;
    }
    
    if(_audioBook.lanCode == LAN_SI){
        _bookNameLbl.font = [UIFont fontWithName:@"FMAbhaya" size:18];
        [_bookNameLbl setTruncationToken:@"'''"];
        
        _booKAutherLbl.font = [UIFont fontWithName:@"FMAbhaya" size:14];
        [_booKAutherLbl setTruncationToken:@"'''"];
        
        _bookReaderLbl.font = [UIFont fontWithName:@"FMAbhaya" size:14];
        [_bookReaderLbl setTruncationToken:@"'''"];
        
    }else{
        _bookNameLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        [_bookNameLbl setTruncationToken:@"..."];
        
        _booKAutherLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        [_booKAutherLbl setTruncationToken:@"..."];
        
        _bookReaderLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        [_bookReaderLbl setTruncationToken:@"..."];
    }
    
    _bookNameLbl.text = _audioBook.title;
    _booKAutherLbl.text = _audioBook.author;
    //_bookReaderLbl.text = @"";
    NSString *imageURL = _audioBook.cover_image;
    
    NSMutableURLRequest *imageRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageURL]
                                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                            timeoutInterval:60];
    [_bookThumbView setImageWithURLRequest:imageRequest
                           placeholderImage:[UIImage imageNamed:@"AppIcon"]
                                    success:nil
                                    failure:nil];
    
    [_bgThumbView setImageWithURLRequest:imageRequest
                          placeholderImage:[UIImage imageNamed:@"AppIcon"]
                                   success:nil
                                   failure:nil];
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
