//
//  AudioBook.h
//  Lisn
//
//  Created by Rasika Kumara on 3/23/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioBook : NSObject<NSCoding>


typedef enum  {
    LAN_EN, LAN_SI
}LanguageCode;

typedef enum  {
    ACTION_MORE, ACTION_PREVIEW,ACTION_DETAIL,ACTION_PURCHASE,ACTION_PLAY,ACTION_DELETE,ACTION_DOWNLOAD
}SelectedAction;


@property (strong, nonatomic) NSString *ISBN,*book_id,*duration,*narrator,*title, *book_description, *author, *language, *price, *category,*rate,
*cover_image,*banner_image, *preview_audio,*english_title,*english_description,*downloads;
@property  BOOL isPurchase,isAwarded,isDownloaded,isTotalBookPurchased;
@property int lastPlayFileIndex,lastSeekPoint,downloadCount,discount,audioFileCount,fileSize;
@property float previewDuration;

@property (strong, nonatomic) NSMutableArray* downloadedChapter;
@property (strong, nonatomic) NSMutableArray* reviews;
@property (strong, nonatomic) NSMutableArray* chapters;
@property LanguageCode lanCode;

- (instancetype)initWithDataDictionary:(NSDictionary *)jsonDic;

@end
