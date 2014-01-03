package ca.ubc.ece.eece210.mp3;

import java.util.ArrayList;
import java.util.List;
import java.util.Vector;



/**
 * Represents a genre (or collection of albums/genres).
 * 
 * @author Herman Dhak
 * 
 */
public final class Genre extends Element {
	
	private String genreString;
	
	/**
	 * Creates a new genre with the given name.
	 * 
	 * @param name
	 *            the name of the genre.
	 */
	public Genre(String name) {
		genreString = name;
		elements = new Vector<Element>(); //stores every object contained in this genre
	}
	
	public String getName() {
		return (genreString);
	}

	/**
	 * Restores a genre from its given string representation.
	 * 
	 * @param stringRepresentation
	 * @return the genre object of the mastergenre
	 */
	public static Genre restoreCollection(String stringRepresentation) {
        String aLine = "";
        ArrayList<String> lines =new ArrayList<String>();
		int i = 0;

		for(i=0; i < stringRepresentation.length()-1; i++){
			if(stringRepresentation.charAt(i)!='\n') {
				aLine = aLine + stringRepresentation.charAt(i); //build up a line char by char
			}
			if(stringRepresentation.charAt(i)=='\n') {
				lines.add(aLine); //add once it reaches end of line
				aLine = "";
			}
		}
		
		if(stringRepresentation.charAt(stringRepresentation.length()-1)!='\n'){
			lines.add(aLine);
			aLine = "";
		}
		
		Genre masterGenre = new Genre(lines.get(0)); //main genre is already on 1st line
		//now parse each line
		for(i=1; i < lines.size(); i++){
			if (!lines.get(i).contains("|")) { //must be a subgenre 
				Genre subGenre = new Genre(lines.get(i).substring(4));
				masterGenre.addToGenre(subGenre);
				i++;
				while(i < lines.size()) {   //keep adding albums until the next subgenre is encountered
					if(!lines.get(i).contains("|"))
							break;
					else {
						Album subAlbum = new Album(lines.get(i).substring(8));
						subAlbum.addToGenre(subGenre);
						i++;
					}
				} // end while
			
			} // end if
			//all albums sitting in the master genre will be added first before the subgenres show up
			else if ((lines.get(i).contains("|")) ) {
				Album album = new Album(lines.get(i).substring(4));
				album.addToGenre(masterGenre); //add this album object to the master genre
				}
		} //end for
		return masterGenre;
	}

	/**
	 * Returns the string representation of a genre
	 * 
	 * @return
	 */
	public String getStringRepresentation() {
		return recurseStringRep(0);
	}
	
	/**
	 * Converts a genre object into its string representation recursively
	 * @param tab number of tabs at that spot
	 * @return the final string representation to getstringrep method
	 */
	private String recurseStringRep(int tab) {
		String line = "";
		line = printTab(tab) + genreString + '\n'; //very first part is of course the root genre
		
		for (int i = 0; i < elements.size(); i++) {
			if(elements.get(i).hasChildren() == false) { //this is an album
				line = line + printTab(tab + 1) + elements.get(i).getStringRepresentation() + '\n';
				//System.out.println("Line" + line);
			}
			else { //genre
				line  = line + ((Genre)(elements.get(i))).recurseStringRep(tab + 1);
			}
		}//end for
		return line;
	}
	
	/**
	 * Prints the appropriate amount of tabbing
	 * @param tab - the number of tabs
	 * @return a string with that number of tabs.
	 */
	private String printTab(int tab){
		String spacer = "";
		for(int i = 0; i < tab; i++){
			spacer = spacer + "    ";
		}
		return spacer;
	}
	/**
	 * Adds the given album or genre to this genre
	 * 
	 * @param b
	 *            the element to be added to the collection.
	 */
	public void addToGenre(Element b) {
		addChild(b);
	}

	/**
	 * Returns true, since a genre can contain other albums and/or
	 * genres.
	 */
	@Override
	public boolean hasChildren() {
		return true;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result
				+ ((genreString == null) ? 0 : genreString.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (!(obj instanceof Genre))
			return false;
		Genre other = (Genre) obj;
		if (genreString == null) {
			if (other.genreString != null)
				return false;
		} else if (!genreString.equals(other.genreString))
			return false;
		return true;
	}
}