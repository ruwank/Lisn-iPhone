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
#import "PurchaseViewController.h"
#import "WebServiceURLs.h"
#import "DataSource.h"
#import "LoginViewController.h"

@interface BookDetailViewController () <UITableViewDelegate, UITableViewDataSource, DetailViewTableViewCellDelegate,PurchaseViewControllerDelegate,LoginViewControllerDelegate>{
    BOOL isSelectChapter;
}

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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewH;

@property (weak, nonatomic) IBOutlet UIButton *payByCardBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *payByBillBtn;

@property (nonatomic, strong) NSMutableArray *chapterArray;
@property (nonatomic, assign) float tableViewHeight;

@property (nonatomic, assign) BOOL shouldShrinkTableView;
@property (nonatomic, assign) float shrinkGapMiddleView;
@property (nonatomic, assign) float extractGapMiddleView;

@property (nonatomic, assign) float middleViewHeight;
@property (nonatomic, assign) BOOL shouldShrinkMiddleView;
@property (nonatomic, assign) float shrinkGapBottomView;
@property (nonatomic, assign) float extractGapBottomView;

@property (nonatomic, assign) int rowLimit;
@property (nonatomic, assign) float lblHeightLimit;
@property (nonatomic, assign) float lblHeight;

@end

@implementation BookDetailViewController

- (IBAction)payByCardButtonTapped:(id)sender {
    if([[DataSource sharedInstance] isUserLogin]){
        isSelectChapter=false;
    UserProfile *userProfile=[[DataSource sharedInstance] getProfileInfo];
    NSString *userId=userProfile.userId;
    NSString *bookid=_audioBook.book_id;
    
    float amount= (float) (([_audioBook.price floatValue]) * ((100.0-_audioBook.discount)/100.0));
    
    NSString *url=[NSString stringWithFormat:@"%@?userid=%@&bookid=%@&amount=%f",purchase_book_url,userId,bookid,amount];
        [self loadPurchaseViewController:url];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewControllerId"];
        viewController.delegate = self;
        [self presentViewController:viewController animated:YES completion:nil];
    }
}

- (IBAction)payByBillButtonTapped:(id)sender {
    
}

- (IBAction)playButtonTapped:(id)sender {
    isSelectChapter=false;

    if (_audioBook.isTotalBookPurchased && [_audioBook.chapters count] == [_audioBook.downloadedChapter count]) {
        //Play
    }else{
        if(!_audioBook.isTotalBookPurchased && [_audioBook.price floatValue]< 1){
           //Log downlaod
        }else{
           //Download
        }
        
    }
}

- (IBAction)viewAllButtonTapped:(id)sender {
    if (_shouldShrinkTableView) {
        _middleViewTop.constant = _shrinkGapMiddleView;
        _shouldShrinkTableView = NO;
        [_viewAllBtn setTitle:@"VIEW ALL" forState:UIControlStateNormal];
        
        if (_chapterArray.count > 3) {
            _rowLimit = 4;
        }else {
            _rowLimit = (int)_chapterArray.count;
        }
        
    }else {
        _middleViewTop.constant = _extractGapMiddleView;
        _shouldShrinkTableView = YES;
        [_viewAllBtn setTitle:@"VIEW LESS" forState:UIControlStateNormal];
        
        _rowLimit = (int)_chapterArray.count;
    }
    
    [_chapterTableView reloadData];
}

- (IBAction)readMoreButtonTapped:(id)sender {
    if (_shouldShrinkMiddleView) {
        //_bottomViewTop.constant = _shrinkGapBottomView;
        _shouldShrinkMiddleView = NO;
        [_readMoreBtn setTitle:@"READ MORE" forState:UIControlStateNormal];
        
        _middleViewH.constant = 47 + _lblHeightLimit + 8;
    }else {
        //_bottomViewTop.constant = _extractGapBottomView;
        _shouldShrinkMiddleView = YES;
        [_readMoreBtn setTitle:@"READ LESS" forState:UIControlStateNormal];
        
        _middleViewH.constant = 47 + _lblHeight + 8;
    }
}
-(void)loadPurchaseViewController:(NSString*)url{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PurchaseViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"PurchaseViewControllerId"];
    [viewController loadUrl:url];
    //[viewController loadUrl:@"https://www.google.lk/"];
    viewController.delegate=self;
    [self.navigationController pushViewController:viewController animated:YES];
   // viewController.delegate = self;
}

