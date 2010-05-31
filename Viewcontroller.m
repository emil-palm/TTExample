//
//  Example.h
//  
//
//  Created by Emil Palm on 31/05/2010.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Datasource.m"

@interface DCCOverviewViewController : TTTableViewController {
}
@end

@implementation DCCOverviewViewController
- (id) init {
  if(self = [super init]) {
    self.title = @"Overview";
    self.variableHeightRows = YES;
    self.tableViewStyle = UITableViewStyleGrouped;
  }
  return self;
}

- (void)createModel {
  self.dataSource = [[[Datasource alloc] init] autorelease];
}

@end
