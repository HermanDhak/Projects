package ca.ubc.ece.eece210.mp3;

import java.util.ArrayList;

/**
 * 
 * @author Herman Dhak
 * 
 * This class contains the information needed to represent 
 * an album in our application.
 * 
 */

public final class Album extends Element {
	
	private String title = "";
	private String performer = "";
	private String genreString = "";
	private String songlistText = "";
	private String stringRepresentation = "";
	private Genre genre = null;
	private ArrayList<String> songlist;
	
	/**
	 * Builds an album with the given title, performer and song list
	 * 
	 * @param title
	 *            the title of the album
	 * @param author
	 *            the performer 
	 * @param songlist
	 * 			  the list of songs in the album
	 */
	public Album(String title, String performer, ArrayList<String> songlist) {
		this.title = title;
		this.performer = performer;
		this.songlist = songlist;
		songlistText = songlist.toString(); // in case we need to print out the songlist
		this.addToGenre(Catalogue.unclassifiedGenre); //since no genre is specified we will assume its unclassified
		genreString = "Unclassified";
	}

	/**
	 * Builds an album from the string representation of the object. It is used
	 * when restoring an album from a file.
	 * 
	 * @param stringRepresentation
	 *            the string representation
	 */
	public Album(String stringRepresentation) {
		
		// check up to the | symbols which mark divisions between attributes in the file.
		// only capture the string up to a | marker
		int startLocation = stringRepresentation.indexOf("|");
		title = stringRepresentation.substring(0, (startLocation));
		stringRepresentation = stringRepresentation.substring(startLocation+1); // trim the string up to and including |
		startLocation = stringRepresentation.indexOf("|");
		performer = stringRepresentation.substring(0, startLocation);
		stringRepresentation = stringRepresentation.substring(startLocation+1);;
		startLocation = stringRepresentation.indexOf("|"); // update the start location
		songlistText = stringRepresentation.substring(startLocation + 1);
		this.addToGenre(Catalogue.unclassifiedGenre);
		
	}

	/**
	 * Returns the string representation of the given album. The representation
	 * contains the title, performer and songlist, as well as all the genre
	 * that the album belongs to.
	 * 
	 * @return the string representation
	 */
	public String getStringRepresentation() {
		stringRepresentation = title + "|" + performer + "|" + songlistText;
		return stringRepresentation;
	}

	/**
	 * Add the album to the given genre
	 * 
	 * @param genre
	 *            the genre to add the album to.
	 */
	public void addToGenre(Genre genre) {
		if (this.genre != null) {
			// move it into the new genre
			genre.getChildren().remove(this);
			genre.addToGenre(this);
			this.genre = genre;
		}
		else {
			genre.addToGenre(this);
			this.genre = genre;
		}
	}
	
	/**
	 * Removes the album from the given genre. 
	 * (Places it in an unclassified genre)
	 * 
	 * @param genre
	 * 				the genre from which album is removed from
	 */
	public void removeFromGenre(){
		genre.getChildren().remove(this);
		this.addToGenre(Catalogue.unclassifiedGenre);
	}
	

	/**
	 * Returns the genre that this album belongs to.
	 * 
	 * @return the genre that this album belongs to
	 */
	public Genre getGenre() {
		return genre;
	}

	/**
	 * Returns the title of the album
	 * 
	 * @return the title
	 */
	public String getTitle() {
		return title;
	}

	/**
	 * Returns the performer of the album
	 * 
	 * @return the performer
	 */
	public String getPerformer() {
		return performer;
	}

	/**
	 * An album cannot have any children (it cannot contain anything).
	 */
	@Override
	public boolean hasChildren() {
		return false;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result
				+ ((performer == null) ? 0 : performer.hashCode());
		result = prime * result + ((title == null) ? 0 : title.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (!(obj instanceof Album))
			return false;
		Album other = (Album) obj;
		if (performer == null) {
			if (other.performer != null)
				return false;
		} else if (!performer.equals(other.performer))
			return false;
		if (title == null) {
			if (other.title != null)
				return false;
		} else if (!title.equals(other.title))
			return false;
		return true;
	}


	 @Override
     public String toString(){
             return getStringRepresentation();
     }

	
}
