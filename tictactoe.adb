-- ***************************************************************************
--                        Tic Tac Toe
--
--           Copyright (C) 2026 By Ulrik Hørlyk Hjort
--
-- Permission is hereby granted, free of charge, to any person obtaining
-- a copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, sublicense, and/or sell copies of the Software, and to
-- permit persons to whom the Software is furnished to do so, subject to
-- the following conditions:
--
-- The above copyright notice and this permission notice shall be
-- included in all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-- NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
-- LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
-- OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
-- WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
-- ***************************************************************************
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure TicTacToe is

   type Cell is (Empty, X, O);
   type Board is array (1 .. 3, 1 .. 3) of Cell;
   type Game_Mode is (Human_Vs_Computer, Computer_Vs_Computer);
   
   type Move is record
      Row : Integer;
      Col : Integer;
   end record;
   
   Max_Depth : Integer := 9;
   Current_Mode : Game_Mode;
   Show_Hints : Boolean := False;
   
   -- Display the board
   procedure Display_Board (B : Board) is
      function Cell_To_String (C : Cell) return String is
      begin
         case C is
            when Empty => return " ";
            when X     => return "X";
            when O     => return "O";
         end case;
      end Cell_To_String;
   begin
      Put_Line ("-------------");
      for Row in 1 .. 3 loop
         Put ("| ");
         for Col in 1 .. 3 loop
            Put (Cell_To_String (B (Row, Col)));
            Put (" | ");
         end loop;
         New_Line;
         Put_Line ("-------------");
      end loop;
      New_Line;
   end Display_Board;
   
   -- Display board with position numbers
   procedure Display_Board_Help is
   begin
      Put_Line ("Position numbers:");
      Put_Line ("-------------");
      for Row in 1 .. 3 loop
         Put ("| ");
         for Col in 1 .. 3 loop
            Put (Integer'Image ((Row - 1) * 3 + Col));
            Put (" | ");
         end loop;
         New_Line;
         Put_Line ("-------------");
      end loop;
      New_Line;
   end Display_Board_Help;
   
   -- Check if a player has won
   function Check_Winner (B : Board; Player : Cell) return Boolean is
   begin
      -- Check rows
      for Row in 1 .. 3 loop
         if B (Row, 1) = Player and B (Row, 2) = Player and B (Row, 3) = Player then
            return True;
         end if;
      end loop;
      
      -- Check columns
      for Col in 1 .. 3 loop
         if B (1, Col) = Player and B (2, Col) = Player and B (3, Col) = Player then
            return True;
         end if;
      end loop;
      
      -- Check diagonals
      if B (1, 1) = Player and B (2, 2) = Player and B (3, 3) = Player then
         return True;
      end if;
      
      if B (1, 3) = Player and B (2, 2) = Player and B (3, 1) = Player then
         return True;
      end if;
      
      return False;
   end Check_Winner;
   
   -- Check if board is full
   function Is_Board_Full (B : Board) return Boolean is
   begin
      for Row in 1 .. 3 loop
         for Col in 1 .. 3 loop
            if B (Row, Col) = Empty then
               return False;
            end if;
         end loop;
      end loop;
      return True;
   end Is_Board_Full;
   
   -- Check if game is over
   function Is_Game_Over (B : Board) return Boolean is
   begin
      return Check_Winner (B, X) or Check_Winner (B, O) or Is_Board_Full (B);
   end Is_Game_Over;
   
   -- Get opponent
   function Get_Opponent (Player : Cell) return Cell is
   begin
      if Player = X then
         return O;
      else
         return X;
      end if;
   end Get_Opponent;
   
   -- Minimax algorithm with alpha-beta pruning
   function Minimax (B : Board; Depth : Integer; Is_Maximizing : Boolean; 
                     Alpha : Integer; Beta : Integer; Player : Cell) return Integer is
      Opponent : constant Cell := Get_Opponent (Player);
      Best_Score : Integer;
      Score : Integer;
      New_Alpha : Integer := Alpha;
      New_Beta : Integer := Beta;
   begin
      -- Terminal conditions
      if Check_Winner (B, Player) then
         return 10 - Depth;
      elsif Check_Winner (B, Opponent) then
         return Depth - 10;
      elsif Is_Board_Full (B) or Depth >= Max_Depth then
         return 0;
      end if;
      
      if Is_Maximizing then
         Best_Score := Integer'First;
         for Row in 1 .. 3 loop
            for Col in 1 .. 3 loop
               if B (Row, Col) = Empty then
                  declare
                     New_Board : Board := B;
                  begin
                     New_Board (Row, Col) := Player;
                     Score := Minimax (New_Board, Depth + 1, False, New_Alpha, New_Beta, Player);
                     if Score > Best_Score then
                        Best_Score := Score;
                     end if;
                     if Best_Score > New_Alpha then
                        New_Alpha := Best_Score;
                     end if;
                     exit when New_Beta <= New_Alpha;
                  end;
               end if;
            end loop;
            exit when New_Beta <= New_Alpha;
         end loop;
      else
         Best_Score := Integer'Last;
         for Row in 1 .. 3 loop
            for Col in 1 .. 3 loop
               if B (Row, Col) = Empty then
                  declare
                     New_Board : Board := B;
                  begin
                     New_Board (Row, Col) := Opponent;
                     Score := Minimax (New_Board, Depth + 1, True, New_Alpha, New_Beta, Player);
                     if Score < Best_Score then
                        Best_Score := Score;
                     end if;
                     if Best_Score < New_Beta then
                        New_Beta := Best_Score;
                     end if;
                     exit when New_Beta <= New_Alpha;
                  end;
               end if;
            end loop;
            exit when New_Beta <= New_Alpha;
         end loop;
      end if;
      
      return Best_Score;
   end Minimax;
   
   -- Find best move using minimax
   function Find_Best_Move (B : Board; Player : Cell) return Move is
      Best_Score : Integer := Integer'First;
      Best_Move : Move := (Row => -1, Col => -1);
      Score : Integer;
   begin
      for Row in 1 .. 3 loop
         for Col in 1 .. 3 loop
            if B (Row, Col) = Empty then
               declare
                  New_Board : Board := B;
               begin
                  New_Board (Row, Col) := Player;
                  Score := Minimax (New_Board, 0, False, Integer'First, Integer'Last, Player);
                  if Score > Best_Score then
                     Best_Score := Score;
                     Best_Move := (Row => Row, Col => Col);
                  end if;
               end;
            end if;
         end loop;
      end loop;
      return Best_Move;
   end Find_Best_Move;
   
   -- Get human move
   procedure Get_Human_Move (B : in out Board; Player : Cell) is
      Position : Integer;
      Row, Col : Integer;
      Valid : Boolean := False;
      Best_Move : Move;
   begin
      -- Show hint if enabled
      if Show_Hints then
         Put_Line ("Calculating best move...");
         Best_Move := Find_Best_Move (B, Player);
         Put_Line ("HINT: Best move is position" & 
                   Integer'Image ((Best_Move.Row - 1) * 3 + Best_Move.Col));
         New_Line;
      end if;
      
      while not Valid loop
         Put_Line ("Enter position (1-9): ");
         begin
            Get (Position);
            Skip_Line;
            
            if Position >= 1 and Position <= 9 then
               Row := (Position - 1) / 3 + 1;
               Col := (Position - 1) mod 3 + 1;
               
               if B (Row, Col) = Empty then
                  B (Row, Col) := Player;
                  Valid := True;
               else
                  Put_Line ("Position already occupied! Try again.");
               end if;
            else
               Put_Line ("Invalid position! Enter 1-9.");
            end if;
         exception
            when others =>
               Put_Line ("Invalid input! Enter a number 1-9.");
               Skip_Line;
         end;
      end loop;
   end Get_Human_Move;
   
   -- Computer makes a move
   procedure Computer_Move (B : in out Board; Player : Cell) is
      Best_Move : Move;
      Player_Name : constant String := (if Player = X then "X" else "O");
   begin
      Put_Line ("Computer (" & Player_Name & ") is thinking...");
      Best_Move := Find_Best_Move (B, Player);
      B (Best_Move.Row, Best_Move.Col) := Player;
      Put_Line ("Computer (" & Player_Name & ") chose position" & 
                Integer'Image ((Best_Move.Row - 1) * 3 + Best_Move.Col));
      New_Line;
   end Computer_Move;
   
   -- Display menu and get choice
   procedure Display_Menu is
   begin
      Put_Line ("====================================");
      Put_Line ("    TIC TAC TOE - Minimax AI");
      Put_Line ("====================================");
      New_Line;
      Put_Line ("1. Human vs Computer");
      Put_Line ("2. Computer vs Computer");
      Put_Line ("3. Toggle Hints (currently " & (if Show_Hints then "ON" else "OFF") & ")");
      Put_Line ("4. Exit");
      New_Line;
   end Display_Menu;
   
   -- Get search depth from user
   procedure Get_Search_Depth is
      Depth : Integer;
   begin
      Put_Line ("Enter search depth (1-9, 9 = full game tree): ");
      loop
         begin
            Get (Depth);
            Skip_Line;
            if Depth >= 1 and Depth <= 9 then
               Max_Depth := Depth;
               exit;
            else
               Put_Line ("Invalid depth! Enter 1-9: ");
            end if;
         exception
            when others =>
               Put_Line ("Invalid input! Enter 1-9: ");
               Skip_Line;
         end;
      end loop;
      New_Line;
   end Get_Search_Depth;
   
   -- Play one game
   procedure Play_Game is
      Game_Board : Board := (others => (others => Empty));
      Current_Player : Cell := X;
      Winner : Cell := Empty;
   begin
      Display_Board_Help;
      Display_Board (Game_Board);
      
      while not Is_Game_Over (Game_Board) loop
         if Current_Mode = Human_Vs_Computer and Current_Player = X then
            Put_Line ("Your turn (X):");
            Get_Human_Move (Game_Board, Current_Player);
         else
            Computer_Move (Game_Board, Current_Player);
            if Current_Mode = Computer_Vs_Computer then
               delay 1.0;  -- Pause to watch the game
            end if;
         end if;
         
         Display_Board (Game_Board);
         
         if Check_Winner (Game_Board, X) then
            Winner := X;
            exit;
         elsif Check_Winner (Game_Board, O) then
            Winner := O;
            exit;
         end if;
         
         Current_Player := Get_Opponent (Current_Player);
      end loop;
      
      -- Display result
      if Winner = X then
         if Current_Mode = Human_Vs_Computer then
            Put_Line ("Congratulations! You won!");
         else
            Put_Line ("Player X wins!");
         end if;
      elsif Winner = O then
         if Current_Mode = Human_Vs_Computer then
            Put_Line ("Computer wins!");
         else
            Put_Line ("Player O wins!");
         end if;
      else
         Put_Line ("It's a draw!");
      end if;
      New_Line;
   end Play_Game;
   
   -- Main program
   Choice : Integer;
   
begin
   loop
      Display_Menu;
      Put_Line ("Enter your choice: ");
      
      begin
         Get (Choice);
         Skip_Line;
         New_Line;
         
         case Choice is
            when 1 =>
               Current_Mode := Human_Vs_Computer;
               Get_Search_Depth;
               Play_Game;
               
            when 2 =>
               Current_Mode := Computer_Vs_Computer;
               Get_Search_Depth;
               Play_Game;
               
            when 3 =>
               Show_Hints := not Show_Hints;
               Put_Line ("Hints are now " & (if Show_Hints then "ON" else "OFF"));
               New_Line;
               
            when 4 =>
               Put_Line ("Thanks for playing!");
               exit;
               
            when others =>
               Put_Line ("Invalid choice! Try again.");
               New_Line;
         end case;
         
      exception
         when others =>
            Put_Line ("Invalid input! Try again.");
            Skip_Line;
            New_Line;
      end;
   end loop;
   
end TicTacToe;
