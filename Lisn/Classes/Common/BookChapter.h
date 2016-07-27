//
//  BookChapter.h
//  Lisn
//
//  Created by A M S Sumanasooriya on 6/26/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookChapter : NSObject<NSCoding>

@property (nonatomic, strong) NSString *title,*english_title;
@property float discount,size,price;
@property int chapter_id;
@property  BOOL isPurchased;
@property int lastSeekPoint;


- (instancetype)initWithDataDictionary:(NSDictionary *)jsonDic;

@end
