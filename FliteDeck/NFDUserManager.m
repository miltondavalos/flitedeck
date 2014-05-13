//
//  NFDUserManager.m
//  UserSettings
//
//  Created by Ryan Smith on 3/8/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDUserManager.h"
#import "NFDFileSystemHelper.h"
#import "NCLPhoneNumberFormatter.h"

static NFDUserManager *sharedManager;

NSString * const NFD_USER_MANAGER_USER_INFO_DID_CHANGE_NOTIFICATION = @"UserInfoDidChange";

NSString * const NFDAccountSettingsUsername = @"Username";
NSString * const NFDUserSettingsName = @"Name";
NSString * const NFDUserSettingsTitle = @"Title";
NSString * const NFDUserSettingsEmail = @"Email";
NSString * const NFDUserSettingsPhoneWork = @"Office phone";
NSString * const NFDUserSettingsPhoneMobile = @"Cell phone";

NSString * const NFDUserPreferenceProfileShowMoney = @"Flight Profile $";
NSString * const NFDUserPreferenceProposalShowHourly = @"Proposal Hourly $";
NSString * const NFDUserPreferenceProposalShowTailNumber = @"Proposal Tail Number";
NSString * const NFDUserPreferenceCompany=@"Company";

@implementation NFDUserManager

@synthesize userInfo = _userInfo;
@synthesize keys = _keys;
@synthesize remoteDataSyncProgress;
@synthesize syncInProgress;

-(id)init
{
    if ((self = [super init]))
    {
        self.keys = [NSArray arrayWithObjects:
                     NFDAccountSettingsUsername,
                     NFDUserSettingsName,
                     NFDUserSettingsTitle,
                     NFDUserSettingsPhoneWork,
                     NFDUserSettingsPhoneMobile,
                     NFDUserSettingsEmail,
                     NFDUserPreferenceProfileShowMoney,
                     NFDUserPreferenceProposalShowHourly,
                     NFDUserPreferenceProposalShowTailNumber,
                     NFDUserPreferenceCompany,
                     nil];
        
        self.userInfo = [[NSMutableDictionary alloc] init];
        for (NSString *key in self.keys)
        {
            [self.userInfo setObject:@"" forKey:key];
        }
        if ([[NSFileManager defaultManager] fileExistsAtPath:pathInDocumentDirectory(@"userSettings")])
        {
            NSDictionary *tempDict = [NSDictionary dictionaryWithContentsOfFile:pathInDocumentDirectory(@"userSettings")];
            for (NSString *key in [tempDict allKeys])
            {
                [self.userInfo setObject:[tempDict objectForKey:key] forKey:key];
            }
        }
    }
    return self;
}

- (void)setInfo:(id)info forKey:(NSString *)key
{
    if (info != nil && key != nil)
    {
        [self.userInfo setObject:info forKey:key];
        [self.userInfo writeToFile:pathInDocumentDirectory(@"userSettings") atomically:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:NFD_USER_MANAGER_USER_INFO_DID_CHANGE_NOTIFICATION object:nil];
    }
}

- (id)objectForKey:(NSString *)key
{
    id obj;
    if (key != nil)
    {
        obj = [self.userInfo objectForKey:key];
    }
    return obj;
}

- (void)clearInfo
{
    for (NSString *key in self.keys)
    {
        [self setInfo:@"" forKey:key];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NFD_USER_MANAGER_USER_INFO_DID_CHANGE_NOTIFICATION object:nil];
}

- (NSString *)username
{
    return [self objectForKey:NFDAccountSettingsUsername];
}

- (NSString *)name
{
    return [self objectForKey:NFDUserSettingsName];
}

- (NSString *)nameAndTitle
{
    return [NSString stringWithFormat:@"%@, %@", [self objectForKey:NFDUserSettingsName], [self objectForKey:NFDUserSettingsTitle]];
}

- (NSString *)email
{
    return [self objectForKey:NFDUserSettingsEmail];
}

- (NSString *)phoneWork
{
    return [self objectForKey:NFDUserSettingsPhoneWork];
}

- (NSString *)phoneMobile
{
    return [self objectForKey:NFDUserSettingsPhoneMobile];
}

- (BOOL)profileShowMoney
{
    if (self.companySetting == NFDCompanySettingNJE) {
        // Never show costs for NJE
        return NO;
    }
    
    return [[self objectForKey:NFDUserPreferenceProfileShowMoney] boolValue];
}

- (BOOL)proposalShowHourly
{
    return [[self objectForKey:NFDUserPreferenceProposalShowHourly] boolValue];
}

- (BOOL)proposalShowTailNumber
{
    return [[self objectForKey:NFDUserPreferenceProposalShowTailNumber] boolValue];
}

- (NFDCompanySetting) companySetting
{
    return [[self objectForKey:NFDUserPreferenceCompany] integerValue];
}

- (void) setCompanySetting:(NFDCompanySetting) companySetting
{
    [self setInfo:[NSNumber numberWithInt:companySetting] forKey:NFDUserPreferenceCompany];
}

- (void)toggleProfileShowMoney
{
    [self setInfo:[NSNumber numberWithBool:![self profileShowMoney]] forKey:NFDUserPreferenceProfileShowMoney];
}

- (void)toggleProposalShowHourly
{
    [self setInfo:[NSNumber numberWithBool:![self proposalShowHourly]] forKey:NFDUserPreferenceProposalShowHourly];
}

- (void)toggleProposalShowTailNumber
{
    [self setInfo:[NSNumber numberWithBool:![self proposalShowTailNumber]] forKey:NFDUserPreferenceProposalShowTailNumber];
}

- (void)setProfileShowMoney:(BOOL) showMoney
{
    [self setInfo:[NSNumber numberWithBool:showMoney] forKey:NFDUserPreferenceProfileShowMoney];
}

- (void)setProposalShowHourly:(BOOL) showHourly
{
    [self setInfo:[NSNumber numberWithBool:showHourly] forKey:NFDUserPreferenceProposalShowHourly];
}

+ (NSString *) stringForCompanySetting:(NFDCompanySetting) companySetting
{
    NSString *company = nil;
    switch (companySetting) {
        case NFDCompanySettingNJA:
            company = @"NJA";
            break;
        case NFDCompanySettingNJE:
            company = @"NJE";
            break;
        default:
            break;
    }
    
    return company;
}

+ (NFDCompanySetting) companySettingForString:(NSString *) companyString
{
    NFDCompanySetting company = -1;
    if([companyString isEqualToString:@"NJA"]) {
        company = NFDCompanySettingNJA;
    } else if ([companyString isEqualToString:@"NJE"]) {
        company = NFDCompanySettingNJE;
    }
    return company;
}


#pragma mark Singleton stuff

+ (NFDUserManager *)sharedManager
{
	if (!sharedManager)
	{
		sharedManager = [[NFDUserManager alloc] init];
	}
	return sharedManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
	if (!sharedManager)
	{
		sharedManager = [super allocWithZone:zone];
		return sharedManager;
	}
	else 
	{
		return nil;
	}
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}


@end
