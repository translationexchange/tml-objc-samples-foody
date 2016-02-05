// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ModelMO.h instead.

@import CoreData;

extern const struct ModelMOAttributes {
	__unsafe_unretained NSString *uid;
} ModelMOAttributes;

@interface ModelMOID : NSManagedObjectID {}
@end

@interface _ModelMO : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) ModelMOID* objectID;

@property (nonatomic, strong) NSNumber* uid;

@property (atomic) int64_t uidValue;
- (int64_t)uidValue;
- (void)setUidValue:(int64_t)value_;

//- (BOOL)validateUid:(id*)value_ error:(NSError**)error_;

@end

@interface _ModelMO (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveUid;
- (void)setPrimitiveUid:(NSNumber*)value;

- (int64_t)primitiveUidValue;
- (void)setPrimitiveUidValue:(int64_t)value_;

@end
