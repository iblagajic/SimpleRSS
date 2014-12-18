#import "_SMLFeed.h"

@interface SMLFeed : _SMLFeed {}

+ (void)insertFeedWithDictionary:(NSDictionary*)dictionary inContext:(NSManagedObjectContext*)context;
+ (NSArray*)arrayOfExistingFeedsForTitles:(NSArray*)titles inContext:(NSManagedObjectContext*)context;

@end
