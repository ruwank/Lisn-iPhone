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
            if([jsonDic valueForKey:@"purchased"]!= nil)
                _isPurchased = [[jsonDic valueForKey:@"purchased"] boolValue];
            
        }
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_title    forKey:@"title"];
    [coder encodeObject:_english_title    forKey:@"english_title"];
    [coder encodeInt: _chapter_id forKey:@"chapter_id"];
    [coder encodeFloat:_discount     forKey:@"discount"];
    [coder encodeFloat:_price     forKey:@"price"];
    [coder encodeFloat:_size     forKey:@"size"];
    [coder encodeBool:_isPurchased forKey:@"isPurchased"];
    [coder encodeInt: _lastSeekPoint forKey:@"lastSeekPoint"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    self.title    = [coder decodeObjectForKey:@"title"];
    self.english_title    = [coder decodeObjectForKey:@"english_title"];
    self.chapter_id    = [coder decodeIntForKey:@"chapter_id"];
    self.discount    = [coder decodeFloatForKey:@"discount"];
    self.price    = [coder decodeFloatForKey:@"price"] ;
    self.size    = [coder decodeFloatForKey:@"size"];
    self.isPurchased = [coder decodeBoolForKey:@"isPurchased"];
    self.lastSeekPoint    = [coder decodeIntForKey:@"lastSeekPoint"];
   
    return self;
}

@end
