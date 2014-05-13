//
//  NFDFileSystemHelper.m
//  FliteDeck
//
//  Created by Evol Johnson on 2/10/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDFileSystemHelper.h"

@implementation NFDFileSystemHelper

+(NSString*) directoryForDocuments{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] ;
}

+(NSString*) directoryForData{
    // return [[self directoryForDocuments] stringByAppendingPathComponent:@"data/"];
    return [[self directoryForDocuments] stringByAppendingPathComponent:@"/"];
}


+(NSString*) directoryForColateral{
    return [[self directoryForDocuments] stringByAppendingPathComponent:@"pdf/"];
}
+(NSString*) directoryForMedia{
    return [[self directoryForDocuments] stringByAppendingPathComponent:@"media/"];
}

+(void) createDirectory : (NSString*) newDir{
    NSFileManager *filemgr;
    
    filemgr =[NSFileManager defaultManager];
    
    if ([filemgr createDirectoryAtPath:newDir withIntermediateDirectories:YES attributes:nil error: NULL] == NO)
    {
        DLog(@"Could not create dir %@",newDir);
    }
    
}


+(BOOL) fileExist : (NSString*) filePath {
    NSData *fileContents = [NSData dataWithContentsOfFile:filePath];
    DLog(@"Checking if %@ exists",filePath);
    if (fileContents == nil)
    {
        return NO;
    }
    else
    {
        return YES;
    }
    
} 


+(NSMutableArray *) listFiles : (NSString *) criteria {
    // get the list of all files and directories
    NSFileManager *fM = [NSFileManager defaultManager];
    NSError *error;
    NSArray *fileList = [fM contentsOfDirectoryAtPath:[self directoryForDocuments] error:&error] ;
    NSMutableArray *listOfFiles = [[NSMutableArray alloc] init];
    for(NSString *file in fileList) {
        NSString *path = [[self directoryForDocuments] stringByAppendingPathComponent:file];
        BOOL isDir = NO;
        [fM fileExistsAtPath:path isDirectory:(&isDir)];
        if(!isDir) {
            DLog(@"File %@",file);
            if([file contains:criteria]){
                [listOfFiles addObject:file];
            }
        }
    }
    return listOfFiles;
}


+(NSMutableArray *) listFilesInBundle : (NSString *) criteria {
    // get the list of all files and directories
    NSFileManager *fM = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *fileList = [fM contentsOfDirectoryAtPath:[[NSBundle mainBundle] bundlePath]  error:&error] ;
    NSMutableArray *listOfFiles = [[NSMutableArray alloc] init];
    for(NSString *file in fileList) {
        NSString *path = [[self directoryForDocuments] stringByAppendingPathComponent:file];
        BOOL isDir = NO;
        [fM fileExistsAtPath:path isDirectory:(&isDir)];
        if(!isDir) {
            //DLog(@"File %@",file);
            if([file contains:criteria]){
                [listOfFiles addObject:file];
            }
        }
    }
    return listOfFiles;
}

NSString *pathInDocumentDirectory(NSString *fileName)
{
	NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [documentDirectories objectAtIndex:0];
	return [documentDirectory stringByAppendingPathComponent:fileName];
}


@end
