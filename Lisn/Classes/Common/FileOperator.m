//
//  FileOperator.m
//  One Touch Law
//
//  Created by Ruchira on 6/13/15.
//  Copyright (c) 2015 IronOne Technologies. All rights reserved.
//

#import "FileOperator.h"



@implementation FileOperator

#pragma mark - Basic methods
+(NSString *)getRootDirectory{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+(NSString *)getRootSavePath{
    
    NSString *rootPath = [self getRootDirectory];
    NSString *rootSavePath = [rootPath stringByAppendingPathComponent:@"AppData"];
    
    return rootSavePath;
}

+(void)checkAndCreateRootDirectory{
 
    NSString *rootSavePath = [self getRootSavePath];
    NSLog(@"ROOT PATH : %@", rootSavePath);
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if([manager fileExistsAtPath:rootSavePath]==NO){
        [manager createDirectoryAtPath:rootSavePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+(NSString *)getImageSavePath{
    NSString *rootSavePath = [self getRootSavePath];
    NSString *imageSavePath = [rootSavePath stringByAppendingPathComponent:@"Images"];
    return imageSavePath;
}

+(void)checkAndCreateImageSavePath{
    NSString *imageSavePath = [self getImageSavePath];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if([manager fileExistsAtPath:imageSavePath]==NO){
        [manager createDirectoryAtPath:imageSavePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
//+(void)createFilePath:(NSString*)filePath{
//    NSString *fileSavePath = [[self getRootSavePath] stringByAppendingPathComponent:filePath];
//    NSLog(@"ROOT PATH : %@", fileSavePath);
//    
//    NSFileManager *manager = [NSFileManager defaultManager];
//    if([manager fileExistsAtPath:fileSavePath]==NO){
//        [manager createDirectoryAtPath:fileSavePath withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//}

#pragma mark - Convenience methods

+(NSString *)pathForType:(NSString *)type{
    return [[self getRootSavePath] stringByAppendingPathComponent:type];
}
+(NSString *)bookSavePath{

    return [self pathForType:PATH_BOOK];
}
+(NSString *)profileFilePath{

    return [self pathForType:PATH_PROFILE];
}
+(NSString*)getAudioFilePath:(NSString*)bookId andFileIndex:(int)index{
    NSString *bookSavepath = [[self getRootSavePath] stringByAppendingPathComponent:bookId];
    NSFileManager *manager = [NSFileManager defaultManager];

    if([manager fileExistsAtPath:bookSavepath]==NO){
        [manager createDirectoryAtPath:bookSavepath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    NSString *filePath=[bookSavepath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.lisn",index]];
    return filePath;
    

}
+(BOOL)isAudioFileExists:(NSString*)bookId andFileIndex:(int)index{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self getAudioFilePath:bookId andFileIndex:index]];

}
#pragma mark - Check for file

+(BOOL)fileExists:(NSString *)type{
    
    NSString *filepath = [[self getRootSavePath] stringByAppendingPathComponent:type];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:filepath];
}

+(void)deleteFileType:(NSString *)type{
    NSString *filepath = [[self getRootSavePath] stringByAppendingPathComponent:type];
    [[NSFileManager defaultManager] removeItemAtPath:filepath error:nil];
}

@end
