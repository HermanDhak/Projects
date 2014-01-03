package mp5_tests;

import static org.junit.Assert.*;
import mp5.Catalogue;
import mp5.Graph;

import org.junit.Test;

public class GraphTest {

	/**
	 * This test simply makes the main graph being used in this project. JUnit
	 * is used for measuring the time.
	 **/
	@Test
	public void makeMainGraph() {
		Graph ob = new Graph("labeled_edges.tsv");
	}

	/**
	 * 1 of 2 A test graph is constructed that is similar in structure to the
	 * main one being used in the program but is smaller in size. If this works
	 * then the larger one should work in theory as well. It contains 8 books
	 * and 14 unique characters. The same character may appear in many books but
	 * there shouldn't be any duplicates in a book. This test ensures that the
	 * catalog contains a unique set of all the characters and books in the
	 * file.
	 **/
	@Test
	public void makeTestGraph1() {
		boolean similarCatalogue = true;
		String bookList = "[Book - 1, Book - 2, Book - 3, Book - 4, Book - 5, Book - 6, Book - 7, Book - 8]";
		String charList = "[A, B, C, E, D, F, N, G, H, I, J, K, L, M]";
		Graph ob = new Graph("testfile.tsv");
		Catalogue testCatalogue = ob.getCatalogue();
		if (!testCatalogue.getListBooks().toString().equals(bookList)) {
			similarCatalogue = false;
		}
		if (!testCatalogue.getListCharacters().toString().equals(charList)) {
			similarCatalogue = false;
		}
		assertTrue(similarCatalogue);
	}

	/**
	 * 2 of 2 This is a continuation of the above test. This test is checking
	 * ensures that the references between each book and character has been
	 * updated correctly in the graph making process. The list of characters in
	 * each book is compared to a provided list.
	 **/
	@Test
	public void makeTestGraph2() {
		boolean reference = true;
		Graph ob = new Graph("testfile.tsv");
		Catalogue testCatalogue = ob.getCatalogue();
		String characters[] = { "[A, B, C, E]", "[C, D, E, F]", "[F, E]",
				"[E, N, G, H]", "[F, I, G, J]", "[H, K, J]", "[J, K, L, M]",
				"[N, K]" };
		for (int i = 0; i < testCatalogue.getListBooks().size(); i++) {
			if (!testCatalogue.getListBooks().get(i).getListCharacters().toString().equals(characters[i])) {
				reference = false; // if at any point, the references don't match up, set a flag
			}
		}
		assertTrue(reference);
	}

}
