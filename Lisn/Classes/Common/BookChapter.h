//
//  BookChapter.h
//  Lisn
//
//  Created by A M S Sumanasooriya on 6/26/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookChapter : NSObject

@property (nonatomic, strong) NSString *chapterId;
@property (nonatomic, strong) NSString *chapterName;
@property (nonatomic, strong) NSString *chapterPrice;
@property (nonatomic, assign) BOOL isFree;
@property (nonatomic, assign) BOOL isBuy;


@end
