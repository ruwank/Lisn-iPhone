//
//  AudioBook.m
//  Lisn
//
//  Created by Rasika Kumara on 3/23/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "AudioBook.h"

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
        }
    }
    return self;
}

@end
