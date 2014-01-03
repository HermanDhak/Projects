package mp5;

public class NodePathTree implements Comparable<NodePathTree>{
	private NodePathTree parent;
	private Character character;
	
	/**
	 * Constructs a new NodePathTree for the given character
	 * @param character
	 */
	public NodePathTree(Character character, NodePathTree parent){
		this.character=character;
		this.parent=parent;
		parent=null;
	}
	
	/**
	 * Sets the parent of this NodePathTree
	 * @param parent
	 */
	public void setParent(NodePathTree parent){
		this.parent=parent;
	}
	
	/**
	 * gets the character associated with this NodePathTree
	 * @return
	 */
	public Character getCharacter(){
		return character;
	}
	
	/**
	 * Returns the parent of this NodePathTree
	 * @return
	 */
	public NodePathTree getParent(){
		return parent;
	}
	
	
	/**
	 * a compareTo() function based on the associated character's name
	 */
	//@Override
	public int compareTo(NodePathTree node){
		return character.getName().compareTo(node.getCharacter().getName());
	}
	
	@Override
	/**
	 * Same as the toString() method of its character
	 */
	public String toString(){
		return character.toString();
	}
}
