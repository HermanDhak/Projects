package mp5;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;

public class MP5 {
	private static void displayPath(List<Character> path){
		if (path.isEmpty()) {
			System.out.println("No path exists between these characters!");
		}
		else {
			System.out.print(path.get(0));
			for (int i = 1; i < path.size(); i++)
			System.out.print("--> " + path.get(i));
		}
		System.out.println("\n");
	}
	
	/**
	 * This method allows user to be "interactive" with the program
	 * Easy and fast if multiple queries need to be done on a graph
	 * @throws IOException
	 */
	public static void interactive() throws IOException{
		List<Character> path;
		String character1, character2;
		
		InputStreamReader isr=new InputStreamReader(System.in);
		System.out.println("Generating graph, please wait no longer than 30 seconds...");
		Graph ob=new Graph("labeled_edges.tsv");
		GraphSearch search=new GraphSearch();
		Character c1,c2;
		BufferedReader br=new BufferedReader(isr);
		long start,end;
		while(true){
			System.out.print("Enter a character : ");
			character1 = br.readLine();
			character1=character1.toUpperCase();
			if(character1.equals("EXIT")){
				return;
			}
			System.out.print("Enter another character : ");
			character2 = br.readLine();
			character2=character2.toUpperCase();
			if(character2.equals("EXIT")){
				return;
			}
			System.out.println("Finding path between the two characters...");
			c1=ob.getCatalogue().getCharacter(new Character(character1));
			c2=ob.getCatalogue().getCharacter(new Character(character2));
			path = search.findPath(c1,c2); //find the path between these two characters
			displayPath(path);
		}
	}
	
	public static void printUsage(){
		System.out.println("*** MP5 - L1A2 - THE MARVEL UNIVERSE ***");
		System.out.println();
		System.out.println("->java -jar mp5.jar : Prints the help page");
		System.out.println("->java -jar mp5.jar central : Calculates the most central character(s) in the universe");
		System.out.println("->java -jar mp5.jar \"char 1\" \"char 2\" : Prints the path between the 2 charcaters");
		System.out.println("->java -jar mp5.jar interactive : Enters the interactive mode for repeated queries on the graph");
		System.out.println("->Any other illegal command prints this help page");
		System.out.println("Note that the case for charcater names is ignored");
		
	}
	
	public static void main(String[] args) throws IOException{
		if(args.length==0){//print usage
			printUsage();
		}else if((args.length==1)&&(args[0].equals("central"))){//centrality
			System.out.println("Building Graph..");
			Graph graph=new Graph("labeled_edges.tsv");
			System.out.println("Finding most central character(s)..");
			GraphSearch search=new GraphSearch();
			System.out.println("Most central character(s) are:");
			System.out.println(search.getCentralLookOnlyAtNeighbors(graph));
		}else if((args.length==1)&&(args[0].equals("interactive"))){//interactive
			interactive();
		}else if(args.length==2){//path between 2 characters
			System.out.println("Building graph..");
			Graph graph=new Graph("labeled_edges.tsv");
			Character c1,c2;
			System.out.println("Finding path...");
			c1=graph.getCatalogue().getCharacter(new Character(args[0].toUpperCase()));
			c2=graph.getCatalogue().getCharacter(new Character(args[1].toUpperCase()));
			GraphSearch search=new GraphSearch();
			List<Character> path=search.findPath(c1, c2);
			displayPath(path);
		}else{
			printUsage();
		}
	}	
}