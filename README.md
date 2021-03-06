RESTAURANT APP
===============

ENDPOINTS
=========
## Show menu for a venue
**GET** */menus/:id*

## Search for a venue
**GET** */venues/?name="seafood"*

## Get Venmo Id for a venue
**GET** */venues/:id/venmo*

## Show all tables for a venue
**GET** */tables/:venue_locu_id*


## Create a new table
**POST** */tables/*
    {"venue_locu_id" : "821y38912", "name" : "User1's table", "user_id" : "1" }

### Example
    curl -v -H 'Content-Type: application/json' -H 'Accept: application/json' -X POST http://localhost:3000/tables -d "{\"venue_locu_id\":\"b307b08674481c3cef22\",\"name\":\"user1_s table\",\"user_id\":\"1\"}"

## Add a user to a table
**POST** */tables/:id/users*
    {"user_id" : "1	"}
### Example
    curl -v -H 'Content-Type: application/json' -H 'Accept: application/json' -X POST http://localhost:3000/tables/3/users -d "{\"user_id\":\"2\"}"

## Show all table items for a table
**GET** /tableitems/:table_id

## Create a new table item
**POST** /tableitems
    {table_item: {table_id : ,item_name : ,quantity :, price : }} 

###Example
    curl -v -H 'Content-Type: application/json' -H 'Accept: application/json' -X POST http://localhost:3000/tableitems -d "{\"table_item\":{\"table_id\":\"1\",\"item_name\":\"Long Star BBQ\",\"quantity\":\"1\",\"price\":\"5.95\"}}"

## Update quantity for a tableitem
**POST** /tableitems/quantity
    {id: , quantity: }
###Example
    POST http://localhost:3000/tableitems/quantity -d "{\"id\":\"1\",\"quantity\":\"1\"}"

## Pay for items
**POST** /tableitems/pay
    {user_id : , items : [Array of table_item ids] }

## Delete an app
**DELETE** /tableitems/:id

###Example
    curl -v -H 'Content-Type: application/json' -H 'Accept: application/json' -X DELETE http://localhost:3000/tableitems/1
    

# User workflow
## Version 1.0
 1. User logs in.
 2. User selects a restaurant among the "nearby" restaurants that have
menus on Locu.
 3. User either creates a new table or joins an existing table in the
restaurant. Creating a new table will involve:
 * Creating the name for the table.
 * Selecting how many people you expect
The table creator can remove any people that joined the table when they
should not have.
 4. Each user can then see the menu
## Version 2.0
 5. Users can select menu items and opt to pay for them
 6. Users can customize the location where they are looking for restaurants.
