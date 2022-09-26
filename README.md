# Food-Oder-App
![food-order-image](https://mhuynh.dev/assets/Food_Order_App_SS.png)

## What it does
Food Order App will display today's menu. User can add an item to cart and check out.

## How I built it
* I started by getting user's location, then draw a view for displaying menu, with search features.
* I also construct a slide out menu, this is helpful when I decide to add more features such as viewing account, order history, help center, etc.
* Later, I added Firebase to retrieve menu and take orders.

## Challenges I ran into
* Searching requires me to store another set of items, and when I did not update the searched items correctly, program will crash
* Calculating the total required a bit of work, I sometimes mistaken between items and filtered items (from search)
* Could not build the app after installing pod

## Accomplishments that I am proud of
Calculating the total

## What I learned
After install pod, I need to open the newly generated .xcworkspace for the app to compile

## What's next
* Calculate the total on server side
* Implement Stripe API to take payments

## Built With
swift swiftui
