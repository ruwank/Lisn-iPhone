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
            _ISBN = [jsonDic valueForKey:@"ISBN"];
            _book_id = [jsonDic valueForKey:@"book_id"];
            _duration = [jsonDic valueForKey:@"duration"];
            _narrator = [jsonDic valueForKey:@"narrator"];
            _title = [jsonDic valueForKey:@"title"];
            _book_description = [jsonDic valueForKey:@"description"];
            _author = [jsonDic valueForKey:@"author"];
            _language = [jsonDic valueForKey:@"language"];
            _price = [jsonDic valueForKey:@"price"];
            _category = [jsonDic valueForKey:@"category"];
            _rate = [jsonDic valueForKey:@"rate"];
            _cover_image = [jsonDic valueForKey:@"cover_image"];
            _banner_image = [jsonDic valueForKey:@"banner_image"];
            _preview_audio = [jsonDic valueForKey:@"preview_audio"];
            _english_title = [jsonDic valueForKey:@"english_title"];
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
