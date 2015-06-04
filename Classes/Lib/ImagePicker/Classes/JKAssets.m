//
//  JKAssets.m
//  JKImagePicker
//
//  Created by Jecky on 15/1/13.
//  Copyright (c) 2015年 Jecky. All rights reserved.
//

#import "JKAssets.h"

NSString *const kJKPickerGroupPropertyID    = @"kJKPickerGroupPropertyID";
NSString *const kJKPickerGroupPropertyURL   = @"kJKPickerGroupPropertyURL";
NSString *const kJKPickerAssetPropertyURL   = @"kJKPickerAssetPropertyURL";

@implementation JKAssets

#pragma mark - NSCoding
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.groupPropertyID = [aDecoder decodeObjectForKey:kJKPickerGroupPropertyID];
        self.groupPropertyURL = [aDecoder decodeObjectForKey:kJKPickerGroupPropertyURL];
        self.assetPropertyURL = [aDecoder decodeObjectForKey:kJKPickerAssetPropertyURL];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_groupPropertyID forKey:kJKPickerGroupPropertyID];
    [aCoder encodeObject:_groupPropertyURL forKey:kJKPickerGroupPropertyURL];
    [aCoder encodeObject:_assetPropertyURL forKey:kJKPickerAssetPropertyURL];
}


@end
