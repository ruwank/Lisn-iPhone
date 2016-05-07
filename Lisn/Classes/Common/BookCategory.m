//
//  BookCategory.m
//  Lisn
//
//  Created by Rasika Kumara on 3/23/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "BookCategory.h"

@implementation BookCategory
-(id)initWithDataDic:(NSDictionary*)dataDic{
    self=[super init];
    if(self){
        NSLog(@"dataDic %@",dataDic);
        self._id=(NSString*)[dataDic objectForKey:@"id"];
        self.name=(NSString*)[dataDic objectForKey:@"name"];
        self.english_name=(NSString*)[dataDic objectForKey:@"english_name"];
    }
    return self;
}
@end
