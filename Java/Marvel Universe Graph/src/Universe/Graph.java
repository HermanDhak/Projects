package mp5;

public class Graph {
	
	private Catalogue catalogue;//stores the list of books and characters for graph
	private FileParser parser;//parser used for parsing through the file
	
	/**
	 * Creates a graph from the file specified
	 * @param fileName - the file using which the graph will be made
	 * Requires: The file has to exist
	 */
	public Graph(String fileName){
		catalogue=new Catalogue();
		parser=new FileParser(fileName);
		makeGraph();
		parser.closeFile();
	}
	
	/**
	 * Gets the "library" and "universe" associated with this graph
	 * @return - the library of this graph
	 */
	public Catalogue getCatalogue(){
		return catalogue;
	}
	
	/**
	 * parses through the file and updates the "catalogue" object,
	 * hence making a graph
	 */
	private void makeGraph(){
		//Refer to the notes drawn on the piece of paper
		Book currentBook=null;
		Character currentCharacter=null;
		if(parser.hasNext()){
			parser.next();
		}else{
			return;
		}
		do{
			if(!(parser.hasNext())){
				break;
			}
			currentBook=parser.getBook();
			catalogue.addToLibrary(currentBook);
			
			do{
				currentCharacter=parser.getCharacter();
				if(catalogue.universeContains(currentCharacter)){
					Character actualCharacter=catalogue.getCharacter(currentCharacter);
					currentBook.addCharacter(actualCharacter);
					actualCharacter.addBook(currentBook);
				}else{
					catalogue.addToUniverse(currentCharacter);
					currentBook.addCharacter(currentCharacter);
					currentCharacter.addBook(currentBook);
				}
				if(parser.hasNext()){
					parser.next();
					if(parser.getBook().equals(currentBook)){
						continue;
					}else{
						break;
					}
				}else{
					break;
				}
			}while(true);
		}while(true);
	}
	
}
