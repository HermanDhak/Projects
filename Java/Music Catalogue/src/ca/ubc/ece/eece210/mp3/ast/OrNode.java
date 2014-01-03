package ca.ubc.ece.eece210.mp3.ast;


import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import ca.ubc.ece.eece210.mp3.Element;
import ca.ubc.ece.eece210.mp3.Catalogue;

public class OrNode extends ASTNode {

    public OrNode(Token token) {
	super(token);
    }

    /**
     * Finds the the union of all children sets
     * @param argument: the catalogue that is being searched
     * @return: the set that contains the union of all sets
     * 
     */
    @Override
    public Set<Element> interpret(Catalogue argument) {
    	List<Set<Element>> scannedSets=new ArrayList<Set<Element>>();
        int totalNodes = 0;
        totalNodes = children.size();
        //store the set of children AST nodes in a list recursively
        for(int i = 0; i < totalNodes; i++){
                scannedSets.add(children.get(i).interpret(argument));
        }
        //go through each set and OR the first set with ith set
        for(int i = 1; i < totalNodes; i++){
        		scannedSets.get(0).addAll(scannedSets.get(i));
        }
        //this set contains union of all the sets stored in the interpreted sets list
        return scannedSets.get(0);
    }

}


