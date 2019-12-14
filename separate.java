import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.util.*;

public class separate {
	public static void main(String[] args) {
		
		
	
			// THIS IS FOR THE CSV METADATA
			HashMap<String, String> nameToClass = new HashMap<>(); 
			    ArrayList<String> local = new ArrayList<String>();
			File metaFile = new File("/Users/macbookpro17/Documents/skin-cancer-mnist-ham10000(1)/HAM10000_metadata.csv");
			try{
				Scanner inputStream = new Scanner(metaFile);
				while(inputStream.hasNext()){
					String csvLine = inputStream.nextLine();
					String[] lesionClass = csvLine.split(",");
					// print values of c

					nameToClass.put(lesionClass[2] ,lesionClass[6]);
					local.add(lesionClass[6]);
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



				for(int i = 1; i < 1096; i++){
					if (local.get(i).equals("lower extremity")){
								lowerext++;
					}
								if ( local.get(i).equals("face")){
										face++;
					}
								if (local.get(i).equals("abdomen")){
										abdomen++;
					}
								if (local.get(i).equals("hand")){
										hand++;
					}
								if (local.get(i).equals("foot")){
											foot++;
					}
								if ( local.get(i).equals("upper extremity")){
										upperext++;
					}
								if ( local.get(i).equals("genitals")){
									gen++;
					}
								if ( local.get(i).equals("chest")){
										chest++;
					}
								if (local.get(i).equals("back")){
										back++;
					}
										if (local.get(i).equals("trunk")){
													trunk++;
					}
										if (local.get(i).equals("scalp")){
													scalp++;
					}
										if (local.get(i).equals("neck")){
													neck++;
					}


				}
	

				System.out.println(neck);
				System.out.println(upperext);

				System.out.println(hand);

				System.out.println(foot);

				System.out.println(gen);

				System.out.println(back);

				System.out.println(scalp);


				System.out.println(lowerext);

				System.out.println(trunk);

				System.out.println(face);

				System.out.println(abdomen);

				System.out.println(chest);
			} catch (FileNotFoundException e){
				e.printStackTrace();



			


			}
			
			
			

	}
}