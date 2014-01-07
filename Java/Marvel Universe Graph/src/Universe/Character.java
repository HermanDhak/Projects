package mp5;

import java.util.LinkedList;
import java.util.List;

public class Character {
	private List<Book> books;
	private String name;
	
	/**
	 * constructs a new character with the given name and an empty
	 * list
	 * @param name - the name of the character
	 */
	public Character(String name){
		this.name=name;
		books=new LinkedList<Book>();
	}
	
	/**
	 * Gets the name of the character
	 * @return - the name of the character
	 */
	public String getName(){
		return name;
	}
	
	/**
	 * adds the book to the list of books associated with this character
	 * @param book - the book to be added
	 */
	public void addBook(Book book){
		books.add(book);
	}
	
	/**
	 * Compares this character's name and the character's name passed to it
	 * Look at the compareTo() method for the String class
	 * @param character
	 * @return
	 */
	public int compareTo(Character character){
		return name.compareTo(character.name);
	}
	
	/**
	 * Gets the list of books associated with this character
	 * @return
	 */
	public List<Book> getListBooks(){
		return books;
	}
	
	@Override
	/**
	 * Two characters are equal when they have same names
	 */
	public boolean equals(Object o){
		if(!(o instanceof Character)){
			return false;
		}
		Character character=(Character)o;
		return character.name.equals(name);
	}
	
	@Override
	/**
	 * The string reprsentation of a character is just its name
	 */
	public String toString(){
		return name;
	}
}
