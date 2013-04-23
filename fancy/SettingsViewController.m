//
//  SettingsViewController.m
//  fancy
//
//  Created by shaoxinjiang on 1/22/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import "SettingsViewController.h"
#import "Model/Settings.h"
#import "XJWebviewControllerViewController.h"
@interface SettingsViewController ()

@end

@implementation SettingsViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[Settings shared] save];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // change background
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
    self.tableView.backgroundColor = [UIColor clearColor];
   // get some info
    self.saveToAlbum = [[NSUserDefaults standardUserDefaults] integerForKey:@"saveToAlbum"];
//    if (nil == [[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]) {
//        [[NSUserDefaults standardUserDefaults] setObject:@"English" forKey:@"lang"];
//    }
//    self.lang = [[NSUserDefaults standardUserDefaults] integerForKey:@"lang"];
    //[self.tableView setSeparatorColor:[UIColor clearColor]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView
                       cellForRowAtIndexPath:indexPath];
    
    
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    //NSLog(@"section = %@, row = %@", (unsigned int)section, (unsigned int)row );
    switch (section)
    {
        case 0:
            if (row == self.saveToAlbum)
            {
                //Get Setting here
                
                self.saveSwitch.on = [Settings isSaveToAlbum];
               
            }
            break;
        case 1:
            if ( 2 == row){
                NSLog(@"Set Up author Link");
            }else if( 3 ==  row){
                NSLog(@"Set Up app Link");
            }
            
            break;
    }
        

    return cell;
}
- (IBAction)switchToggled:(UISwitch *)sender
{
    //NSLog(@"Switched Toggle = %@", sender);
    Settings *settings = [Settings shared];
    [settings setSaveToAlbum:[NSNumber numberWithBool:sender.on]];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    switch (section) {
        case 0:
            if (row == self.lang ) {
                NSLog(@"lang = %lu", (unsigned long)self.lang);
            }
            break;
        case 1:
            if ( 2 == row){
                NSLog(@"Called  author Link");
                XJWebviewControllerViewController *xjwebcontroller = [[XJWebviewControllerViewController alloc] initWithText:@"http://shaosidea.com"];
                [self.navigationController pushViewController:xjwebcontroller animated:YES];
            }else if( 3 ==  row){
                NSLog(@"Called app Link");
                XJWebviewControllerViewController *xjwebcontroller = [[XJWebviewControllerViewController alloc] initWithText:@"http://shaosidea.com/fancy"];
                [self.navigationController pushViewController:xjwebcontroller animated:YES];
            }else if( 4 == row){
               
                [TestFlight openFeedbackView];
                
            }
            
            break;

        default:
            break;
    }
    
    [self.tableView reloadData];
    
}

@end
