#import "_RSSFeed.h"

@interface RSSFeed : _RSSFeed {}

+ (void)insertFeedWithDictionary:(NSDictionary*)dictionary inContext:(NSManagedObjectContext*)context;
+ (NSArray*)arrayOfExistingFeedsForTitles:(NSArray*)titles inContext:(NSManagedObjectContext*)context;

@end
