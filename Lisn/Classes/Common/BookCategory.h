//
//  BookCategory.h
//  Lisn
//
//  Created by Rasika Kumara on 3/23/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookCategory : NSObject

-(id)initWithDataDic:(NSDictionary*)dataDic;

@property int _id;
@property (strong, nonatomic) NSString *name,*english_name;
@end
