
#import "Dao.h"


@implementation Dao {
}

/**
 * Designated initializer.
 */
- (id) initWithManagedObjectContext:(NSManagedObjectContext *) managedObjectContext; {
    self = [super init];
    if (self != nil){
        _managedObjectContext = managedObjectContext;
    }
    return self;
}

/**
 * Save changes to the context.
 */
-(void) saveContext {
    if (self.managedObjectContext) {
        NSError *error;
        if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {  // TODO: EXC_BAD_ACCESS
            NSLog(@"Error saving %@ %@, %@, %@", [self class], error, [error userInfo],[error localizedDescription]);
        }
    }
	
}

-(NSString *) describe:(NSManagedObject *) mObj {
	NSString *result;
	if ( [mObj respondsToSelector: @selector(describe)] ) {
		result = [mObj performSelector:@selector(describe)]; 
    } else {
		result = [NSString stringWithFormat: @"%@[objectId=%@, ...]", [[mObj entity]name], [mObj objectID] ];
	}	
	return result;
}


-(NSArray*) objectsOfEntityName:(NSString*) entity {
	// batch=0 disables batching 
	return [self objectsOfEntityName:entity withBatchSize:0];  
}


-(int) count:(NSString*) entity {
	int i = [[self objectsOfEntityName:entity withBatchSize:0] count];

	return i;
}


-(void) dump:(NSString*) entity {
	NSMutableString *string = [NSMutableString stringWithFormat:@""];
	NSArray *array = [self objectsOfEntityName:entity withBatchSize:0];
	for (NSUInteger i = 0; i < [array count]; i++) {
		NSObject *obj = [array objectAtIndex:i];
		if ([obj respondsToSelector:@selector(longDescribe)]) {
		    [string appendString:[obj performSelector:@selector(longDescribe)] ];
		} else if ([obj respondsToSelector:@selector(describe)]) {
			[string appendString:[obj performSelector:@selector(describe)]];
		} else {
			[string appendFormat:@"%@ has no describe method.", [self class]];
		}
	}
}


-(NSArray*) objectsOfEntityName:(NSString*)entity withBatchSize:(NSInteger)size {
	// create request
	NSEntityDescription *entDesc = [NSEntityDescription entityForName:entity
											   inManagedObjectContext:self.managedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:entDesc];
	
	if (size){
		[fetchRequest setFetchBatchSize:size];
	}
	
	// execute request
	NSError *error;
	NSArray *fetchResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
	// clean up
	if(fetchResults == nil) {
	}
    
	return fetchResults;
}

	
-(NSArray*)objectsOfEntityName:(NSString*)name 
           withPredicate:(NSPredicate*)predicate {
	// batch=0 disables batching 
    return [self objectsOfEntityName:name withPredicate:predicate andBatchSize:0];  
}
	

// TODO: crashing because its being called from multiple threads using the same context

-(NSArray*)objectsOfEntityName:(NSString*)name 
		   withPredicate:(NSPredicate*)predicate
				 andBatchSize:(NSInteger)size {
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init]; 
	[fetchRequest setEntity:[NSEntityDescription entityForName:name
										inManagedObjectContext:self.managedObjectContext]];
	if (predicate){
        [fetchRequest setPredicate:predicate];
	}
	if (size){
	    [fetchRequest setFetchBatchSize:size];
	}
    
    NSError *error = nil; 	
	NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];  // TODO: EXC_BAD_ACCESS, collection mutated while being enumerated
	fetchRequest = nil;
	
	if (error) { 
		NSLog(@"%@:%s Error on fetch %@", [self class], _cmd, error);
		return nil;
	} 
	return results;
}


-(void) removeAllByClassName:(NSString*) name {
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *desc = [NSEntityDescription entityForName:name inManagedObjectContext:self.managedObjectContext];

	[fetchRequest setEntity:desc];
	
	NSError *error = nil;
	NSArray *managedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	
	for (NSManagedObject *managedObject in managedObjects) {
		[self.managedObjectContext deleteObject:managedObject];
		// debug
		if ([managedObject respondsToSelector:@selector(describe)] == YES) {
			NSLog(@"Deleting: %@", [managedObject performSelector:@selector(shortDescribe)]);
		} else {
			NSLog(@"Deleting: %@", managedObject);
		}
	}
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error saving changes: %@", error);
    }
}


-(void) remove:(NSManagedObject*) objectToRemove { 
	[self.managedObjectContext deleteObject:objectToRemove];
	
	NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error saving changes: %@", error);
    }
}


@end
