//
//  RssSubscribe.h
//  RssReaderFree
//
//  Created by oushunwu on 15/5/16.
//  Copyright (c) 2015年 oushunwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RssSubscribe : NSManagedObject

@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSNumber * isFavouriate;
@property (nonatomic, retain) NSDate * lastUpdateTime;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * sumary;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * total;
@property (nonatomic, retain) NSNumber * updateTimeInterval;

@end
