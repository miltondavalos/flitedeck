//
//  NFDFileSystemHelper.h
//  FliteDeck
//
//  Created by Evol Johnson on 2/10/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCLFramework.h"

@interface NFDFileSystemHelper : NSObject
+(NSString*) directoryForDocuments;
+(NSString *) directoryForData;
+(NSString*) directoryForColateral;
+(NSString*) directoryForMedia;
+(void) createDirectory : (NSString*) newDir;
+(BOOL) fileExist : (NSString*) filePath;
+(NSMutableArray *) listFiles : (NSString *) criteria;
+(NSMutableArray *) listFilesInBundle : (NSString *) criteria;

NSString *pathInDocumentDirectory(NSString *fileName);

@end
