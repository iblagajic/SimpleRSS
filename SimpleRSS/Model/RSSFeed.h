#import "_RSSFeed.h"

@interface RSSFeed : _RSSFeed {}

+ (id)feedWithDictionary:(NSDictionary*)dictionary inContext:(NSManagedObjectContext*)context;

@end
