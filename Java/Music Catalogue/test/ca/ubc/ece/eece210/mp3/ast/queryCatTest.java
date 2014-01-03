package ca.ubc.ece.eece210.mp3.ast;
import ca.ubc.ece.eece210.mp3.*;
import static org.junit.Assert.*;

import java.io.*;
import java.util.*;

import org.junit.Test;

public class queryCatTest {

	
	/**
	 * Tests the "in" search query. Uses data supplied in the mp4 spec sheet.
	 * There are 2 albums in the jazz genre so this should only return those 2 albums
	 * (1 is in the main genre other is in a subgenre)
	 */
	@Test
    public void inNodeTest() {
            Catalogue testCatalogue = new Catalogue();
            ArrayList<String> songList = new ArrayList<String>();
            songList.add("Song1");songList.add("Song2");songList.add("Song3");
            Genre jazz = new Genre("Jazz");
            Genre subJazz = new Genre("Psychedlic Jazz");
            Genre cinema = new Genre("Cinema");
            Album album1 = new Album("Louis and the Angels", "Louis Armstrong", songList);
            Album album2 = new Album("Crossings", "Herbie Hancock", songList);
            Album album3 = new Album("The Talented Mr. Ripley", "Gabriel Yared", songList);
            album1.addToGenre(jazz);
            jazz.addToGenre(subJazz);
            album2.addToGenre(subJazz);
            album3.addToGenre(cinema);
            testCatalogue.rootList.add(jazz);
            testCatalogue.rootList.add(cinema);
            InNode ingenre = new InNode(null);
            ingenre.arguments="Jazz";
            Set<Element> albums=ingenre.interpret(testCatalogue);  
            assertEquals(albums.toString(), "[Crossings|Herbie Hancock|[Song1, Song2, Song3], Louis and the Angels|Louis Armstrong|[Song1, Song2, Song3]]");
    }
    
	/**
	 * Tests the "matches" search query. 
	 * There is only one album (album 2) that matches the query so that should be the only
	 * one returned out of all 4 albums.
	 */
    @Test
    public void matchesNodeTest() {
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
            List<Album> testList = new ArrayList<Album>();
            testList.add(album2);
            
            assertEquals(testList, testCatalogue.queryCat("matches (\".*Album2.*\")"));
    }
    
    /**
	 * Tests the "by" search query. 
	 * There are two albums (Album1 and Album3a) out of 4 made by Artist1.
	 * Only those 2 are discovered.
	 */
    @Test
    public void byNodeTest() {
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
            Album album3a = new Album("Album3a","Artist1",songlist);
            album1.addToGenre(mainGenre);
            album2.addToGenre(mainGenre2);
            mainGenre2.addToGenre(subGenre2a);
            album3.addToGenre(subGenre2a);
            album3a.addToGenre(subGenre2a);
            //add these genres to the list
            testCatalogue.rootList.add(mainGenre);
            testCatalogue.rootList.add(mainGenre2);
            List<Album> testList = new ArrayList<Album>();
            testList.add(album3a);
            testList.add(album1);
            
            assertEquals(testList, testCatalogue.queryCat("by (\"Artist1\")"));
            
    }
    
    /**
   	 * Tests the "and" search query. 
   	 * There is only 1 albums made by artist1 with the title album1 so that is
   	 * the only one returned.
   	 */
    @Test
    public void andNodeTest() {
            Catalogue testCatalogue = new Catalogue();
            Genre mainGenre = new Genre("MainGenre");
            Genre mainGenre2 = new Genre("MainGenre2");
            Genre subGenre2a = new Genre("SubGenre2a");
            ArrayList<String> songlist = new ArrayList<String>();
            songlist.add("Song 1");
            songlist.add("Song 2");
            Album album1 = new Album("Album1","Artist1",songlist);
            Album album2 = new Album("Album2","Artist1",songlist);
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
            List<Album> testList = new ArrayList<Album>();
            testList.add(album1);
            
            assertEquals(testList, testCatalogue.queryCat("by (\"Artist1\") && matches (\"Album1\")"));
    }

