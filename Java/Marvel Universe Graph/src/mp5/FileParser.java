package mp5;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class FileParser {
	private BufferedReader br;
	private String next="";
	private Book book;
	private Character character;
	
	/**
	 * Creates a FileParser
	 * @param fileName - Absolute or relative path of the file to parse
	 * Requires: The file has to exist
	 */
	public FileParser(String fileName){
		book=null;
		character=null;
		try {
			br=new BufferedReader(new FileReader(fileName));
			next=br.readLine();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * Determines if the file has a next line or not
	 * @return true if the file has a next line, false otherwise
	 */
	public boolean hasNext(){
		return next!=null;
	}
	
	/**
	 * Iterates through the file, and creates a Book and Character object
	 * from every line
	 * REQUIRES: hasNext() returned true before calling this method
	 */
	public void next(){
		String returnString=next;
		try {
			next=br.readLine();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		makeBookCharacter(returnString);//make book and character objects based on this line
	}
	
	/**
	 * closes the buffered reader for the file used for input
	 * must be closed when I/O for the file is no longer needed
	 */
	public void closeFile(){
		if(br!=null){
			try {
				br.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
	
	/**
	 * Getter method for "book"
	 * Assumes that a previous call to next() was made
	 * @return
	 */
	public Book getBook(){
		return book;
	}
	
	/**
	 * Getter method for "character"
	 * Assumes that a previous call to next() was made
	 * @return
	 */
	public Character getCharacter(){
		return character;
	}
	
	/**
	 * Updates the instance variables "book" and "character" based on the line given
	 * @param line - must be of the form:
	 * "VISION "	"CM 51"
	 */
	private void makeBookCharacter(String line){
		int[] flags=new int[4];//flags for apostrophies
		int i,flagCounter=0,l;
		l=line.length();
		for(i=0; i<l; i++){
			if(line.charAt(i)=='"'){
				flags[flagCounter]=i;
				flagCounter++;
			}
		}
		character=new Character(line.substring(flags[0]+1,flags[1]));
		book=new Book(line.substring(flags[2]+1,flags[3]));
	}
}
