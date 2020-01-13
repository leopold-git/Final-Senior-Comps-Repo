# Final-Senior-Comps-Repo
Image Processing Program for Diagnosis of Skin Lesion Images via Convolutional Neural Networks. Visualizations of data via D3.js


Leopold Ringmayr

Leopold_Ringmayr_Comps_FinalReport.pdf is the final report for this project.

The folder COMPS MODELS contains MATLAB code for the neural networks

The folder CompsVisual contains JavaScript, HTML, CSS, csv files for the visualizations.

The file separate.java is used to read and move images from the HAM10000 dataset into subfolders with names that correspond to the label names.

The file separateAge.java uses the HAM10000 metadata csv to find the frequencies of lesions across different age groups this is then used to create a new csv that is used for the radial stacked bar chart.  


The original HAM 10000dataset can be downloaded at https://www.kaggle.com/kmader/skin-cancer-mnist-ham10000 (also listed in Works Cited). 


--------

COMPS MODELS folder:

To train models and test models, the following files must be run: 
alexModel.m, resModel.m, ownModel.m,

To load saved models and use bootstrap resampling and t-tests on the results, run the file bootModels.mlx

Note: LesionClasses contains the image data--separated into seven subfolders. 


--------

CompsVisual folder:

(The HAM10000 csv with the metadata is also included).

To see the radial stacked bar chart: open the radial folder and open index.html in the Chrome web browser. Make sure to use a web server such as MAMP, Apache, etc. (framework for the stacked bar chart open-source code from D3js.org--and is referenced in works cited). 


To see the spider chart: open the tester.html file in Chrome. Under: 
http://localhost/tester.html

To see the bubble chart: open the diy.html file in Chrome. Under:
http://localhost/diy.html
