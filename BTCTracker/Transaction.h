//
//  Transaction.h
//  BTCTracker
//
//  Created by Antonio Martinez on 18/12/2013.
//  Copyright (c) 2013 AMG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Transaction : NSManagedObject

@property (nonatomic, retain) NSNumber * coins;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSDate * date;

@end
