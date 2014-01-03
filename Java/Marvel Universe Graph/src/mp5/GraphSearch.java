package mp5;

import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.PriorityQueue;
import java.util.Queue;
import java.util.Set;

public class GraphSearch {
	
	List<Character> visitedNodesMaster;//a list of all of the 
	
	/**
	 * Constructs a new GraphSearch object with an empty visitedNodesMaster list
	 */
	public GraphSearch(){
		visitedNodesMaster=new LinkedList<Character>();
	}
	
	/**
	 * Gets the neighbors of the given character in a graph
	 * @param character - its neighbors are returned
	 * @return neighbors of the given character
	 */
	private Set<Character> getNeighbors(Character character){
		Set<Character> neighbors=new LinkedHashSet<Character>();
		Iterator<Book> books=character.getListBooks().iterator();//books which 
										//the character is associated with
		
		Iterator<Character> tempNeighbors;
		//iterate through all the books associated with this character
		while(books.hasNext()){
			//get the iterator for the list of books in the "next" book
			tempNeighbors=books.next().getListCharacters().iterator();
			while(tempNeighbors.hasNext()){
				neighbors.add(tempNeighbors.next());
			}
		}
		neighbors.remove(character);//finally remove the character itself, as it
		//is not its own neighbor
		return neighbors;
	}
	
	/**
	 * Gets the worklist for the given NodePathTree object
	 * (Arranged in alphabetically ascending order)
	 * @param character
	 * @return
	 */
	private Queue<NodePathTree> getWorklist(NodePathTree nodeChar){
		Queue<NodePathTree> worklist=new PriorityQueue<NodePathTree>();//sorted ascending
		Iterator<Character> neighbors=getNeighbors(nodeChar.getCharacter()).iterator();
		Character tempChar;
		while(neighbors.hasNext()){
			tempChar=neighbors.next();
			if(visitedNodesMaster.contains(tempChar)){
				continue;
			}else{
				worklist.add(new NodePathTree(tempChar,nodeChar));//add this node to worklist
				visitedNodesMaster.add(tempChar);//add it to visitedNodesMaster
			}
		}
		return worklist;
	}
	
	/**
	 * Finds the lexicographically shortest path from first character to second 
	 * @param fisrtChar
	 * @param secondChar
	 */
	public List<Character> findPath(Character firstChar, Character secondChar){
		//the characters would be null if they don't exist in the graph:
		if((firstChar==null)||(secondChar==null)){
			return new LinkedList<Character>();
		}
		
		List<Queue<NodePathTree>> list1=new LinkedList<Queue<NodePathTree>>();
		List<Queue<NodePathTree>> list2=new LinkedList<Queue<NodePathTree>>();
		
		//add first character to list1:
		Queue<NodePathTree> tempQueue=new PriorityQueue<NodePathTree>();
		tempQueue.add(new NodePathTree(firstChar,null));
		list1.add(tempQueue);
		
		//Temporary variables used in the following nested loops:
		//-------------------------------------------------------
		Iterator<Queue<NodePathTree>> iter;
		Queue<NodePathTree> queue;
		NodePathTree node;
		Queue<NodePathTree> worklist;
		//-------------------------------------------------------
		
		while(list1.size()>0){
			iter=list1.iterator();
			while(iter.hasNext()){
				queue=iter.next();
				while(queue.size()>0){
					node=queue.poll();
					if(node.getCharacter().equals(secondChar)){
						visitedNodesMaster.clear();//Empty the visitedNodesMaster for next call
						//to findPath()
						return getPathFromNodePathTree(node);
					}else{
						worklist=getWorklist(node);
						if(worklist.size()==0){
							//Dont add it to list2
						}else{
							list2.add(worklist);
						}
					}
				}
			}
			list1=new LinkedList<Queue<NodePathTree>>(list2);
			list2.clear();
		}
		visitedNodesMaster.clear();//Empty the visitedNodesMaster for next call
		//to findPath()
		return new LinkedList<Character>();
	}
	
	/**
	 * Gets the path given a NodePathTree from its oldest parent to it
	 * @param node
	 * @return - List of characters from its oldest parent to it
	 */
	private List<Character> getPathFromNodePathTree(NodePathTree node){
		LinkedList<Character> stackPath=new LinkedList<Character>();//used as a stack
		List<Character> path=new LinkedList<Character>();
		do{
			stackPath.push(node.getCharacter());
			if(node.getParent()!=null){
				node=node.getParent();
				continue;
			}else{
				break;
			}
		}while(true);
		//convert the stack to a list:
		while(stackPath.size()>0){
			path.add(stackPath.pop());
		}
		return path;
	}
	
