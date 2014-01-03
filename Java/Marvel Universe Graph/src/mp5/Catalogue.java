package mp5;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

public class Catalogue {
	private List<Book> library;
	private List<Character> universe;
	
	/**
	 * Initializes the library and universe to be empty
	 */
	public Catalogue(){
		library=new LinkedList<Book>();
		universe=new LinkedList<Character>();
	}
	
	/**
	 * Adds the book to the library
	 * @param book - The book to add
	 */
	public void addToLibrary(Book book){
		library.add(book);
	}
	
	/**
	 * adds the character to the universe
	 * @param character - the character to add
	 */
	public void addToUniverse(Character character){
		universe.add(character);
	}
	
	/**
	 * determines if the library contains a book which is "equal"
	 * to the passed book or not
	 * Note: two books are equal when they have equal titles
	 * @param book
	 * @return true if the library contains the book, false otherwise
	 */
	public boolean libraryContains(Book book){
		return library.contains(book);
	}
	
	/**
	 * determines if the universe contains a character which is "equal"
	 * to the passed character or not
	 * Note: two characters are equal when they have equal names
	 * @param character
	 * @return true if the universe contains the character, false otherwise 
	 */
	public boolean universeContains(Character character){
		return universe.contains(character);
	}
	
	/**
	 * gets the library of books
	 * @return library of books
	 */
	public List<Book> getListBooks(){
		return library;
	}
	
	/**
	 * gets the universe of characters
	 * @return universe of characters
	 */
	public List<Character> getListCharacters(){
		return universe;
	}
	
	/**
	 * gets the actual book from the library which is "equal" to the passed book
	 * Note: two books are equal when they have equal titles
	 * @param book
	 * @return the book object which is "equal" to the passed book
	 */
	public Book getBook(Book book){
		Book tempBook;
		Iterator<Book> library=this.library.iterator();
		while(library.hasNext()){
			tempBook=library.next();
			if(tempBook.equals(book)){
				return tempBook;
			}
		}
		return null;
	}
	
	/**
	 * gets the actual character from the universe which is "equal" to the passed character
	 * Note: two characters are equal when they have equal titles
	 * @param character
	 * @return the character object which is "equal" to the passed character
	 */
	public Character getCharacter(Character character){
		Character tempCharacter;
		Iterator<Character> universe=this.universe.iterator();
		while(universe.hasNext()){
			tempCharacter=universe.next();
			if(tempCharacter.equals(character)){
				return tempCharacter;
			}
		}
		return null;
	}
}