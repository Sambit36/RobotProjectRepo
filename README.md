Instruction for file:
file name: Test/Assignment.robot
Locator file: Locators/AmazonLocators.json
Datafile: Data.json
 
Framework Used:
1. Robot framework
2. Selenium library
3. json and string library

Instructions for reportlog file:
1.Opens brwoser, checks for title
2.seraches for amazon and gets all the links
3.Enters into amazon site and logs in with creadential
4.Filters for Electronics and Dell computers
5.In Dell computers again filter for the price range 30k to 50k
6.Gets all the elements price satisfies with condition for 1st pagination and also prints rating
7.Switches window for the product of 5 rating and adds to wishlist for 1st product by crearing new wishlist
8.Validation of added wishlist
9.Switches back to filtered price window, validates and prints for 2nd pagination products price and ratings

Assumptions:
1.Amazon Account is registered and verification is done
2.wishlist is empty before running script
