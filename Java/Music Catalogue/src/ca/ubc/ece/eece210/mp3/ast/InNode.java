package ca.ubc.ece.eece210.mp3.ast;

import java.util.*;

import ca.ubc.ece.eece210.mp3.Element;
import ca.ubc.ece.eece210.mp3.Catalogue;
import ca.ubc.ece.eece210.mp3.Genre;

public class InNode extends ASTNode {

    public InNode(Token token) {
	super(token);
    }

   /**
    * Gets every album within a given genre
    * @param argument: the catalogue that is being searched
    * @return a set which contains every required album
    */
    @Override
    public Set<Element> interpret(Catalogue argument) {
    	int totalGenres = 0;
        totalGenres = argument.rootList.size();
        Set<Element> albums = new HashSet<Element>();
        Genre currentGenre = null;
        Genre genreFound = null;
       
        for (int i = 0; i < totalGenres; i++) {
                currentGenre = argument.rootList.get(i);
                genreFound = findGenre(currentGenre, arguments);
                if (genreFound != null) { //the genre we are looking for is not here
                        break;
                }
        }
        if(genreFound==null){
                return albums;
        }else{
                addAlbums(genreFound,albums);
                return albums;
        }
	
    }
    
    /**
     * Store all albums within the current genre into set
     * @param genre: the genre that contains all the albums
     * @param albums: the set in which albums are placed into
     */
    private void addAlbums(Genre genre, Set<Element> albums) {
    	int size= genre.getChildren().size();
        Element currentElement;
        for (int i = 0; i < size; i++) {
                currentElement = genre.getChildren().get(i); //set the current element
                if (currentElement.hasChildren()==false) { //this is an album
                        albums.add(currentElement);
                }
                else { //its a genre
                        addAlbums((Genre)currentElement, albums);
                }
        }
    }

    /**
     * Recursively looks for a genre based on a specified reference.
     * @param genre: the main genre being searched for a specific subgenre
     * @param name: name of genre being searched for
     * @return the genre with the specified name
     */
    private Genre findGenre(Genre genre, String name) {
            
    	if(genre.getName().equals(name)) {
                    return genre;
            }
            
    	List<Element> elements = genre.getChildren();
        int totalElements = 0;
        totalElements = elements.size();
        Element currentElement;
        
        for (int i = 0; i < totalElements; i++) {
        	currentElement = elements.get(i);
            
        	if (currentElement.hasChildren()) {
        		if (currentElement.getChildren().size() == 0) {  //its a genre and leaf
        	
            	
        		if (((Genre)currentElement).getName().equals(name)){
            		return (Genre)currentElement;
                }//end inner if
            
        	} else { //its a branch node
                return findGenre((Genre)currentElement, name);
            }//end else
        
        }//end for
        }
        return null;
    }
}
