//
//  SecureMappingKitTests.m
//  SecureMappingKitTests
//
//  Created by Jerome Morissard on 5/4/14.
//  Copyright (c) 2014 Jerome Morissard. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JMOnePerson.h"
#import "NSDictionary+SecureMappingKit.h"

@interface SecureMappingKitTests : XCTestCase

@end

@implementation SecureMappingKitTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/*
- (void)test1
{
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"webservice.response.1"
                                                         ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data
                                              options:kNilOptions
                                                error:&error];
    
    NSDictionary *dict = [json firstObject];
    JMOnePerson *person = [JMOnePerson new];
    [person setupWithDictionary:dict];
    XCTAssertEqualObjects(person.identifier, @"0", @"Should have matched");
    XCTAssertEqual(person.isActive, NO, @"Should have matched");
    XCTAssertEqualWithAccuracy(person.balance, 1508.63, 0.001,@"Should have matched");
}

- (void)test2
{
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"webservice.response.2"
                                                         ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data
                                              options:kNilOptions
                                                error:&error];
    
    NSDictionary *dict = [json firstObject];
    JMOnePerson *person = [JMOnePerson new];
    [person setupWithDictionary:dict];
    
    XCTAssertEqualObjects(person.identifier, @"1", @"Should have matched");
    XCTAssertEqual(person.isActive, NO, @"Should have matched");
    XCTAssertEqualWithAccuracy(person.balance, 2633.59,0.001, @"Should have matched");
}

*/
- (void)testBoolValueTransformer
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:@"false" forKey:@"isActiveString"];
    [dict setObject:@"1" forKey:@"isActiveStringV2"];
    [dict setObject:@(NO) forKey:@"isActiveNumber"];
    
    id bValue = [dict objectForKey:@"isActiveString" expectedClass:[NSNumber class] withTransformerClass:NSBooleanNumberTransformer.class];
    XCTAssertEqual(bValue, @(NO), @"Should have matched");
    
    bValue = [dict objectForKey:@"isActiveStringV2" expectedClass:[NSNumber class] withTransformerClass:NSBooleanNumberTransformer.class];
    XCTAssertEqual([bValue boolValue], [@(YES) boolValue], @"Should have matched");
    
    bValue = [dict objectForKey:@"isActiveNumber" expectedClass:[NSNumber class] withTransformerClass:NSBooleanNumberTransformer.class];
    XCTAssertEqual(bValue, @(NO), @"Should have matched");
}

- (void)testNumberValueTransformers
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:@"12345" forKey:@"id"];

    id identifier = [dict objectForKey:@"id" expectedClass:[NSNumber class]];
    XCTAssertEqualObjects(identifier, @(12345), @"Should have matched");
}

- (void)testURLValueTransformers
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:@"http://www.google.fr" forKey:@"url"];
    
    id url = [dict objectForKey:@"url" expectedClass:[NSURL class]];
    XCTAssertEqualObjects(url, [NSURL URLWithString:@"http://www.google.fr"], @"Should have matched");
    
    id transformedValue = [dict objectForKey:@"url" withTransformerBlock:^id(id value) {
        if ([value isKindOfClass:[NSURL class]]) {
            return value;
        }
        if ([value isKindOfClass:[NSString class]]) {
            return [NSURL URLWithString:value];
        }
        return nil;
    }];
    XCTAssertEqualObjects(transformedValue, [NSURL URLWithString:@"http://www.google.fr"], @"Should have matched");
}

- (void)testDecimalValueTransformers
{
    NSString *decimalWithPoint = @"1800.98";
    NSString *decimalWithComa = @"1800,98";
    NSNumber *number = @(1800.98f);
    NSDecimalNumber *d = [[NSDecimalNumber alloc] initWithDecimal:[@(1800.98f) decimalValue]];

    /**
     *  Validate NSDecimalNumberTransformerWithDecimalSeparatorPoint
     */
    NSDictionary *testDict = @{@"balance": decimalWithPoint};
    id result = [testDict objectForKey:@"balance" expectedClass:NSDecimalNumber.class withTransformerClass:NSDecimalNumberTransformerWithDecimalSeparatorPoint.class];
    XCTAssertEqualObjects(result,d, @"Should have matched");

    /**
     *  Validate NSDecimalNumberTransformerWithDecimalSeparatorComa
     */
    testDict = @{@"balance": decimalWithComa};
    result = [testDict objectForKey:@"balance" expectedClass:NSDecimalNumber.class withTransformerClass:NSDecimalNumberTransformerWithDecimalSeparatorComa.class];
    XCTAssertEqualObjects(result,d, @"Should have matched");

    /**
     *  Validate NSDecimalNumberTransformer
     */
    testDict = @{@"balance": number};
    result = [testDict objectForKey:@"balance" expectedClass:NSDecimalNumber.class withTransformerClass:NSDecimalNumberTransformer.class];
    XCTAssertEqualObjects(result,d, @"Should have matched");
    
    testDict = @{@"balance": decimalWithComa};
    result = [testDict objectForKey:@"balance" expectedClass:NSDecimalNumber.class withTransformerClass:NSDecimalNumberTransformer.class];
    XCTAssertEqualObjects(result,d, @"Should have matched");
    
    testDict = @{@"balance": decimalWithPoint};
    result = [testDict objectForKey:@"balance" expectedClass:NSDecimalNumber.class withTransformerClass:NSDecimalNumberTransformer.class];
    XCTAssertEqualObjects(result,d, @"Should have matched");
}

@end
