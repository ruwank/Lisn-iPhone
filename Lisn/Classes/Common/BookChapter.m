//
//  BookChapter.m
//  Lisn
//
//  Created by A M S Sumanasooriya on 6/26/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "BookChapter.h"

@implementation BookChapter

- (instancetype)initWithDataDictionary:(NSDictionary *)jsonDic{
    
    self = [super init];
    if (self) {
        if (jsonDic) {
            if([jsonDic valueForKey:@"title"]!= nil)
                _title = [jsonDic valueForKey:@"title"];
            if([jsonDic valueForKey:@"english_title"]!= nil)
                _english_title = [jsonDic valueForKey:@"english_title"];
            if([jsonDic valueForKey:@"chapter_id"]!= nil)
                _chapter_id = [[jsonDic valueForKey:@"chapter_id"] intValue];
            if([jsonDic valueForKey:@"discount"]!= nil)
                _discount = [[jsonDic valueForKey:@"discount"] floatValue];
            if([jsonDic valueForKey:@"price"]!= nil)
                _price = [[jsonDic valueForKey:@"price"] floatValue];
            if([jsonDic valueForKey:@"size"]!= nil)
                _size = [[jsonDic valueForKey:@"size"] floatValue];
            
        }
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_title    forKey:@"title"];
    [coder encodeObject:_english_title    forKey:@"english_title"];
    [coder encodeObject:[NSNumber numberWithInt:_chapter_id]    forKey:@"chapter_id"];
    [coder encodeObject:[NSNumber numberWithFloat:_discount]     forKey:@"discount"];
    [coder encodeObject:[NSNumber numberWithFloat:_price]     forKey:@"price"];
    [coder encodeObject:[NSNumber numberWithFloat:_size]     forKey:@"size"];
    
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    self.title    = [coder decodeObjectForKey:@"title"];
    self.english_title    = [coder decodeObjectForKey:@"english_title"];
    self.chapter_id    = [[coder decodeObjectForKey:@"chapter_id"] intValue];
    self.discount    = [[coder decodeObjectForKey:@"discount"] floatValue];
    self.price    = [[coder decodeObjectForKey:@"price"] floatValue];
    self.size    = [[coder decodeObjectForKey:@"size"] floatValue];
   
    return self;
}

@end
