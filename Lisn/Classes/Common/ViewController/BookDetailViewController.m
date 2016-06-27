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
#import "DetailViewTableViewCell.h"

@interface BookDetailViewController () <UITableViewDelegate, UITableViewDataSource, DetailViewTableViewCellDelegate>

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

@property (weak, nonatomic) IBOutlet UITableView *chapterTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewH;

@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIButton *viewAllBtn;
@property (weak, nonatomic) IBOutlet ResponsiveLabel *discriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleViewH;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *readMoreBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewTop;

@property (nonatomic, strong) NSMutableArray *chapterArray;
@property (nonatomic, assign) float tableViewHeight;

@property (nonatomic, assign) BOOL shouldShrinkTableView;
@property (nonatomic, assign) float shrinkGapMiddleView;
@property (nonatomic, assign) float extractGapMiddleView;

@property (nonatomic, assign) float middleViewHeight;
@property (nonatomic, assign) BOOL shouldShrinkMiddleView;
@property (nonatomic, assign) float shrinkGapBottomView;
@property (nonatomic, assign) float extractGapBottomView;

@end

@implementation BookDetailViewController

- (IBAction)payByCardButtonTapped:(id)sender {
    
}

- (IBAction)viewAllButtonTapped:(id)sender {
    if (_shouldShrinkTableView) {
        _middleViewTop.constant = _shrinkGapMiddleView;
        _shouldShrinkTableView = NO;
        [_viewAllBtn setTitle:@"VIEW ALL" forState:UIControlStateNormal];
    }else {
        _middleViewTop.constant = _extractGapMiddleView;
        _shouldShrinkTableView = YES;
        [_viewAllBtn setTitle:@"VIEW LESS" forState:UIControlStateNormal];
    }
}

- (IBAction)readMoreButtonTapped:(id)sender {
    if (_shouldShrinkMiddleView) {
        _bottomViewTop.constant = _shrinkGapBottomView;
        _shouldShrinkMiddleView = NO;
        [_readMoreBtn setTitle:@"READ MORE" forState:UIControlStateNormal];
    }else {
        _bottomViewTop.constant = _extractGapBottomView;
        _shouldShrinkMiddleView = YES;
        [_readMoreBtn setTitle:@"READ LESS" forState:UIControlStateNormal];
    }
}


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
    
    //Temp
    _chapterArray = [[NSMutableArray alloc] init];
    
    for (int i = 1; i < 10; i++) {
        BookChapter *chapter = [[BookChapter alloc] init];
        chapter.chapterName = [NSString stringWithFormat:@"Chapter %d", i];
        chapter.chapterPrice = [NSString stringWithFormat:@"Rs. 15.0"];
        if (i == 1) {
            chapter.isFree = YES;
        }
        
        [_chapterArray addObject:chapter];
    }
    //End Temp
    
    float tableH = _chapterArray.count * 44;
    _tableViewH.constant = tableH;
    _tableViewHeight = tableH;
    
    _shouldShrinkTableView = YES;
    _shrinkGapMiddleView = 44*3 - tableH;
    _extractGapMiddleView = 0;
    
    [self viewAllButtonTapped:nil];
    
    [_chapterTableView reloadData];
    
    //156
    //Calculate discriptionLabel height
    float discLblH = 100;
    _middleViewHeight = 148 + discLblH + 8;
    _middleViewH.constant = _middleViewHeight;
    
    _shouldShrinkMiddleView = YES;
    _shrinkGapBottomView = 50 - discLblH - 8;
    _extractGapBottomView = 0;
    
    [self readMoreButtonTapped:nil];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_chapterArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewTableViewCell *cell = (DetailViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DetailViewTableViewCellId"];
    
    if (cell == nil) {
        cell = [[DetailViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailViewTableViewCellId"];
    }
    
    BookChapter *chapter = [_chapterArray objectAtIndex:[indexPath row]];
    [cell setChapter:chapter];
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - DetailViewTableViewCellDelegate
- (void)detailViewTableViewCellButtonTapped:(DetailViewTableViewCell *)detailViewTableViewCell {
    
}


@end
