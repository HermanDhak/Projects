package ca.ubc.ece.eece210.mp3;

import static org.junit.Assert.*;

import java.io.*;
import java.util.*;

import org.junit.Test;

public class AlbumTest {
	
	/**
	 * This test adds an album to a genre
	 * Compares the name of the inputted genre
	 * to the name returned by the album
	 */
	@Test
	public void testAddAlbum() {
		ArrayList<String> songList = new ArrayList<String>();
		songList.add("Song 1");
		songList.add("Song 2");
		songList.add("Song 3");
		Album testAlbum = new Album("Album 1","Performer", songList);
		Genre newGenre = new Genre("Metal");
		testAlbum.addToGenre(newGenre);
		
		assertEquals(newGenre, testAlbum.getGenre());
	}
	
	/**
	 * This test removes the album from its genre. 
	 * Following removal it should be placed into the "Unclassified" genre
	 * automatically.
	 */
	@Test
	public void testremoveAlbum() {
		ArrayList<String> songList = new ArrayList<String>();
		songList.add("Song 1");
		songList.add("Song 2");
		songList.add("Song 3");
		Album testAlbum = new Album("Album 1","Performer", songList);
	
		Genre oldGenre = new Genre("House");
		testAlbum.addToGenre(oldGenre);
		testAlbum.removeFromGenre();
		
		//this should place album in the unclassified genre which is contained in catalogue
		assertEquals(Catalogue.unclassifiedGenre, testAlbum.getGenre());
	}
	
	/**
	 * This test saves an album in its string representation (Constructor 1)
	 */
	@Test
	public void testSaveAlbumString() {
		ArrayList<String> songList = new ArrayList<String>();
		songList.add("Song 1");
		songList.add("Song 2");
		songList.add("Song 3");
		//Might want to initialize the Unclassified genre as well
		Album testAlbum = new Album("Album 1","Performer", songList);
		
		assertEquals("Album 1|Performer|"+songList,testAlbum.getStringRepresentation());
	}
	
	/**
	 * This test recreates an album from the string form. (Constructor 2)
	 * Compares the string rep of an album to the one given.
	 */
	@Test
	public void testRecreateAlbum() {
		ArrayList<String> songList = new ArrayList<String>();
		songList.add("Song 1");
		songList.add("Song 2");
		songList.add("Song 3");
		String stringRepresentation = "Album 1|Performer|"+songList;
		//create an album with a string representation
		Album testAlbum = new Album(stringRepresentation);
		//System.out.println(testAlbum.getStringRepresentation());
		
		assertEquals(stringRepresentation,testAlbum.getStringRepresentation());
	}
	/**
	 * This test saves the genre to its string form.
	 * the string form is compared to one that has been created
	 * in the variable stringRepresentation.
	 */
	@Test
	public void testSaveGenreString() {
		ArrayList<String> songList = new ArrayList<String>();
		songList.add("Song 1");
		songList.add("Song 2");
		songList.add("Song 3");
		Album testAlbum = new Album("Album 1","Performer", songList);
		Genre newGenre = new Genre("R&B");
		Genre newSubGenre = new Genre("HipHop");
		Album testAlbum2 = new Album("Album 2","Performer 2", songList);
		testAlbum.addToGenre(newGenre);
		newGenre.addToGenre(newSubGenre);
		testAlbum2.addToGenre(newSubGenre);
		//System.out.println(newGenre.getStringRepresentation());
		//must insert correct genre string representation here
		String stringRepresentation = "R&B\n    Album 1|Performer|[Song 1, Song 2, Song 3]\n    HipHop\n        Album 2|Performer 2|[Song 1, Song 2, Song 3]\n";
		assertEquals(stringRepresentation,newGenre.getStringRepresentation());
	}

	/**
	 * Recreates a genre from a given string representation.
	 * Compares the returned stringrep from the genre to one that
	 * is inputted
	 * 
	 */
	@Test
	public void testRecreateGenre() {
		ArrayList<String> songList = new ArrayList<String>();
		songList.add("Song 1");
		songList.add("Song 2");
		songList.add("Song 3");
		Album testAlbum = new Album("Title","Performer", songList);
		Album testAlbum2 = new Album("Title2","Performer2",songList);
		Album testAlbum3 = new Album("Title3","Performer3",songList);
		Genre newGenre = new Genre("Metal");
		Genre subGenre = new Genre("Thrash Metal");
		newGenre.addToGenre(subGenre);
		testAlbum.addToGenre(newGenre);
		testAlbum2.addToGenre(newGenre);
		testAlbum3.addToGenre(subGenre);
		String stringRepresentation = "Metal\n    Title|Performer|[Song 1, Song 2, Song 3]\n    Title2|Performer2|[Song 1, Song 2, Song 3]\n    Thrash Metal\n        Title3|Performer|[Song 1, Song 2, Song 3]";
		String compareString = "Metal\n    Title|Performer|[Song 1, Song 2, Song 3]\n    Title2|Performer2|[Song 1, Song 2, Song 3]\n    Thrash Metal\n        Title3|Performer|[Song 1, Song 2, Song 3\n";
		Genre restored = Genre.restoreCollection(stringRepresentation);
		assertEquals(compareString,restored.getStringRepresentation());
	}
	
	

