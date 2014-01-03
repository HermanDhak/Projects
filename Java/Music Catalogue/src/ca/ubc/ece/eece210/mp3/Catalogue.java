package ca.ubc.ece.eece210.mp3;

import ca.ubc.ece.eece210.mp3.ast.*;

import java.io.*;
import java.util.*;

/**
 * Container class for all the albums and genres. Its main 
 * responsibility is to save and restore the collection from a file.
 * 
 * @author: Michael Adria
 * 
 */

public final class Catalogue {

		public List<Genre> rootList;
        int tab = 0;
        public static Genre unclassifiedGenre = new Genre("Unclassified"); //default genre to load unclassified albums into
        
        /**
         * Builds a new, empty catalogue.
         */
        public Catalogue() {
        	 rootList = new ArrayList<Genre>();
        }
        
        /**
         * Builds a new catalogue and restores its contents from the 
         * given file.
         * 
         * @param fileName
         *            the file from where to restore the library.
         */
        public Catalogue(String fileName) throws FileNotFoundException {
        	Scanner input = new Scanner(new File(fileName));
            rootList = new ArrayList<Genre>();
    		String text="";
    		String singleLine="";
    		//scan the file line by line and save it all into a string
    		while (input.hasNextLine()) {
    			singleLine = input.nextLine();
    		//	lines.add(singleLine);
    			text=text+singleLine+'\n';
    		}
    		input.close();
    		//System.out.println(text);
    		text=text.substring(0,text.length()-1); //necessary to remove end of file character?
           
    		 String aLine = "";
    	        ArrayList<String> lines =new ArrayList<String>();
    	        int i = 0;
    			
    			for(i=0; i < text.length(); i++){
    				if(text.charAt(i) != '\n'){
    					aLine = aLine + text.charAt(i); //build up a line char by char
    				}
    				if(text.charAt(i)=='\n'){
    					lines.add(aLine); //add once it reaches end of line
    					aLine = "";
    				}
    			}
    			
    			if(text.charAt(text.length()-1)!='\n'){
    				lines.add(aLine);
    				aLine = "";
    			}
    			
    		int begin = 0;
    		int end = 0;
    		
    		for(end = 1; end < lines.size(); end++){
    			
    			if (lines.get(end).substring(0,4).equals("    ") == false){ //If there is no space, it has to be a new genre
    				rootList.add(restoreGenre(lines, begin, end));
    				begin = end;
    			}
    			else if (end == lines.size()-1){
    				rootList.add(restoreGenre(lines, begin, end));
    			} 
    		}
    		
    		
    		
    		
        }	
    	
        
        /**
         * Returns a genre from inside an ArrayList of genres
         * @param lines: the ArrayList of genres that will make up a catalogue
         * @param begin: the element of the ArrayList to start at
         * @param end: the element of the ArrayList to end at
         * @return masterGenre: the full Genre with SubGenres and Albums
         */	
    	private static Genre restoreGenre(ArrayList<String> lines, int begin, int end){
    		
    		Genre masterGenre = new Genre(lines.get(begin));
    		//System.out.print(masterGenre.getStringRepresentation());
    		//int subAlbums = 0;
    		//ArrayList<String> subGenreAlbums =new ArrayList<String>();
    		
    		for(int i=1; i < lines.size(); i++){
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
    	 * Queries the catalogue based on the inputted query type.
    	 * @param query : the query being conducted
    	 * @return all the albums that are discovered in the query
    	 */
    	public List<Album> queryCat(String query) {
             
             List<Token> tokens = QueryTokenizer.tokenizeInput(query);
             QueryParser parser = new QueryParser(tokens);
             ASTNode astRoot = parser.getRoot();
             Iterator<Element> collectionOfElements = astRoot.interpret(this).iterator();
             List<Album> albums = new ArrayList<Album>();
             while (collectionOfElements.hasNext()) {
                     albums.add((Album)collectionOfElements.next());
             }
             return albums;
     }
     
        
        
        /**
         * Saves the contents of the catalogue to the given file recursively.
         * @param fileName the file where to save the library
         */
        public void saveCatalogueToFile(String fileName) throws FileNotFoundException {
                PrintStream CatalogueFile = new PrintStream(new File(fileName));
                CatalogueFile.print(getStringRepresentation());
                CatalogueFile.close();
        }
            	
        /**
         * Recursively breaks up catalogue into genres which are saved to a file
         * containing all of their albums and subgenres.
         * @return the String object which represents an entry (genre) in the catalogue
        */
        public String getStringRepresentation() {
        	String stringRepresentation="";
        	int totalGenres;
            totalGenres = rootList.size();
            for(int i = 0; i < totalGenres; i++){
            	stringRepresentation = stringRepresentation + rootList.get(i).getStringRepresentation();
            }
            return stringRepresentation;
        }
}