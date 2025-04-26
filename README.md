## 🎲🎩💳 Project Overview

This project implements a relational database system for the "University Tycoon" board game using SQLite. The database tracks game state, player moves, and enforces game rules through SQL triggers. Players move around the board, buy university buildings, charge tuition fees, and interact with special spaces that can award or deduct credits.


## Game Description

University Tycoon is a board game where players move around a board representing a university campus. The objective is to collect as many credits as possible by:
- Buying university buildings
- Charging tuition fees to other players who land on your buildings
- Collecting credits from special spaces (like RAG events)
- Avoiding penalties (like hearings or suspension)

The game simulates the experience of university life with academic, financial, and social elements integrated into the gameplay.

## Game Board Map

![University Tycoon](https://github.com/user-attachments/assets/b5c48394-d7b5-403d-8658-add5e9e8e6a5)

The University Tycoon game is played on a board with 20 spaces arranged in a square. Players move clockwise around the board starting from "Welcome Week" (Space 1). The board includes:

- **Buildings (purchasable spaces):**
  - Green (Triangle): Kilburn (2), IT (3) - 15cr tuition fee, 30cr price
  - Orange (Square): Uni Place (5), AMBS (6) - 25cr tuition fee, 50cr price
  - Blue (Circle): Crawford (9), Sugden (10) - 30cr tuition fee, 60cr price
  - Brown (Diamond): Shopping Precinct (12), MECD (13) - 35cr tuition fee, 70cr price
  - Grey (Cross): Library (15), Sam Alex (16) - 40cr tuition fee, 80cr price
  - Black (Ring): Museum (19), Whitworth Hall (20) - 50cr tuition fee, 100cr price

- **Special spaces:**
  - Welcome Week (1): Awarded 100cr when landing on or passing
  - Hearing 1 (4): Fined 20cr for academic malpractice
  - RAG 1 (7): Awarded 15cr for winning a fancy dress competition
  - Visitor/Suspension (8): Either visiting or serving suspension
  - Ali G (11): Free resting space
  - RAG 2 (14): Give all other players 10cr (bursary sharing)
  - Hearing 2 (17): Fined 25cr for rent arrears
  - You're Suspended (18): Player is moved to Suspension (space 8)

The board features a high-contrast color scheme with associated shapes for accessibility. Player tokens appear on the inside edge of spaces to indicate their location, and in the top-right corner of building spaces to indicate ownership.## Game Board Map

## Database Structure

### Entity Relationship Diagram

![ER Diagram](https://github.com/user-attachments/assets/1cfe91ab-1a98-4b53-b825-5ab51648b13a)

The ER diagram above shows the relationships between the entities in the University Tycoon database:
- **Player**: Contains player information including credit balance and suspension status
- **Token**: Represents the game pieces that players choose
- **Building**: University buildings that can be purchased and owned by players
- **Special**: Special spaces on the board with unique effects
- **Space**: Represents locations on the board, linked to either a building or a special
- **Audit Log**: Records all game moves and tracks state changes including the did_roll_six attribute

Key relationships:
- Players choose Tokens
- Players land in Spaces
- Players can be owners of Buildings
- Spaces store information of either Buildings or Special locations
- Audit Log records the current state of Players during gameplay
- Spaces are recorded in the Audit Log during moves

The diagram uses crow's foot notation to represent relationship cardinalities between entities.

### Views

- **leaderboard**
  - Shows player statistics including name, current location, credit balance, owned buildings, and net worth
  - Displays players in order of net worth (highest at the top)
  - Formats building names and locations in snake_case (lowercase with underscores)

### Triggers

Multiple triggers are implemented to enforce game rules and handle gameplay events:

- **past_welcome_week** - Awards 100 credits when a player passes Welcome Week
- **buying_building** - Handles building purchases
- **get_fined** - Handles tuition fee payments
- **roll_six** - Manages rolling a 6
- **rag_1**, **rag_2** - Handle RAG events
- **hearing_1**, **hearing_2** - Handle Hearing penalties
- And more...

## Game Mechanics

The database implements core game rules through SQL triggers that automatically execute when specific conditions are met:

1. **Movement and Locations**: Players move clockwise around the board based on dice rolls
2. **Building Acquisition**: Players can buy unowned buildings they land on
3. **Tuition Fees**: Players pay fees when landing on buildings owned by others
4. **Special Spaces**: Effects triggered when landing on special locations
5. **Suspension System**: Handles player suspension and requirements to get unsuspended
6. **Audit Trail**: All game moves are tracked for reference and verification

## Files in this Project

- **create.sql**: Creates the database schema (tables, constraints, and triggers)
- **populate.sql**: Populates the database with initial game state data
- **view.sql**: Creates the leaderboard view
- **q1.sql - q8.sql**: SQL queries that simulate game moves:
  - q1-q4: Round 1 moves
  - q5-q8: Round 2 moves

## Game Rules

1. Play moves in a clockwise direction with players rolling a dice to determine movement
2. If a player lands on a building without an owner, they must buy it from the university
3. If player P lands on a building owned by player Q, P pays Q the tuition fee
4. If Q owns all buildings of a particular color, P pays double the tuition fee
5. Suspended players must roll a 6 to get out and immediately roll again
6. Players receive 100 credits when passing Welcome Week
7. Rolling a 6 gives players another turn; the space they land on has no effect
8. Landing on "You're Suspended!" moves the player to Suspension without passing Welcome Week
9. RAG and Hearing spaces trigger special events described on their cards
10. Landing on Suspension while not suspended results in "Visiting" status with no effect

## Initial Game State

The initial game state includes:

- 4 players: Gareth, Uli, Pradyumn, and Ruth
- Starting credits: Gareth (345), Uli (590), Pradyumn (465), Ruth (360)
- Each player has a unique token: Certificate, Mortarboard, Book, and Pen respectively
- Some buildings are already owned by players
- Players are positioned at different locations on the board

## Implementation Notes

- SQLite does not support stored procedures, so game logic is implemented using triggers
- Foreign key constraints maintain data integrity throughout the system
- The audit_log table provides a complete history of all game actions
- The leaderboard view offers real-time standings based on credits and property values
- Game state is modified through INSERT statements to the audit_log table, which trigger the appropriate game logic

## Usage Instructions

To use this database:

1. Create the database structure using the create.sql file
2. Populate the initial game state with populate.sql
3. Create the leaderboard view with view.sql
4. Execute game moves in sequence using the q1.sql through q8.sql files
5. View the leaderboard at any time by querying the leaderboard view