	/**
	 * Saves the catalogue to a file and then compares the 
	 * contents of the file to another file that contains
	 * the correct data
	 * @throws FileNotFoundException
	*/
	@Test
	public void testSaveCatalogue() throws FileNotFoundException {
		Catalogue testCatalogue = new Catalogue();
		Genre mainGenre = new Genre("MainGenre");
		Genre mainGenre2 = new Genre("MainGenre2");
		Genre subGenre2a = new Genre("SubGenre2a");
		ArrayList<String> songlist = new ArrayList<String>();
		songlist.add("Song 1");
		songlist.add("Song 2");
		Album album1 = new Album("Album1","Artist1",songlist);
		Album album2 = new Album("Album2","Artist2",songlist);
		Album album3 = new Album("Album3","Artist3",songlist);
		Album album3a = new Album("Album3a","Artist3a",songlist);
		album1.addToGenre(mainGenre);
		album2.addToGenre(mainGenre2);
		mainGenre2.addToGenre(subGenre2a);
		album3.addToGenre(subGenre2a);
		album3a.addToGenre(subGenre2a);
		//add these genres to the list
		testCatalogue.rootList.add(mainGenre);
		testCatalogue.rootList.add(mainGenre2);
		try {
			testCatalogue.saveCatalogueToFile("SampleCatalogue.txt");
		}
		catch(FileNotFoundException e) {
			System.out.println("The file does not exist!");
			System.exit(0);
		}
		//now compare the contents of the two files line by line
		boolean comparison = true;
		Scanner thisCatalogue = new Scanner(new FileReader("SampleCatalogue.txt"));
		Scanner testData = new Scanner(new FileReader("TestData.txt"));
		while (thisCatalogue.hasNextLine()) {
			if(!thisCatalogue.nextLine().equals(testData.nextLine())) {
				comparison = false;
			}
		}
		thisCatalogue.close();
		testData.close();
		
		assertEquals(comparison,true);
	}

	/**
	 * Recreates the catalogue from a file. This will
	 * compare the string form of the recreation to one that
	 * is inputted as a separate string. Both of these
	 * string are stored in separate files
	 * 
	 * @throws FileNotFoundException
	 */
	@Test
	public void testRecreateCatalogue() throws FileNotFoundException {
		try{
			Catalogue thisCatalogue = new Catalogue("SampleCatalogue.txt");
			thisCatalogue.saveCatalogueToFile("RecreatedCat.txt");
		}
		catch(FileNotFoundException e){
			System.out.println("The file SampleCatalogue.txt does not exist!");
			System.exit(0);
		}
		
		//now compare the contents of the two files line by line
		boolean comparison = true;
		Scanner thisCatalogue1 = new Scanner(new FileReader("RecreatedCat.txt"));
		Scanner testCat = new Scanner(new FileReader("testCat.txt"));
			while (thisCatalogue1.hasNextLine()) {
				if(!thisCatalogue1.nextLine().equals(testCat.nextLine())) {
					comparison = false;
				}
			}
			thisCatalogue1.close();
			testCat.close();
				
			assertEquals(comparison,true);
	}
	


	/**
	 * An album can only be in one genre or subgenre at a time but not both.
	 * This test will add an album to multiple genres and then check to see if 
	 * its only in the last one. Genres can contain unlimited subgenres.
	 */
	@Test
	public void testGenreInclusion() {
		ArrayList<String> songList = new ArrayList<String>();
		songList.add("Song 1");
		Album testAlbum = new Album("Album 1","Performer", songList);
		Genre mainGenre = new Genre("Classical");
		Genre mainGenre2 = new Genre("Electro");
		Genre subGenre = new Genre("House");
		
		//shuffle the album through many genres
		mainGenre2.addToGenre(subGenre);
		testAlbum.addToGenre(mainGenre);
		testAlbum.addToGenre(mainGenre2);
		testAlbum.addToGenre(subGenre);
		
		assertEquals(subGenre.getName(), testAlbum.getGenre().getName());
	}
	

	
}
