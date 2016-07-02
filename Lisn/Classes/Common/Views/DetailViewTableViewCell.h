//
//  DetailViewTableViewCell.h
//  Lisn
//
//  Created by A M S Sumanasooriya on 6/26/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookChapter.h"
#import "AudioBook.h"
@protocol DetailViewTableViewCellDelegate;

@interface DetailViewTableViewCell : UITableViewCell

@property (nonatomic, strong) BookChapter *chapter;

@property (nonatomic, assign) id<DetailViewTableViewCellDelegate> delegate;

- (void)setChapter:(BookChapter *)chapter andBookId:(NSString*)bookId andLanguageCode:(LanguageCode)languageCode
;
@end

@protocol DetailViewTableViewCellDelegate <NSObject>

- (void)detailViewTableViewCellButtonTapped:(DetailViewTableViewCell *)detailViewTableViewCell;

@end
