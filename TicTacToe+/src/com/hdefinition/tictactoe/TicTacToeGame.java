package com.hdefinition.tictactoe;

import java.util.Random;

public class TicTacToeGame {
	
	private char mBoard[];
	
	public static final char PLAYER = 'X';
	public static final char ANDROID = 'O';
	public static final char EMPTY = ' ';
	public static final int SIZE = 9;
	
	private Random mRand;
	
	//constructor
	public TicTacToeGame() {
		mBoard = new char[SIZE];
		
		for (int i = 0; i < SIZE; i++) 
			mBoard[i] = EMPTY;
		
		mRand = new Random();
	}

	public void setMove(char currPlayer,int location)
	{
		 mBoard[location] = currPlayer;  
	}
	
	public int getCompMove()
	{
		int move;
		char tempMove;
		
		for (int i = 0; i < SIZE; i++)
		{
			if (mBoard[i] != ANDROID && mBoard[i] != PLAYER)
			{
				tempMove = mBoard[i];
				mBoard[i] = ANDROID;
				if (checkWinner() == ANDROID) //If this is going to be the winning move then place it here
				{
					setMove(ANDROID, i);
					return i;
				}
				else
					mBoard[i] = tempMove; //return the spot to what it was originally, check again
			}
		}
		
		for (int i = 0; i < SIZE; i++)
		{
			if (mBoard[i] != ANDROID && mBoard[i] != PLAYER)
			{
				tempMove = mBoard[i];
				mBoard[i] = PLAYER;
				if (checkWinner() == PLAYER) //If this is going to be the blocking move then place it here
				{
					setMove(ANDROID, i);
					return i;
				}
				else
					mBoard[i] = tempMove; //return the spot to what it was originally, check again
			}
		}
		
		
		//if no spots are found, randomly make a move
		do
		{
			move = mRand.nextInt(SIZE);
		} while (mBoard[move] == PLAYER || mBoard[move] == ANDROID);
		
		setMove(ANDROID, move);
		return move;
	}
	
	public char checkWinner()
	{
		final int combinations[][] = {{ 0, 1, 2 }, { 3, 4, 5 }, { 6, 7, 8 }, // horizontal combinations
				{ 0, 3, 6 }, { 1, 4, 7 }, { 2, 5, 8 }, // vertical 
				{ 0, 4, 8 }, { 2, 4, 6 }}; // diagonals
		 	//	0 | 1 | 2
			//	3 | 4 | 5
			//	6 | 7 | 8   Used to obtain winning combinations
		
		for (int i = 0; i < 8;i++)
		{
			if (mBoard[combinations[i][0]] == EMPTY) {
				continue; 
			}
			if (mBoard[combinations[i][0]] == PLAYER && mBoard[combinations[i][1]] == PLAYER && mBoard[combinations[i][2]] == PLAYER) {
				return 'X';
			}
			else if(mBoard[combinations[i][0]] == ANDROID && mBoard[combinations[i][1]] == ANDROID && mBoard[combinations[i][2]] == ANDROID){
				return 'O';
			}
		}
		return EMPTY;
		
	} // end checkwinner

	// clear the board method
	public void clearBoard()
	{
		for (int i = 0; i < SIZE; i++) 
		mBoard[i] = EMPTY;
			
	}

}
