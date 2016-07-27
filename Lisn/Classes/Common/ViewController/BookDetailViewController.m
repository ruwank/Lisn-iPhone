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
#import "WebServiceManager.h"
#import "Messages.h"
#import "FileOperator.h"
#import "PlayerViewController.h"
#import "LoadingIndicator.h"
#import <StoreKit/StoreKit.h>

#define ALERT_VIEW_TAG_DOWNLOD_COMPETE 10
#define ALERT_VIEW_TAG_PAYMENT_COMPETE  20
static NSString * const BUNDLE_ID =@"audio.lisn.Lisn.";

@interface BookDetailViewController () <UITableViewDelegate, UITableViewDataSource, DetailViewTableViewCellDelegate,PurchaseViewControllerDelegate,LoginViewControllerDelegate,UIActionSheetDelegate,LoadingIndicatorDelegate,SKPaymentTransactionObserver, SKProductsRequestDelegate>{
    BOOL isSelectChapter;
    //UIActivityIndicatorView *activityIndicator;
    BOOL isSelectCard;
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
@property (nonatomic, strong) BookChapter *selectedChapter;
//@property (nonatomic, strong) LoadingIndicator *indicator;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;

@end

@implementation BookDetailViewController

- (IBAction)payByCardButtonTapped:(id)sender {
    isSelectCard=YES;
    isSelectChapter=NO;
    if([[DataSource sharedInstance] isUserLogin]){
        [self buyAudioBook];
        
        /*
        isSelectChapter=false;
    UserProfile *userProfile=[[DataSource sharedInstance] getProfileInfo];
    NSString *userId=userProfile.userId;
    NSString *bookid=_audioBook.book_id;
    
    float amount= (float) (([_audioBook.price floatValue]) * ((100.0-_audioBook.discount)/100.0));
    
    NSString *url=[NSString stringWithFormat:@"%@?userid=%@&bookid=%@&amount=%f",purchase_book_url,userId,bookid,amount];
        [self loadPurchaseViewController:url];
        */
    }else{
        [self loadLoginScreen];
       
    }
}

- (IBAction)payByBillButtonTapped:(id)sender {
    //isSelectChapter=NO;
    //isSelectCard=NO;
    [AppUtils showContentIsNotReadyAlert];

}

- (IBAction)playButtonTapped:(id)sender {
    isSelectChapter=NO;

    if (_audioBook.isTotalBookPurchased && [_audioBook.chapters count] == [_audioBook.downloadedChapter count]) {
        //Play
    }else{
        if(!_audioBook.isTotalBookPurchased && [_audioBook.price floatValue]< 1){
            //[self performSegueWithIdentifier:@"player_seque_id" sender:nil];

           //Log downlaod
            [self logUserDownload];
            //[self performSegueWithIdentifier:@"player_seque_id" sender:nil];


        }else{
           //Download
            [self downloadAudioBook];
           // [self performSegueWithIdentifier:@"player_seque_id" sender:nil];

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
-(void)downloadAudioBook{
    BOOL downloadComplete=YES;
    for (BookChapter *chapter in _audioBook.chapters) {
        if(![FileOperator isAudioFileExists:_audioBook.book_id andFileIndex:chapter.chapter_id]){
            [self downloadAudioFile:_audioBook.book_id andFileIndex:chapter.chapter_id];
            downloadComplete=NO;
            break;
        }
    }
    if(downloadComplete){
    [self showDownloadCompleteMessage];
    [self hiddenLoadingView];
    }

    
}
-(void)downloadAudioFile:(NSString*)bookId andFileIndex:(int)index{
    //self.indicator.loadingText=@"Downloading...";
    //[self.indicator show];
    [self showLoadingView:[NSString stringWithFormat:@"Downloading Chapter %d",index]];
    [WebServiceManager downloadAudioFile:bookId andFileIndex:index withResponseHandeler:^(BOOL success, ErrorType errorType) {
        [self hiddenLoadingView];
        if(success){
            if(isSelectChapter){
                [self showDownloadCompleteMessage];
            }else{
                [self downloadAudioBook];
            }

        }else{
            [AppUtils showCommonErrorAlert];
        }
    }];
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
        if([_audioBook.price floatValue]< 1){
            _payByBillBtn.hidden=YES;
            _payByCardBtn.hidden=YES;
            _playBtn.hidden=NO;
            [_playBtn setTitle:@"Download" forState:UIControlStateNormal];

        }
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
    
//    self.indicator = [[LoadingIndicator alloc] initWithDelegate:self];
//    self.indicator.loadingText = @"Loading";
}
-(void)showLoadingView:(NSString*)message{
    _loadingView.hidden=NO;
    if(message){
        _loadingLabel.text=message;
    }
    [ _activityIndicator startAnimating];
}
-(void)hiddenLoadingView{
    _loadingView.hidden=YES;

    [ _activityIndicator stopAnimating];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    
    NSString *naraterText=@"";
    if(_audioBook.lanCode == LAN_SI){
        _bookNameLbl.font = [UIFont fontWithName:@"FMAbhaya" size:18];
        [_bookNameLbl setTruncationToken:@"'''"];
        
        _booKAutherLbl.font = [UIFont fontWithName:@"FMAbhaya" size:14];
        [_booKAutherLbl setTruncationToken:@"'''"];
        
        _bookReaderLbl.font = [UIFont fontWithName:@"FMAbhaya" size:14];
        [_bookReaderLbl setTruncationToken:@"'''"];
        naraterText=[NSString stringWithFormat:@"%@-%@",narrator_si,_audioBook.narrator];
        
    }else{
        _bookNameLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        [_bookNameLbl setTruncationToken:@"..."];
        
        _booKAutherLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        [_booKAutherLbl setTruncationToken:@"..."];
        
        _bookReaderLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        [_bookReaderLbl setTruncationToken:@"..."];
        naraterText=[NSString stringWithFormat:@"%@-%@",narrator_en,_audioBook.narrator];

    }
    
    _bookNameLbl.text = _audioBook.title;
    _booKAutherLbl.text = _audioBook.author;
    _bookReaderLbl.text = naraterText;
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
    
    //
    _payByBillBtn.hidden=YES;
    _chapterTableView.hidden=YES;
    _middleViewTop.constant =_shrinkGapMiddleView;
    _viewAllBtn.hidden=YES;
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
    [self payByBillButtonTapped:nil];
}
#pragma mark
-(void)updateAudioBook{
    [[DataSource sharedInstance] addBookToUserBookList:_audioBook];

}
-(void)showDownloadCompleteMessage{
   UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:DOWNLOAD_COMPLETE_TITLE message:DOWNLOAD_COMPLETE_MESSAGE delegate:self cancelButtonTitle:BUTTON_YES otherButtonTitles:BUTTON_NO,nil];
    alertView.tag=ALERT_VIEW_TAG_DOWNLOD_COMPETE;
    [alertView show];
    
}
-(void)loadAudioPlayer{
    int chapterIndex=1;
    if(isSelectChapter){
        chapterIndex=_selectedChapter.chapter_id;
    }else{
        chapterIndex=1;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PlayerViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"PlayerViewControllerId"];
    [viewController setAudioBook:_audioBook.book_id andFileIndex:chapterIndex];
    
    [self presentViewController:viewController animated:YES completion:nil];

}
-(void)loadLoginScreen{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewControllerId"];
    viewController.delegate = self;
    [self presentViewController:viewController animated:YES completion:nil];
}
-(void)showPaymentOptionActionSheet{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Payment Option"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Add to bill", @"Buy From Card", nil];
    actionSheet.tag=200;
    
    [actionSheet showInView:self.view];
    
}
-(void)logUserDownload{
    [self showLoadingView:@"Loading..."];
    AFHTTPSessionManager *manager = [AppUtils getAFHTTPSessionManager];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    responseSerializer.acceptableContentTypes = nil;
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    UserProfile *userProfile=[[DataSource sharedInstance] getProfileInfo];

    [params setValue:_audioBook.book_id forKey:@"bookid"];
    [params setValue:userProfile.userId forKey:@"userid"];
    
    if(isSelectChapter){
        [params setValue:[NSNumber numberWithInt:_selectedChapter.chapter_id] forKey:@"chapid"];
    }else{
        [params setValue:[NSNumber numberWithInt:0] forKey:@"chapid"];
    }
    NSLog(@"params %@",params);
        [manager POST:user_download_activity_url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            _audioBook.isPurchase=YES;
            if(isSelectChapter){
                _selectedChapter.isPurchased=YES;
                [self updateAudioBook];
                [self downloadAudioFile:_audioBook.book_id andFileIndex:_selectedChapter.chapter_id];
            }else{
                _audioBook.isTotalBookPurchased=YES;
                [self updateAudioBook];

                [self downloadAudioBook];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error %@",error);
            [self hiddenLoadingView];
            [AppUtils showCommonErrorAlert];


        }];
}
#pragma mark - DetailViewTableViewCellDelegate
- (void)detailViewTableViewCellButtonTapped:(DetailViewTableViewCell *)detailViewTableViewCell {
    isSelectChapter=YES;
    _selectedChapter=detailViewTableViewCell.chapter;
    
    if([[DataSource sharedInstance] isUserLogin]){
        if (_selectedChapter.isPurchased) {
            if([FileOperator isAudioFileExists:_audioBook.book_id andFileIndex:_selectedChapter.chapter_id]){
                [self loadAudioPlayer];

            }else{

            [self downloadAudioFile:_audioBook.book_id andFileIndex:_selectedChapter.chapter_id];
            }
        }else{
            if(_selectedChapter.price>0){
                [self showPaymentOptionActionSheet];
            }else{
                [self logUserDownload];
            }
        }
    }else{
        [self loadLoginScreen];
    }
    
}
-(void)startDownloadFile{
    if(isSelectChapter){
        [self downloadAudioFile:_audioBook.book_id andFileIndex:_selectedChapter.chapter_id];
    }else{
       
        [self downloadAudioBook];
    }

}
-(void)chapterByFromCard{
//    BookChapter bookChapter = (BookChapter) getIntent().getSerializableExtra("selectedChapter");
//    float amount= (float) ((bookChapter.getPrice()) * ((100.0-bookChapter.getDiscount())/100.0));
//    url=url+"&amount="+amount+"&chapid="+bookChapter.getChapter_id();
    
    UserProfile *userProfile=[[DataSource sharedInstance] getProfileInfo];
    NSString *userId=userProfile.userId;
    NSString *bookid=_audioBook.book_id;
    
    float amount= (float) ((_selectedChapter.price ) * ((100.0-_selectedChapter.discount)/100.0));
    
    NSString *url=[NSString stringWithFormat:@"%@?userid=%@&bookid=%@&amount=%f&chapid=%d",purchase_book_url,userId,bookid,amount,_selectedChapter.chapter_id];
    [self loadPurchaseViewController:url];
}
#pragma mark -InApp purchase methods

- (void)buyAudioBook{
    NSLog(@"User requests to remove ads");
    NSString *productId=[NSString stringWithFormat:@"%@%@",BUNDLE_ID,_audioBook.book_id];
    if([SKPaymentQueue canMakePayments]){
        NSLog(@"User can make payments");
        _loadingView.hidden=NO;
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:productId]];
        productsRequest.delegate = self;
        [productsRequest start];
        
    }
    else{
        NSLog(@"User cannot make payments due to parental controls");
        //this is called the user cannot make payments, most likely due to parental controls
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *validProduct = nil;
    NSInteger count = [response.products count];
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        [self purchase:validProduct];
    }
    else if(!validProduct){
        _loadingView.hidden=NO;

        NSLog(@"No products available");
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
}

- (void)purchase:(SKProduct *)product{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (IBAction) restore{
    //this is called when the user restores purchases, you should hook this up to a button
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %lu", (unsigned long)queue.transactions.count);
    for(SKPaymentTransaction *transaction in queue.transactions){
        if(transaction.transactionState == SKPaymentTransactionStateRestored){
            //called when the user successfully restores a purchase
            NSLog(@"Transaction state -> Restored");
            
            //if you have more than one in-app purchase product,
            //you restore the correct product for the identifier.
            //For example, you could use
            //if(productID == kRemoveAdsProductIdentifier)
            //to get the product identifier for the
            //restored purchases, you can use
            //
            //NSString *productID = transaction.payment.productIdentifier;
            [self completeInAppPurchase];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for(SKPaymentTransaction *transaction in transactions){
        switch(transaction.transactionState){
            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
                [self showLoadingView:@"Purchasing"];
                //called when the user is in the process of purchasing, do not add any of your own code here.
                break;
            case SKPaymentTransactionStatePurchased:
                //this is called when the user has successfully purchased the package (Cha-Ching!)
                //[self showLoadingView:@"Purchased "];

                [self completeInAppPurchase]; //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transaction state -> Purchased");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finish
                if(transaction.error.code == SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    //the user cancelled the payment ;(
                }
                [self hiddenLoadingView];

                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}
-(void)completeInAppPurchase{
    _audioBook.isPurchase=YES;
    _audioBook.isTotalBookPurchased=YES;
    [self updateAudioBook];
    [self hiddenLoadingView];

    UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:PAYMENT_COMPLETE_TITLE message:PAYMENT_COMPLETE_MESSAGE delegate:self cancelButtonTitle:BUTTON_YES otherButtonTitles:BUTTON_NO,nil];
    alertView.tag=ALERT_VIEW_TAG_PAYMENT_COMPETE;
    [alertView show];
}

#pragma mark -PurchaseViewControllerDelegate methods
- (void)purchaseComplete:(PaymentStatus)status{
    if(status == RESULT_SUCCESS || status== RESULT_SUCCESS_ALREADY){
        _audioBook.isPurchase=YES;
        if(isSelectChapter){
            _selectedChapter.isPurchased=YES;
            [self updateAudioBook];

        }else{
            _audioBook.isTotalBookPurchased=YES;
            [self updateAudioBook];
        }
        UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:PAYMENT_COMPLETE_TITLE message:PAYMENT_COMPLETE_MESSAGE delegate:self cancelButtonTitle:BUTTON_YES otherButtonTitles:BUTTON_NO,nil];
        alertView.tag=ALERT_VIEW_TAG_PAYMENT_COMPETE;
        [alertView show];
    }else{
        [AppUtils showCommonErrorAlert];
    }
}
#pragma mark - LoginViewControllerDelegate

- (void)loginSucceeded {
    if (isSelectChapter) {
        if(_selectedChapter.isPurchased){
            [self downloadAudioFile:_audioBook.book_id andFileIndex:_selectedChapter.chapter_id];
        }else{
            if(_selectedChapter.price>0){
                [self showPaymentOptionActionSheet];
            }else{
                [self logUserDownload];
            }
        }
    }else{
        [self payByCardButtonTapped:nil];
    }
}

- (void)loginCancelled {
    
}

#pragma mark -UIAlertViewDelegate method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex              {
    if(alertView.tag==ALERT_VIEW_TAG_DOWNLOD_COMPETE){
        
        if(buttonIndex == 0)//YES button pressed
        {
            //do something
            [self loadAudioPlayer];
           
        }
        else if(buttonIndex == 1)//NO button pressed.
        {
            //do something
        }
    }
    else if(alertView.tag==ALERT_VIEW_TAG_PAYMENT_COMPETE){
        
        if(buttonIndex == 0)//YES button pressed
        {
            //do something
            [self startDownloadFile];
            
        }
        else if(buttonIndex == 1)//NO button pressed.
        {
            //do something
        }
    }

}

#pragma mark -UIActionSheetDelegate method

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 200){
        NSLog(@"The Delete confirmation action sheet. %ld",(long)buttonIndex);
        if(buttonIndex == 0)//payby bill button pressed
        {
            //do something
            [AppUtils showContentIsNotReadyAlert];

            
        }
        else if(buttonIndex == 1)//card button pressed.
        {
            //do something
            [self chapterByFromCard];
            
        }
    }
    
    
   
}
@end
