package ca.ubc.ece.eece210.mp3.ast;
import ca.ubc.ece.eece210.mp3.*;

import java.util.Set;
import java.util.HashSet;

import ca.ubc.ece.eece210.mp3.Element;
import ca.ubc.ece.eece210.mp3.Catalogue;

public class MatchesNode extends ASTNode {

    public MatchesNode(Token token) {
	super(token);
    }

    /**
     * Returns albums with a specified title
     * @param: the catalogue that is being searched
     * @return: Set of elements with the requested albums
     */
    public Set<Element> interpret(Catalogue argument) {
    	int numGenres = 0;
        numGenres = argument.rootList.size();
        Set<Element> albums = new HashSet<Element>();
        for(int i=0; i < numGenres; i++){
                addAlbums(argument.rootList.get(i), arguments, albums);
        }
        return albums;
    }
    
    /**
     * Recursively searches for the specified album and adds it to a set
     * @param genre: the genre being searched
     * @param title: regex which matches title
     * @param albums: set contains found albums
     */
    private void addAlbums(Genre genre, String title, Set<Element> albums) {
    	int totalElements = 0;
    	totalElements = genre.getChildren().size();
        Element currentElement;
    
            for(int i = 0; i < totalElements; i++) {
                    currentElement = genre.getChildren().get(i);
                    if(currentElement.hasChildren() == false) {  //this is an album
                            if(((Album)currentElement).getTitle().matches(title)){
                                    albums.add(currentElement); //save it only if it matches
                            }
                    } else { //its a genre
                            addAlbums((Genre)currentElement,title,albums);
                    }
            }
    }

}
