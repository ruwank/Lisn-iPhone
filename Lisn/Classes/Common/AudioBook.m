//
//  AudioBook.m
//  Lisn
//
//  Created by Rasika Kumara on 3/23/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "AudioBook.h"
#import "BookChapter.h"

@implementation AudioBook

- (instancetype)initWithDataDictionary:(NSDictionary *)jsonDic
{
    self = [super init];
    if (self) {
        if (jsonDic) {
            
            if([jsonDic valueForKey:@"ISBN"]!= nil)
            _ISBN = [jsonDic valueForKey:@"ISBN"];
            
            if([jsonDic valueForKey:@"book_id"]!= nil)
            _book_id = [jsonDic valueForKey:@"book_id"];
            
            if([jsonDic valueForKey:@"duration"]!= nil)
            _duration = [jsonDic valueForKey:@"duration"];
            
            if([jsonDic valueForKey:@"narrator"]!= nil)
            _narrator = [jsonDic valueForKey:@"narrator"];
            
            if([jsonDic valueForKey:@"title"]!= nil)
            _title = [jsonDic valueForKey:@"title"];
            
            if([jsonDic valueForKey:@"description"]!= nil)
            _book_description = [jsonDic valueForKey:@"description"];
            
            if([jsonDic valueForKey:@"author"]!= nil)
            _author = [jsonDic valueForKey:@"author"];
            
            if([jsonDic valueForKey:@"language"]!= nil)
            _language = [jsonDic valueForKey:@"language"];
            
            if([jsonDic valueForKey:@"price"]!= nil)
            _price = [jsonDic valueForKey:@"price"];
            
            if([jsonDic valueForKey:@"category"]!= nil)
            _category = [jsonDic valueForKey:@"category"];
            
            if([jsonDic valueForKey:@"rate"]!= nil)
            _rate = [jsonDic valueForKey:@"rate"];
            
            if([jsonDic valueForKey:@"cover_image"]!= nil)
            _cover_image = [jsonDic valueForKey:@"cover_image"];
            
            if([jsonDic valueForKey:@"banner_image"]!= nil)
            _banner_image = [jsonDic valueForKey:@"banner_image"];
            
            if([jsonDic valueForKey:@"preview_audio"]!= nil)
            _preview_audio = [jsonDic valueForKey:@"preview_audio"];
            
            if([jsonDic valueForKey:@"english_title"]!= nil)
            _english_title = [jsonDic valueForKey:@"english_title"];
            
            if([jsonDic valueForKey:@"english_description"]!= nil)
            _english_description = [jsonDic valueForKey:@"english_description"];
            
            _lanCode = LAN_EN;
            if ([_language isEqualToString:@"SI"]) {
                _lanCode = LAN_SI;
            }
            
            if([jsonDic valueForKey:@"chapters"]!= nil && [[jsonDic valueForKey:@"chapters"] isKindOfClass:[NSArray class]] ){
                NSMutableArray *chapterArray=[[NSMutableArray alloc] init];
                for (NSDictionary *chapter in [jsonDic valueForKey:@"chapters"]) {
                    BookChapter *bookChapter=[[BookChapter alloc] initWithDataDictionary:chapter];
                    [chapterArray addObject:bookChapter];
                }
                _chapters=chapterArray;
                NSLog(@"[jsonDic valueForKey %@",[jsonDic valueForKey:@"chapters"]);
            }
        }
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_ISBN    forKey:@"ISBN"];
    [coder encodeObject:_book_id    forKey:@"book_id"];
    [coder encodeObject:_duration    forKey:@"duration"];
    [coder encodeObject:_narrator    forKey:@"narrator"];
    [coder encodeObject:_title    forKey:@"title"];
    [coder encodeObject:_book_description    forKey:@"description"];
    [coder encodeObject:_author    forKey:@"author"];
    [coder encodeObject:_language    forKey:@"language"];
    [coder encodeObject:_price    forKey:@"price"];
    [coder encodeObject:_category    forKey:@"category"];
    [coder encodeObject:_rate    forKey:@"rate"];
    [coder encodeObject:_cover_image    forKey:@"cover_image"];
    [coder encodeObject:_banner_image    forKey:@"banner_image"];
    [coder encodeObject:_preview_audio    forKey:@"preview_audio"];
    [coder encodeObject:_english_title    forKey:@"english_title"];
    [coder encodeObject:_english_description    forKey:@"english_description"];
    [coder encodeObject:_chapters    forKey:@"chapters"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    self.ISBN    = [coder decodeObjectForKey:@"ISBN"];
    self.book_id    = [coder decodeObjectForKey:@"book_id"];
    self.duration    = [coder decodeObjectForKey:@"duration"];
    self.narrator    = [coder decodeObjectForKey:@"narrator"];
    self.title    = [coder decodeObjectForKey:@"title"];
    self.book_description    = [coder decodeObjectForKey:@"description"];
    self.author    = [coder decodeObjectForKey:@"author"];
    self.language    = [coder decodeObjectForKey:@"language"];
    self.price    = [coder decodeObjectForKey:@"price"];
    self.category    = [coder decodeObjectForKey:@"category"];
    self.rate    = [coder decodeObjectForKey:@"rate"];
    self.cover_image    = [coder decodeObjectForKey:@"cover_image"];
    self.banner_image    = [coder decodeObjectForKey:@"banner_image"];
    self.preview_audio    = [coder decodeObjectForKey:@"preview_audio"];
    self.banner_image    = [coder decodeObjectForKey:@"banner_image"];
    self.english_title    = [coder decodeObjectForKey:@"english_title"];
    self.english_description    = [coder decodeObjectForKey:@"english_description"];
    self.chapters    = [coder decodeObjectForKey:@"chapters"];
    return self;
}

@end
