//
//  LocationAutocomplete.m
//  fancy
//
//  Created by Xinjiang Shao on 4/15/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import "LocationAutocomplete.h"
#import "TRAutocompleteItemsSource.h"
#import "TRAutocompletionCellFactory.h"

@interface LocationAutocomplete () <UITableViewDelegate, UITableViewDataSource>

@property(readwrite) id <TRSuggestionItem> selectedSuggestion;
@property(readwrite) NSArray *suggestions;


@end

@implementation LocationAutocomplete
//{
//    BOOL _visible;
//    
//    //__weak UITextField *_queryTextField;
//    __weak UIViewController *_contextController;
//    NSString *_queryString;
//    UITableView *_table;
//    id <TRAutocompleteItemsSource> _itemsSource;
//    id <TRAutocompletionCellFactory> _cellFactory;
//}
//
//+ (LocationAutocomplete *)autocompleteWithQueryString:(NSString *)queryString
//                                     usingSource:(id <TRAutocompleteItemsSource>)itemsSource
//                                     cellFactory:(id <TRAutocompletionCellFactory>)factory
//                                    presentingIn:(UIViewController *)controller
//{
//    return [[LocationAutocomplete alloc] initWithQueryString:queryString
//                                        itemsSource:itemsSource
//                                         cellFactory:factory
//                                          controller:controller];
//}
//
//- (id)initWithQueryString:(NSString *)queryString
//        itemsSource:(id <TRAutocompleteItemsSource>)itemsSource
//        cellFactory:(id <TRAutocompletionCellFactory>)factory
//         controller:(UIViewController *)controller
//{
//    self = [super init];
//    if (self)
//    {
//        [self loadDefaults];
//        
//        _queryString = queryString;
//        _itemsSource = itemsSource;
//        _cellFactory = factory;
//        _contextController = controller;
//        
//        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        _table.backgroundColor = [UIColor clearColor];
//        _table.separatorColor = self.separatorColor;
//        _table.separatorStyle = self.separatorStyle;
//        _table.delegate = self;
//        _table.dataSource = self;
//        
//        [[NSNotificationCenter defaultCenter]
//         addObserver:self
//         selector:@selector(queryChanged:)
//         name:UITextFieldTextDidChangeNotification
//         object:_queryString];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(keyboardWasShown:)
//                                                     name:UIKeyboardDidShowNotification
//                                                   object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(keyboardWillHide:)
//                                                     name:UIKeyboardWillHideNotification
//                                                   object:nil];
//        
//        [self addSubview:_table];
//    }
//    
//    return self;
//}
//
//- (void)loadDefaults
//{
//    self.backgroundColor = [UIColor whiteColor];
//    
//    self.separatorColor = [UIColor lightGrayColor];
//    self.separatorStyle = UITableViewCellSeparatorStyleNone;
//    
//    self.topMargin = 0;
//}
//
//- (void)keyboardWasShown:(NSNotification *)notification
//{
//    NSDictionary *info = [notification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    
//    CGFloat contextViewHeight = 0;
//    CGFloat kbHeight = 0;
//    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
//    {
//        contextViewHeight = _contextController.view.frame.size.height;
//        kbHeight = kbSize.height;
//    }
//    else if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
//    {
//        contextViewHeight = _contextController.view.frame.size.width;
//        kbHeight = kbSize.width;
//    }
//    
//    CGFloat calculatedY = _queryTextField.frame.origin.y + _queryTextField.frame.size.height + self.topMargin;
//    CGFloat calculatedHeight = contextViewHeight - calculatedY - kbHeight;
//    
//    calculatedHeight += _contextController.tabBarController.tabBar.frame.size.height; //keyboard is shown over it, need to compensate
//    
//    self.frame = CGRectMake(_queryTextField.frame.origin.x,
//                            calculatedY,
//                            _queryTextField.frame.size.width,
//                            calculatedHeight);
//    _table.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//}
//
//- (void)keyboardWillHide:(NSNotification *)notification
//{
//    [self removeFromSuperview];
//    _visible = NO;
//}
//
//- (void)queryChanged:(id)sender
//{
//    if ([_queryTextField.text length] >= _itemsSource.minimumCharactersToTrigger)
//    {
//        [_itemsSource itemsFor:_queryTextField.text whenReady:
//         ^(NSArray *suggestions)
//         {
//             if (_queryTextField.text.length
//                 < _itemsSource.minimumCharactersToTrigger)
//             {
//                 self.suggestions = nil;
//                 [_table reloadData];
//             }
//             else
//             {
//                 self.suggestions = suggestions;
//                 [_table reloadData];
//                 
//                 if (self.suggestions.count > 0 && !_visible)
//                 {
//                     [_contextController.view addSubview:self];
//                     _visible = YES;
//                 }
//             }
//         }];
//    }
//    else
//    {
//        self.suggestions = nil;
//        [_table reloadData];
//    }
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.suggestions.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *identifier = @"TRAutocompleteCell";
//    
//    id cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil)
//        cell = [_cellFactory createReusableCellWithIdentifier:identifier];
//    
//    NSAssert([cell isKindOfClass:[UITableViewCell class]], @"Cell must inherit from UITableViewCell");
//    NSAssert([cell conformsToProtocol:@protocol(TRAutocompletionCell)], @"Cell must conform TRAutocompletionCell");
//    UITableViewCell <TRAutocompletionCell> *completionCell = (UITableViewCell <TRAutocompletionCell> *) cell;
//    
//    id suggestion = self.suggestions[(NSUInteger) indexPath.row];
//    NSAssert([suggestion conformsToProtocol:@protocol(TRSuggestionItem)], @"Suggestion item must conform TRSuggestionItem");
//    id <TRSuggestionItem> suggestionItem = (id <TRSuggestionItem>) suggestion;
//    
//    [completionCell updateWith:suggestionItem];
//    
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    id suggestion = self.suggestions[(NSUInteger) indexPath.row];
//    NSAssert([suggestion conformsToProtocol:@protocol(TRSuggestionItem)], @"Suggestion item must conform TRSuggestionItem");
//    
//    self.selectedSuggestion = (id <TRSuggestionItem>) suggestion;
//    
//    _queryTextField.text = self.selectedSuggestion.completionText;
//    [_queryTextField resignFirstResponder];
//    
//    if (self.didAutocompleteWith)
//        self.didAutocompleteWith(self.selectedSuggestion);
//}
//
//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter]
//     removeObserver:self
//     name:UITextFieldTextDidChangeNotification
//     object:nil];
//    [[NSNotificationCenter defaultCenter]
//     removeObserver:self
//     name:UIKeyboardDidShowNotification
//     object:nil];
//    [[NSNotificationCenter defaultCenter]
//     removeObserver:self
//     name:UIKeyboardWillHideNotification
//     object:nil];
//}
//
//

@end
