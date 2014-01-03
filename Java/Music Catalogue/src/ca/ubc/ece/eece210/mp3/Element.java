package ca.ubc.ece.eece210.mp3;

import java.util.Vector;
import java.util.List;

/**
 * An abstract class to represent an entity in the catalogue. The element (in this
 * implementation) can either be an album or a genre.
 * 
 * @author Joshua Tan
 * 
 */
public abstract class Element {
	
	
	public Vector<Element> elements = new Vector<Element>();
	
	/**
	 * Returns all the children of this entity. They can be albums or
	 * genres. In this particular application, only genres can have
	 * children. Therefore, this method will return the albums or genres
	 * contained in this genre.
	 * 
	 * @return an array list of all the entity's children
	 */
	public Vector<Element> getChildren() {
		return elements;
	}

	/**
	 * Adds a child to this entity. Basically, it is adding an album or genre
	 * to an existing genre
	 * 
	 * @param b the entity to be added.
	 * @throws IllegalArgumentException if caller is a leaf object.
	 */
	protected void addChild(Element b) {
		
		if(hasChildren() == false) {
			throw new IllegalArgumentException("Album cannot have children.");
		}
		if (elements.contains(b) == false) {
			elements.add(b); //only add if no duplicates
		}else {
			return;
		}
	}

	/**
	 * Abstract method to determine if a given entity can (or cannot) contain
	 * any children.
	 * 
	 * @return true if the entity can contain children, or false otherwise.
	 */
	public abstract boolean hasChildren();
	
	public abstract String getStringRepresentation();
	
	@Override
	public abstract boolean equals(Object anObject);
	
	@Override
    public abstract int hashCode();
	
}
