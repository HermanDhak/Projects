package ca.ubc.ece.eece210.mp3.ast;
import ca.ubc.ece.eece210.mp3.*;


import java.util.HashSet;
import java.util.Set;

import ca.ubc.ece.eece210.mp3.ast.ASTNode;
import ca.ubc.ece.eece210.mp3.ast.Token;

public class ByNode extends ASTNode {

	public ByNode(Token token) {
		super(token);
	}
	
	/**
	 * Searches recursively for albums by a given artist.
	 * 
	 * @param argument: The catalogue being searched in
	 * @return set: The set of albums that match the given artist
	 */
	
	@Override
	public Set<Element> interpret(Catalogue argument) {
		int numGenres = 0;
		numGenres=argument.rootList.size(); //since rootlist has only genres
		Set<Element> albums = new HashSet<Element>();
	
		for(int i = 0; i < numGenres; i++) {
			addAlbumsByArtist(argument.rootList.get(i),arguments,albums);
			}
		return albums;
		
	}
	
	/**
	 * This is the recursive part of the above method that searches for albums by performer
	 * and adds them to the albums set.
	 * 
	 * @param genre: the genre being searched 
	 * @param performer: the name requested of the artist
	 * @param albums: all the albums that match the performer name
	 */
	private void addAlbumsByArtist(Genre genre, String performer, Set<Element> albums) {
		int totalElements = 0;
		totalElements = genre.getChildren().size();
		Element currentElement;
		
		for (int i = 0; i < totalElements; i++) {
			currentElement = genre.getChildren().get(i);
            if(currentElement.hasChildren()==false) {  //has to be an album
                    if(((Album)currentElement).getPerformer().equals(performer)){
                            albums.add(currentElement);
                    }
            } else   { // therefore its a genre
            	addAlbumsByArtist((Genre)currentElement,performer,albums);
            }
		}
		
	}

}
