//
//  UIDevice+Utility.m
//  NCLFramework
//
//  Created by Chad Long on 1/4/13.
//
//  Original source code courtesy John from iOSDeveloperTips.com
//

#import "NCLFramework.h"
#import "UIDevice+Utility.h"
#import <AdSupport/AdSupport.h>
#import <mach/mach.h>
#import <sys/utsname.h>

@implementation UIDevice (Utility)

+ (NSString*)identifier
{
    NSUUID *uuid = nil;
    
    if ([ASIdentifierManager sharedManager].advertisingTrackingEnabled)
    {
        uuid = [ASIdentifierManager sharedManager].advertisingIdentifier;
    }
    else
    {
        uuid = [UIDevice currentDevice].identifierForVendor;
    }
    
    return [uuid UUIDString] ?: @"";
}

+ (NSNumber*)freeMemory
{
    // get free memory in MB
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)
    {
        INFOLog(@"error obtaining free memory");
        
        return nil;
    }
    
    return [NSNumber numberFromObject:[NSString stringWithFormat:@"%10.0f", vm_stat.free_count * pagesize / 1024.0f / 1024.0f]];
}

+ (NSNumber*)freeDiskspace
{
    NSNumber *freeFileSystemSizeInBytes = nil;
    NSError *error = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error:&error];
    
    if (dictionary)
    {
        freeFileSystemSizeInBytes = [NSNumber numberWithLongLong:[[dictionary objectForKey:NSFileSystemFreeSize] unsignedLongLongValue] / 1024.0f / 1024.0f];
    }
    else
    {
        INFOLog(@"error obtaining free disk space: %@", [error localizedDescription]);
    }
    
    return freeFileSystemSizeInBytes;
}

+ (NSString*)modelName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *modelName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

    // iPhone
    if ([modelName isEqualToString:@"iPhone3,1"])
        modelName = @"iPhone 4";
    else if ([modelName isEqualToString:@"iPhone4,1"])
        modelName = @"iPhone 4S";
    else if ([modelName isEqualToString:@"iPhone5,1"] || [modelName isEqualToString:@"iPhone5,2"])
        modelName = @"iPhone 5";
    else if ([modelName isEqualToString:@"iPhone5,3"] || [modelName isEqualToString:@"iPhone5,4"])
        modelName = @"iPhone 5C";
    else if ([modelName isEqualToString:@"iPhone6,1"] || [modelName isEqualToString:@"iPhone6,2"])
        modelName = @"iPhone 5S";

    // iPad
    else if ([modelName isEqualToString:@"iPad2,1"])
        modelName = @"iPad 2";
    else if ([modelName isEqualToString:@"iPad3,1"])
        modelName = @"iPad 3";
    else if ([modelName isEqualToString:@"iPad3,4"])
        modelName = @"iPad 4";
    else if ([modelName isEqualToString:@"iPad4,1"] || [modelName isEqualToString:@"iPad4,2"])
        modelName = @"iPad Air";
    else if ([modelName isEqualToString:@"iPad2,5"] || [modelName isEqualToString:@"iPad4,4"] || [modelName isEqualToString:@"iPad4,5"])
        modelName = @"iPad Mini";
    
    return modelName;
}

+ (BOOL)isPhone
{
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
}

+ (BOOL)isSystemVersionAtLeastVersion:(NSInteger)version
{
    NSArray *vComp = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    
    if ([[vComp objectAtIndex:0] integerValue] >= version)
    {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isSimulator
{
    #if TARGET_IPHONE_SIMULATOR
        return YES;
    #else
        return NO;
    #endif
}

@end
