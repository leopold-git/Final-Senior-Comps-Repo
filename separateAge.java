import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.util.*;

public class separateAge {
	public static void main(String[] args) {
		
		
	
			// THIS IS FOR THE CSV METADATA
			HashMap<Integer, Integer> nameToClass = new HashMap<>(); 
			    ArrayList<String> local = new ArrayList<String>();
			File metaFile = new File("/Users/macbookpro17/Documents/CompsVisual/age.csv");
			try{
				Scanner inputStream = new Scanner(metaFile);
				int classCounter = 0;
				while(inputStream.hasNext()){
					String csvLine = inputStream.nextLine();
					String[] lesionClass = csvLine.split(",");
					int count = 0;
					// print values of c
					if(lesionClass[1].equals("df")){
					nameToClass.putIfAbsent(Integer.parseInt(lesionClass[0]), 1);
					 count = nameToClass.get(Integer.parseInt(lesionClass[0]));
					}

					 if((lesionClass[1].equals("df") )){
						nameToClass.replace(Integer.parseInt(lesionClass[0]) , count + 1);
					classCounter++;
					}
				}


				inputStream.close();

				// doing this for bkl 
							



			



				int lowerext = 0;
				int back = 0;
				int chest = 0;
				int gen = 0;
				int trunk = 0;
				int upperext = 0;
				int face = 0;
				int neck = 0;
				int scalp = 0;
				int abdomen = 0;
				int hand = 0;
				int foot = 0;


 // Getting an iterator 
        Iterator hmIterator = nameToClass.entrySet().iterator(); 
  
        // Iterate through the hashmap 
        // and add some bonus marks for every student 
       
  
        while (hmIterator.hasNext()) { 
            HashMap.Entry mapElement = (HashMap.Entry)hmIterator.next(); 
            int marks = ((int)mapElement.getValue() ); 
            System.out.println(mapElement.getKey() + "," + marks); 
        } 
	

	
			
			} catch (FileNotFoundException e){
				e.printStackTrace();



			


			}
			
			
			

	}
}