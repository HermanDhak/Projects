package mp5;

import java.util.ArrayList;
import java.util.List;

public class Book {
	private List<Character> characters;
	private String title;
	
	/**
	 * constructs a book object with the given title and an empty
	 * list of characters
	 * @param title - title of the book
	 */
	public Book(String title){
		this.title=title;
		characters=new ArrayList<Character>();
	}
	
	/**
	 * gets the title of the book
	 * @return - the title of the book
	 */
	public String getTitle(){
		return title;
	}
	
	/**
	 * adds the character to the list of characters
	 * @param character - the character to be added
	 */
	public void addCharacter(Character character){
		characters.add(character);
	}
	
	/**
	 * gets the list of characters associated with this book
	 * @return
	 */
	public List<Character> getListCharacters(){
		return characters;
	}

	@Override
	/**
	 * Two books are equal when they have same titles
	 */
	public boolean equals(Object o){
		if(!(o instanceof Book)){
			return false;
		}
		Book book=(Book)o;
		return book.title.equals(title);
	}
	
	@Override
	/**
	 * String representation of a book - just its title
	 */
	public String toString(){
		return "Book - "+title;
	}
}