    /**
	 * Tests the "or" search query. Uses data supplied in the mp4 spec sheet.
	 * There is 1 matching album in the main genre and another is in a subgenre.
	 * Both should be returned.
	 */
    @Test
    public void orNodeTest() {
    		Catalogue testCatalogue = new Catalogue();
        	ArrayList<String> songList = new ArrayList<String>();
         	songList.add("Song1");songList.add("Song2");songList.add("Song3");
         	Genre jazz = new Genre("Jazz");
         	Genre subJazz = new Genre("Psychedlic Jazz");
         	Genre cinema = new Genre("Cinema");
         	Album album1 = new Album("Louis and the Angels", "Louis Armstrong", songList);
         	Album album2 = new Album("Crossings", "Herbie Hancock", songList);
         	Album album3 = new Album("The Talented Mr. Ripley", "Gabriel Yared", songList);
         	album1.addToGenre(jazz);
         	jazz.addToGenre(subJazz);
         	album2.addToGenre(subJazz);
         	album3.addToGenre(cinema);
         	testCatalogue.rootList.add(jazz);
         	testCatalogue.rootList.add(cinema);
         	String query="in (\"Jazz\") || in (\"Psychedelic Jazz\")";
            List<Album> albums = testCatalogue.queryCat(query);
            assertEquals(albums.toString(),"[Crossings|Herbie Hancock|[Song1, Song2, Song3], Louis and the Angels|Louis Armstrong|[Song1, Song2, Song3]]");
    }
    
    /**
     * This tests multiple types of queries. 
     * It should return an album from each main genre, and none for the subgenre.
     */
    @Test
    public void complexTest1() {
    	 Catalogue testCatalogue = new Catalogue();
         ArrayList<String> songList = new ArrayList<String>();
         songList.add("Song1");songList.add("Song2");songList.add("Song3");
         Genre jazz = new Genre("Jazz");
         Genre subJazz = new Genre("Psychedlic Jazz");
         Genre cinema = new Genre("Cinema");
         Album album1 = new Album("Louis and the Angels", "Louis Armstrong", songList);
         Album album2 = new Album("Crossings", "Herbie Hancock", songList);
         Album album3 = new Album("The Talented Mr. Ripley", "Gabriel Yared", songList);
         album1.addToGenre(jazz);
         jazz.addToGenre(subJazz);
         album2.addToGenre(subJazz);
         album3.addToGenre(cinema);
         testCatalogue.rootList.add(jazz);
         testCatalogue.rootList.add(cinema);
         String query="in (\"Jazz\") && by (\"Louis Armstrong\") || matches (\".*Ripley.*\")";
         List<Album> albums = testCatalogue.queryCat(query);
         assertEquals(albums.toString(),"[Louis and the Angels|Louis Armstrong|[Song1, Song2, Song3], The Talented Mr. Ripley|Gabriel Yared|[Song1, Song2, Song3]]");
          
    } 
    

    /**
     * Another test which tests multiple queries.
     * It should return 3 albums in total based on the queries made.
     * In order to prove that the query is legit, the string representation
     * has been printed out so you can make your own query and compare.
     */
    @Test
    public void complexTest2() {
    	 Catalogue testCatalogue = new Catalogue();
         ArrayList<String> songList = new ArrayList<String>();
         songList.add("Song1");songList.add("Song2");songList.add("Song3");
         Genre jazz = new Genre("Jazz");
         Genre subJazz = new Genre("Psychedlic Jazz");
         Genre subJazz2 = new Genre("Techno Jazz");
         Genre cinema = new Genre("Cinema");
         Album album1 = new Album("Louis and the Angels", "Louis Armstrong", songList);
         Album album2 = new Album("Crossings", "Herbie Hancock", songList);
         Album album3 = new Album("The Talented Mr. Ripley", "Gabriel Yared", songList);
         Album album4 = new Album("ImNumber1", "Louis Armstrong", songList);
         album1.addToGenre(jazz);
         jazz.addToGenre(subJazz2);
         jazz.addToGenre(subJazz);
         album2.addToGenre(subJazz);
         album4.addToGenre(subJazz2);
         album3.addToGenre(cinema);
         testCatalogue.rootList.add(jazz);
         testCatalogue.rootList.add(cinema);
         System.out.println(testCatalogue.getStringRepresentation());  
         String query = "(by (\"Louis Armstrong\") && in (\"Techno Jazz\") || by(\"Herbie Hancock\")) || matches (\".*Ripley.*\")";
         List<Album> albums = testCatalogue.queryCat(query);
         assertEquals(albums.toString(),"[Crossings|Herbie Hancock|[Song1, Song2, Song3], "
                 + "ImNumber1|Louis Armstrong|[Song1, Song2, Song3], "
                 + "The Talented Mr. Ripley|Gabriel Yared|[Song1, Song2, Song3]]");
    } 

}

	