	/**
	 * Finds the depth of the neighbor tree for a given character
	 * Returns infinite if:
	 * ->the character is not related to any other character
	 * ->the character passed to this method is null
	 * ->is connected to less than "tolerance" number of characters
	 * @param character
	 * @param tolerance - minimum number of characters expected in the
	 * biggest part of the universe, must be less than the number of characters in the biggest group
	 */
	public int findDepth(Character character,int tolerance){
		if(character==null){
			return Integer.MAX_VALUE;
		}
		int depth=0;//depth of the tree
		
		int toleranceCounter=0;
		
		visitedNodesMaster.add(character);
		
		List<Queue<NodePathTree>> list1=new LinkedList<Queue<NodePathTree>>();
		List<Queue<NodePathTree>> list2=new LinkedList<Queue<NodePathTree>>();
		
		//add first character to list1:
		Queue<NodePathTree> tempQueue=new PriorityQueue<NodePathTree>();
		tempQueue.add(new NodePathTree(character,null));
		list1.add(tempQueue);
		
		//Temporary variables used in the following nested loops:
		//-------------------------------------------------------
		Iterator<Queue<NodePathTree>> iter;
		Queue<NodePathTree> queue;
		NodePathTree node;
		Queue<NodePathTree> worklist;
		//-------------------------------------------------------
		
		while(list1.size()>0){
			iter=list1.iterator();
			while(iter.hasNext()){
				queue=iter.next();
				while(queue.size()>0){
					node=queue.poll();		
					worklist=getWorklist(node);
					if(worklist.size()==0){
						//Dont add it to list2
					}else{
						list2.add(worklist);
						toleranceCounter=toleranceCounter+worklist.size();
					}
				}
			}
			//System.out.println(list2);
			depth++;
			list1=new LinkedList<Queue<NodePathTree>>(list2);
			list2.clear();
		}
		
		//System.out.println("Num chars related to : "+toleranceCounter);
		
		visitedNodesMaster.clear();//Empty the visitedNodesMaster for next call
		//to findPath()
		
		//------------------------------------------------
		//This character is not related to any other character
		if(depth==1){
			return Integer.MAX_VALUE;//depth is infinite
		}
		//------------------------------------------------
		
		//This character is part of a small group and not related to the bigger
		//part of the universe
		if(toleranceCounter<tolerance){
			return Integer.MAX_VALUE;//depth is infinite
		}
		//------------------------------------------------

		return depth;
	}
	
	/**
	 * Finds the central most characters of the universe
	 * Uses a "stronger" but slower definition of centrality
	 * This algorithm finds the distance between a character and the farthest character
	 * from it, and assigns these rankings to each character.
	 * @param graph - the graph to search for
	 * @param tolerance - minimum number of characters expected to be in the biggest group
	 * of the universe, must be less than the number of characters in the biggest group
	 * @return - a list of most central characters
	 */
	public List<Character> getCentral(Graph graph, int tolerance){
		List<Character> characters=graph.getCatalogue().getListCharacters();
		List<Character> centralChars=new LinkedList<Character>();
		List<Integer> depths = new LinkedList<Integer>();
		Iterator<Character> iterChar=characters.iterator();
		Iterator<Integer> iterDepths;
		while(iterChar.hasNext()){
			depths.add((findDepth(iterChar.next(),tolerance)));
		}
		iterDepths=depths.iterator();
		int min=depths.get(0);
		int current;
		
		while(iterDepths.hasNext()){
			current=iterDepths.next();
			if(current<min){
				min=current;
			}
		}
		
		int index = 0;
		List<Integer> indecesMinimum=new LinkedList<Integer>();
		iterDepths=depths.iterator();
		while(iterDepths.hasNext()){
			if(iterDepths.next()==min){
				indecesMinimum.add(index);
			}
			index++;
		}
		
		iterChar=characters.iterator();
		index=0;
		Character tempChar;
		while(iterChar.hasNext()){
			tempChar=iterChar.next();
			if(indecesMinimum.contains(index)){
				centralChars.add(tempChar);
			}
			index++;
		}
		return centralChars;
	}
	
	/**
	 * Uses a "weaker" definition of centrality but much faster and pretty accurate
	 * Only looks at the given characters' direct networks (it only looks at characters' 
	 * direct neighbors) to figure out the most central character
	 * @param graph - the graph to search from
	 * @return - a list of most central characters (equal centrality)
	 */
	public List<Character> getCentralLookOnlyAtNeighbors(Graph graph){
		List<Character> centralChars=new LinkedList<Character>();
		List<Character> characters=graph.getCatalogue().getListCharacters();
		List<Integer> numNeighbors = new LinkedList<Integer>();
		for(Character character : characters){
			numNeighbors.add(getNeighbors(character).size());
		}
		int maxValue=0;
		for(Integer current: numNeighbors){
			if(current>maxValue){
				maxValue=current;
			}
		}
		List<Integer> indeces=new LinkedList<Integer>();
		int index=0;
		for(Integer current: numNeighbors){
			if(current==maxValue){
				indeces.add(index);
			}
			index++;
		}
		index=0;
		for(Character character:characters){
			if(indeces.contains(index)){
				centralChars.add(character);
			}
			index++;
		}
		return centralChars;
	}
}
