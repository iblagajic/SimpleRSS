#import "SMLItem.h"


@interface SMLItem ()

// Private interface goes here.

@end


@implementation SMLItem

+ (void)insertItemWithDictionary:(NSDictionary*)dictionary inContext:(NSManagedObjectContext*)context {
    
    SMLItem *item = [SMLItem insertInManagedObjectContext:context];
    item.title = [[[dictionary objectForKey:@"title"] stringByConvertingHTMLToPlainText] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    item.text = [[dictionary objectForKey:@"description"] stringByConvertingHTMLToPlainText];
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"ccc, d MMM yyyy H:m:s Z"];
    NSDate *date = [dateFormat dateFromString:[dictionary objectForKey:@"pubDate"]];
    if (!date) {
        [dateFormat setDateFormat:@"ccc, d MMM yyyy H:m:s z"];
        date = [dateFormat dateFromString:[dictionary objectForKey:@"pubDate"]];
    }
    item.pubDate = date;
    item.link = [dictionary objectForKey:@"link"];
    item.feed = [dictionary objectForKey:@"feed"];
}

+ (NSArray*)arrayOfExistingItemsForTitles:(NSArray*)titles inContext:(NSManagedObjectContext*)context {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity: [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:context]];
    [fetchRequest setPredicate: [NSPredicate predicateWithFormat: @"(title IN %@)", titles]];
    
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]]];
    NSError *error;
    NSArray *uniqueTitles = [context executeFetchRequest:fetchRequest error:&error];
    return uniqueTitles;
}

@end
