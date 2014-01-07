package mp5_tests;

import static org.junit.Assert.*;
import org.junit.*;
import mp5.Book;
import mp5.Catalogue;
import mp5.FileParser;
import mp5.Graph;
import mp5.GraphSearch;
import mp5.Character;

public class GraphSearchTest {

	/**
	 * This test searches for the most central character in its universe given
	 * in a file by determining which character has the most neighbors
	 **/
	@Test
	public void getCentralityTest() {
		Graph objectGraph = new Graph("labeled_edges.tsv");
		GraphSearch searchGraph = new GraphSearch();
		assertEquals(searchGraph.getCentralLookOnlyAtNeighbors(objectGraph).toString(),"[CAPTAIN AMERICA]");
	}
	
	/**
	 *  Tests data parsing and graph building operations in isolation
	 */
	 @Test 
     public void dataParse(){
             Graph objectGraph = new Graph("testfile.tsv");
             GraphSearch searchGraph = new GraphSearch();
             Character c1,c2;
             c1 = objectGraph.getCatalogue().getCharacter(new Character("A"));
             c2 = objectGraph.getCatalogue().getCharacter(new Character("L"));
             assertEquals(searchGraph.findPath(c1,c2).toString(), "[A, C, F, J, L]");
	 }
	 
	 /**
	  *  Tests centrality with a given tolerance based on the depth of the node
	  */
	 @Test
     public void searchGraphTest(){
             Graph objectGraph = new Graph("testfile.tsv");
             GraphSearch search = new GraphSearch();
             int tolerance = 1;
             assertEquals(search.getCentral(objectGraph,tolerance).toString(),"[F, N, G, H]");
     }
	 
}
