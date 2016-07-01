//
//  AppConstant.h
//  PINKCampusRep
//
//  Created by IOT on 3/4/16.
//  Copyright © 2016 IronOneTech. All rights reserved.
//

#ifndef AppConstant_h
#define AppConstant_h

#define PRIMARY_COLOR [UIColor colorWithRed:238/255.0f green:159/255.0f blue:31/255.0f alpha:1]

#endif /* AppConstant_h */


#define SCREEN_WIDTH                [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT               [[UIScreen mainScreen] bounds].size.height

typedef enum {
    BookCellTypeMy,
    BookCellTypeNewReleased,
    BookCellTypeTopRated,
    BookCellTypeTopDownload
}BookCellType;


//typedef enum  {
//    ACTION_MORE, ACTION_PREVIEW,ACTION_DETAIL,ACTION_PURCHASE,ACTION_PLAY,ACTION_DELETE,ACTION_DOWNLOAD
//}SelectedAction;

typedef enum  {
    PROVIDER_NONE,
    PROVIDER_MOBITEL,
    PROVIDER_DIALOG,
    PROVIDER_ETISALAT
}ServiceProvider;

typedef enum  {
    OPTION_NONE,
    OPTION_CARD,
    OPTION_MOBITEL,
    OPTION_DIALOG,
    OPTION_ETISALAT
}PaymentOption;



#define RGBA(r, g, b, a)            [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]


#define CONTACT_US_MAIL     @"info@lisn.audio"