//
//  FoodieListViewController.m
//  fancy
//
//  Created by shaoxinjiang on 1/20/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import "FoodieListViewController.h"
#import "Model/Events.h"
#import "Model/Tag.h"
#import "FoodieListCell.h"
#import "FoodieDetailViewController.h"
#import "ThirdParty/FontAwesome/NSString+FontAwesome.h"
#import "ThirdParty/FontAwesome/UIFont+FontAwesome.h"
#import "ThirdParty/SORelativeDateTransformer/SORelativeDateTransformer.h"
#import "ThirdParty/BButton/BButton.h"
#import "ThirdParty/BButton/BButton+FontAwesome.h"
#import "NSStringHelper.h"
#import "aEvent.h"

@interface FoodieListViewController ()
- (NSManagedObjectContext *)managedObjectContext;
@property (nonatomic,strong) NSMutableArray *tagsArray;
@end

@implementation FoodieListViewController


- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    //[[UILabel appearance] setFont:[UIFont fontWithName:@"DroidSans" size:14.0]];
    self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.contentInset = inset;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Events" ];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate"
                                                                   ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    self.events = [[context executeFetchRequest:fetchRequest  error:nil] mutableCopy];
    //NSLog(@"events array %@", self.events);
    
    [self.tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return self.events.count;
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:[self tableView] numberOfRowsInSection:0];
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (rowIndex == 0) {
        background = [UIImage imageNamed:@"cell_top"];
    } else if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"cell_bottom"];
    } else {
        background = [UIImage imageNamed:@"cell_middle"];
    }
    
    return background;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FoodieListCell";
    FoodieListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    if (cell == nil) {
        cell = [[FoodieListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // style change for elements in table view
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // data set
    Events *event = [self.events objectAtIndex:indexPath.row];
    NSLog(@"date: %@, loc: %@",[event valueForKey:@"creationDate"], [event valueForKey:@"locationName"]);
    
    
    SORelativeDateTransformer *relativeDateTransformer = [[SORelativeDateTransformer alloc] init];
    NSString *relativeDate = [relativeDateTransformer transformedValue:[event valueForKey:@"creationDate"]];
    NSMutableAttributedString *dateWithIcon = [NSString stringWithFontAwesomeIcon:@"icon-time" withTextContent:relativeDate];
    [cell.dateLabel setAttributedText:dateWithIcon];
    
    NSString *location = [event valueForKey:@"locationName"];
    if ([NSString isEmpty:location]) {
        [cell.locationLabel setText:@"Not Provided"];
        NSLog(@"Not Provided");
    }else{
        [cell.locationLabel setAttributedText:[NSString stringWithFontAwesomeIcon:@"icon-food" withTextContent:location]];
    }
    [cell.menuButton makeAwesomeWithIcon:FAIconShareAlt];
    [cell.menuButton setType:BButtonTypeSuccess];
    //[cell setupMenuInCell];
    [cell setupMenuInCellWithComment:[event valueForKey:@"comment"]
                        andWithPhoto:(UIImage *)[event valueForKey:@"thumbnail"]
                        andWithEvent:event
               presentViewController:self];
    //NSManagedObject *photoBlob = [event valueForKey:@"photoBlob"];
    //UIImage *image = [UIImage imageWithData:[photoBlob valueForKey:@"bytes"]];
    //cell.photoView.image = image;
    UIImage *thumbnail = [UIImage imageWithData:[event valueForKey:@"thumbnail"]];
    cell.photoView.image = thumbnail;
    // more to show on the table
    //get Tags Array
    //[self fetchTagsArray];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [context deleteObject:[self.events objectAtIndex:indexPath.row]];
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't delete! %@ %@", error, [error description]);
            return ;
        }
        [self.events removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Segue method
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetailSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        FoodieDetailViewController *destViewController = segue.destinationViewController;
        Events *event = [self.events objectAtIndex:indexPath.row];
        aEvent *passEvent = [aEvent new];
        passEvent.place = [event valueForKey:@"locationName"];
        passEvent.photo = [[event valueForKey:@"photoBlob"] valueForKey:@"bytes"];
        passEvent.publishDate = [event valueForKey:@"creationDate"];
        passEvent.comment = [event valueForKey:@"comment"];
        passEvent.otherplace = [event valueForKey:@"address"];
        passEvent.rate = [event valueForKey:@"rate"];
        //NSSet *tempTags = [event valueForKey:@"tags"];
        NSMutableArray *eventTagNames = [NSMutableArray array];
        for (Tag *tag in event.tags) {
            [eventTagNames addObject:tag.label];
        }
        
        NSString *tagsString = @"";
        if ([eventTagNames count] > 0) {
            tagsString = [eventTagNames componentsJoinedByString:@", "];
        }
        passEvent.tags = tagsString;
        NSLog(@"tags = %@", passEvent.tags);
        destViewController.event = passEvent;
    }
}


@end
