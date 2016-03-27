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