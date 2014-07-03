#import "_RSSItem.h"
#import "Ono.h"

@interface RSSItem : _RSSItem {}

+ (void)insertItemWithDictionary:(NSDictionary*)dictionary inContext:(NSManagedObjectContext*)context;
+ (NSArray*)arrayOfExistingItemsForTitles:(NSArray*)titles inContext:(NSManagedObjectContext*)context;

@end
