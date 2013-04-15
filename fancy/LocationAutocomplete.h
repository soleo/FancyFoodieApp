//
//  LocationAutocomplete.h
//  fancy
//
//  Created by Xinjiang Shao on 4/15/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TRAutocompleteItemsSource;
@protocol TRAutocompletionCellFactory;
@protocol TRSuggestionItem;

@interface LocationAutocomplete : NSObject

@property(readonly) id <TRSuggestionItem> selectedSuggestion;
@property(readonly) NSArray *suggestions;
@property(nonatomic) UIColor *separatorColor;
@property(nonatomic) UITableViewCellSeparatorStyle separatorStyle;

@property(nonatomic) CGFloat topMargin;

@property(copy) void (^didAutocompleteWith)(id <TRSuggestionItem>);


@end
