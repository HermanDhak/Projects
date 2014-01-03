package mp5_tests;

import static org.junit.Assert.*;

import mp5.Book;
import mp5.Character;

import mp5.FileParser;

import org.junit.Test;

public class FileParserTest {
	/**
	 * Tests the hasNext() method of the FileParser class
	 * hasNext() is called on the parser until it results in a false,
	 * a counter counts up every time the loop was executed,
	 * the final count of the counter should display the number of lines in the text file
	 */
	@Test
	public void hasNextTest(){
		FileParser parser=new FileParser("testfile.tsv");
		int count=0;
		while(parser.hasNext()){
			parser.next();
			count++;
		}
		assertEquals(count,27);//the testfile has 27 lines!
		
		parser.closeFile();//file must be closed after parsing is complete!
	}
	
	/**
	 * Iterates 5 times over the text file parser, then calls the next() method
	 * After that, getBook() and getCharacter() is called to see if it matches the correct
	 * values at line # 5 in the text file
	 */
	@Test
	public void nextGetBookGetCharacterTest(){
		FileParser parser=new FileParser("testfile.tsv");
		//iterate 5 times
		for(int i=0; i<5; i++){
			if(parser.hasNext()){
				parser.next();
			}
		}
		//now test if the Book and Character objects are right:
		assertEquals(parser.getBook(),new Book("2"));//book is supposed to be "2"
		assertEquals(parser.getCharacter(),new Character("C"));//character is supposed to be "C"
		
		parser.closeFile();//file must be closed after parsing is complete!
	}
}
