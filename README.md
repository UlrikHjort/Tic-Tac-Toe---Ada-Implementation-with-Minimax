# Tic Tac Toe - Ada Implementation with Minimax 

 <img src="https://img.shields.io/badge/Ada-2012-blue.svg" alt="Ada 2012">
 <img src="https://img.shields.io/badge/license-MIT-green.svg" alt="MIT License">

A command-line **[Tic Tac Toe](https://en.wikipedia.org/wiki/Tic-tac-toe)** game written in Ada featuring an computer opponent opponent using the minimax algorithm with alpha-beta pruning.

## Features

- **Two Game Modes:**
  - Human vs Computer: Play against the AI
  - Computer vs Computer: Watch two AIs battle it out

- **Hint System:**
  - Toggle hints ON/OFF from the main menu
  - When enabled, shows the optimal move before you play
 

- **Configurable Computer Opponent Difficulty:**
  - Set search depth from 1 (easy) to 9 (unbeatable)
  - Depth 9 explores the complete game tree

- **Computer Opponent:**
  - Minimax algorithm with alpha-beta pruning
  - Optimal play at maximum depth
  - Instant move calculation

- **Interface:**
  - ASCII board display
  - Position guide (1-9 numbering)
  - Input validation


## Building

Compile the program using GNAT:

```bash
gnatmake tictactoe.adb

or 

./build.sh
```

## Running

Execute the compiled program:

```bash
./tictactoe
```

## How to Play

1. **Select Game Mode:**
   - Option 1: Human vs Computer (you play as X)
   - Option 2: Computer vs Computer (watch the AI play)
   - Option 3: Toggle Hints ON/OFF (shows best move)
   - Option 4: Exit

2. **Choose AI Depth:**
   - Enter a number from 1 to 9
   - Higher numbers = smarter computer opponent
   - Depth 9 = perfect play (always wins or draws)

3. **Make Your Move:**
   - If hints are enabled, the best move is suggested
   - Enter position numbers 1-9:
     ```
     1 | 2 | 3
     ---------
     4 | 5 | 6
     ---------
     7 | 8 | 9
     ```

4. **Win Conditions:**
   - Get three in a row (horizontal, vertical, or diagonal)
   - Game ends in draw if board fills with no winner

## Algorithm Details

The Computer Opponent uses the **[Minimax algorithm](https://en.wikipedia.org/wiki/Minimax)** with **[alpha-beta pruning](https://en.wikipedia.org/wiki/Alpha%E2%80%93beta_pruning)**:

- **[Minimax algorithm](https://en.wikipedia.org/wiki/Minimax)**: Explores all possible game states to find optimal moves
- **[alpha-beta pruning](https://en.wikipedia.org/wiki/Alpha%E2%80%93beta_pruning)**: Eliminates branches that won't affect the final decision
- **Depth Limiting**: Allows configurable search depth for varying difficulty

At depth 9 (full tree), the AI is unbeatable - it will never lose, only win or draw.

## Example Game

```
====================================
    TIC TAC TOE - Minimax AI
====================================

1. Human vs Computer
2. Computer vs Computer
3. Exit

Enter your choice: 1

Enter search depth (1-9, 9 = full game tree): 9

Position numbers:
-------------
|  1 |  2 |  3 | 
-------------
|  4 |  5 |  6 | 
-------------
|  7 |  8 |  9 | 
-------------

Your turn (X):
Enter position (1-9): 5
...
```

## Requirements

- GNAT Ada compiler (GCC)
- Linux/Unix environment

