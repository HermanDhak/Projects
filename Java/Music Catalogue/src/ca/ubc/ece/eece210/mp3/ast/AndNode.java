package ca.ubc.ece.eece210.mp3.ast;

import java.util.*;

import ca.ubc.ece.eece210.mp3.Element;
import ca.ubc.ece.eece210.mp3.Catalogue;

/**
 * 
 * @author Herman Dhak
 *
 */

public class AndNode extends ASTNode {

    public AndNode(Token token) {
	super(token);
    }
    
    
    /** Finds the intersection of the children sets
     * @param argument, the catalogue which contains the albums
     * @return the set of elements which contains the discovered albums
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
        //go through each set and AND the first set with ith set
        for(int i = 1; i < totalNodes; i++){
        		scannedSets.get(0).retainAll(scannedSets.get(i));
        }
        //this set contains the intersection of all the sets stored in the interpreted sets list
        return scannedSets.get(0);
    }

}
