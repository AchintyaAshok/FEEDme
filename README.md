RESTAURANT APP
===============

ENDPOINTS
=========
**GET** */menus/:id*

**GET** */venues/?name="seafood"*

**GET** */tables/:venue_locu_id*
### Show all tables for a venue

**POST** */tables/*
{"venue_locu_id" : "821y38912", "name" : "User1's table", "user_id" : "1" }
### Create a new table
## Example
    curl -v -H 'Content-Type: application/json' -H 'Accept: application/json' -X POST http://localhost:3000/tables -d "{\"venue_locu_id\":\"b307b08674481c3cef22\",\"name\":\"user1_s table\",\"user_id\":\"1\"}"

**POST** */tables/:id/users*
{"user_id" : "1	"}
### Example
    curl -v -H 'Content-Type: application/json' -H 'Accept: application/json' -X POST http://localhost:3000/tables/3/users -d "{\"user_id\":\"2\"}"

### Add a user to a table

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

# API Keys
Web API key: c441cb7b1b3f83a2644a6bc573dd8ebf3e9a1afb

iOS Client API Key: 5b8f8851e556f62af88df2235eeefcba3ba6d236
