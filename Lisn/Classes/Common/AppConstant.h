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


/***************************** Network Error related constants *****************************/

#define ERROR_BAD_REQUEST                   400
#define ERROR_UNAUTHORIZED                  401
#define ERROR_FORBIDDEN                     403
#define ERROR_RESOURCE_NOT_FOUND            404
#define ERROR_METHOD_NOT_ALLOWED            405
#define ERROR_CONFLICT                      409
#define ERROR_EXPIERD                       410
#define ERROR_INTERNAL_ERROR                500
#define ERROR_NOT_IMPLEMENTED               501
#define ERROR_SERVICE_UNAVAILABLE           503

typedef enum{
    ErrorTypeNone=0,
    ErrorTypeNetworkNotAvailable,
    ErrorTypeBadRequest=ERROR_BAD_REQUEST,
    ErrorTypeUnauthorized=ERROR_UNAUTHORIZED,
    ErrorTypeForbidden=ERROR_FORBIDDEN,
    ErrorTypeResourceNotFound=ERROR_RESOURCE_NOT_FOUND,
    ErrorTypeMethodNotAllowed=ERROR_METHOD_NOT_ALLOWED,
    ErrorTypeConflict=ERROR_CONFLICT,
    ErrorTypeExpierd=ERROR_EXPIERD,
    ErrorTypeInternalError=ERROR_INTERNAL_ERROR,
    ErrorTypeNotImplemented=ERROR_NOT_IMPLEMENTED,
    ErrorTypeSeviceUnavailable=ERROR_SERVICE_UNAVAILABLE,
}ErrorType;


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


typedef enum  {
    RESULT_NONE,
    RESULT_ERROR,
    RESULT_SUCCESS,
    RESULT_SUCCESS_ALREADY,
}PaymentStatus;

#define RGBA(r, g, b, a)            [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]


#define CONTACT_US_MAIL     @"info@lisn.audio"

#define PLAYER_NOTIFICATION @"player_notification"
#define PlayerNotificationTypeKey    @"PlayerNotificationTypeKey"
#define PlayerNotificationBookIdKey    @"PlayerNotificationBookIdKey"
#define PlayerNotificationChapterIndexKey    @"PlayerNotificationChapterIndexKey"
#define PlayerNotificationTypePlayingFinished   1
#define PlayerNotificationTypePlayingPaused   2
#define PlayerNotificationTypePlayingResumed   3


#define IS_SHOW_TURTORIAL     @"is_show_turtorial"



