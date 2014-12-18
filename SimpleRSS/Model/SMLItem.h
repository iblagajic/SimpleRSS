#import "_SMLItem.h"

@interface SMLItem : _SMLItem {}

+ (void)insertItemWithDictionary:(NSDictionary*)dictionary inContext:(NSManagedObjectContext*)context;
+ (NSArray*)arrayOfExistingItemsForTitles:(NSArray*)titles inContext:(NSManagedObjectContext*)context;

@end