-(void)updateButton{
    if([[DataSource sharedInstance] isUserLogin] && (_audioBook.isTotalBookPurchased ||([_audioBook.price floatValue]< 1))){
        _payByBillBtn.hidden=YES;
        _payByCardBtn.hidden=YES;
        _playBtn.hidden=NO;
        if(_audioBook.isTotalBookPurchased || [_audioBook.price floatValue]< 1){
            [_playBtn setTitle:@"Download" forState:UIControlStateNormal];
            if([_audioBook.chapters count] == [_audioBook.downloadedChapter count]){
                [_playBtn setTitle:@"Play" forState:UIControlStateNormal];
            }
        }
        
    }else{
        _payByBillBtn.hidden=NO;
        _payByCardBtn.hidden=NO;
        _playBtn.hidden=YES;
        
        if([AppUtils getServiceProvider] ==PROVIDER_NONE){
            _payByBillBtn.hidden=YES;
            
        }
        else if([AppUtils getServiceProvider] ==PROVIDER_MOBITEL){
            [_payByBillBtn setTitle:@"Add to Mobitel bill" forState:UIControlStateNormal];
        }
        else if([AppUtils getServiceProvider] ==PROVIDER_DIALOG){
            [_payByBillBtn setTitle:@"Add to Dialog bill" forState:UIControlStateNormal];

        }
        else if([AppUtils getServiceProvider] ==PROVIDER_ETISALAT){
            [_payByBillBtn setTitle:@"Add to Etisalat bill" forState:UIControlStateNormal];

        }
        _payByCardBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _payByCardBtn.titleLabel.numberOfLines = 2;
        _payByCardBtn.titleLabel.textAlignment = NSTextAlignmentCenter; // if u need
        NSString *buttonText=[NSString stringWithFormat:@"Pay by Card (%d %% discount)",_audioBook.discount];
        [_payByCardBtn setTitle:buttonText forState:UIControlStateNormal];

        //btnPayFromCard.setText("Pay by Card (" + audioBook.getDiscount() + "% discount)");

    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _payByBillBtn.layer.borderWidth = 1.0f;
    _payByBillBtn.layer.borderColor = RGBA(255, 255, 255, 1).CGColor;
    
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
    _chapterArray=_audioBook.chapters;

    float tableH = _chapterArray.count * 44;
    _tableViewH.constant = tableH;
    _tableViewHeight = tableH;
    
    _shouldShrinkTableView = YES;
    _shrinkGapMiddleView = 44*3 - tableH;
    _extractGapMiddleView = 0;
    
    [self viewAllButtonTapped:nil];
    
    //156
    //Calculate discriptionLabel height
    if(_audioBook.lanCode == LAN_SI){
        
        [_discriptionLabel setTruncationToken:@"'''"];
        
        NSDictionary *ats = @{NSForegroundColorAttributeName : RGBA(0, 0, 0, 1),
                              NSFontAttributeName : [UIFont fontWithName:@"FMAbhaya" size:16.0f]
                              };
        CGRect textRect = [_audioBook.book_description boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 16, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:ats context:nil];
        NSAttributedString *attribDisc= [[NSAttributedString alloc] initWithString:_audioBook.book_description attributes:ats];
        _discriptionLabel.attributedText = attribDisc;
        
        _lblHeight = textRect.size.height;
        
    }else {
        [_discriptionLabel setTruncationToken:@"..."];
        
        NSDictionary *ats = @{NSForegroundColorAttributeName : RGBA(0, 0, 0, 1),
                              NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:16.0f]
                              };
        CGRect textRect = [_audioBook.english_description boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 16, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:ats context:nil];
        NSAttributedString *attribDisc= [[NSAttributedString alloc] initWithString:_audioBook.english_description attributes:ats];
        _discriptionLabel.attributedText = attribDisc;
        
        _lblHeight = textRect.size.height;
    }
    
    if (_discriptionLabel.text.length == 0) {
        _readMoreBtn.hidden = YES;
    }
    
    _lblHeightLimit = 60;
    
    //_middleViewHeight = 148 + discLblH + 8;
    _middleViewHeight = 47 + _lblHeight + 8;
    _middleViewH.constant = _middleViewHeight;
    
    _shouldShrinkMiddleView = YES;
    _shrinkGapBottomView = 50 - _lblHeight - 8;
    _extractGapBottomView = 0;
    
    [self readMoreButtonTapped:nil];
    [self updateButton];
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
    //return [_chapterArray count];
    return _rowLimit;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewTableViewCell *cell = (DetailViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DetailViewTableViewCellId"];
    
    if (cell == nil) {
        cell = [[DetailViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailViewTableViewCellId"];
    }
    
    BookChapter *chapter = [_chapterArray objectAtIndex:[indexPath row]];
    [cell setChapter:chapter andBookId:_audioBook.book_id andLanguageCode:_audioBook.lanCode];
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - DetailViewTableViewCellDelegate
- (void)detailViewTableViewCellButtonTapped:(DetailViewTableViewCell *)detailViewTableViewCell {
    BookChapter *chapter=detailViewTableViewCell.chapter;
    
}
#pragma mark -PurchaseViewControllerDelegate methods
- (void)purchaseComplete:(PaymentStatus)status{
    
}
#pragma mark - LoginViewControllerDelegate

- (void)loginSucceeded {
    if (isSelectChapter) {
        
    }else{
        [self payByCardButtonTapped:nil];
    }
}

- (void)loginCancelled {
    
}



@end
