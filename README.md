# Data Science Portfolio
This portfolio includes my favorite and most challenging data science projects performed during both my academic and professional career. It is currently under construction, and will be continually updated to include new projects or to refine and improve existing projects. Some projects required data acquisition from many sources while others simply used one dataset that was already provided. In all cases they required some preprocessing before analysis could begin. The analysis was all performed using either R (R-studio) or Python (Jupyter Notebook). Below lists each project included in this repository with a general description of what the project was about, the tasks required and the major analysis techniques used. The description also provides an overview of the code language used, the packages required and the general statistical or data science techniques demonstrated. These projects span all aspects of data science including data wrangling, statistical analysis, linear modeling, data mining, machine learning, classification, deep learning, natural language processing, computer vision, data visualization and last, but certainly not least, reporting and business recommendations. 

Click the links on each project to be taken directly to the analysis and code.

## Projects:

### [Hotel NPS Analysis](https://github.com/cluceroSy4/Data-Science-Portfolio/blob/master/Hotel%20NPS%20Analysis/IST687%20Project%20Code.R) (Under Construction)
* Extensive analysis of hotel data using R to build a business case for using Net Promoter Score
* Used linear regression to determine the impact of NPS on hotel revenue
* Used SVM model to predict above or below average NPS scores from guest survey responses
* Used Association Rule Mining to determine important combinations of hotel characteristics that may influence NPS
* Uses: R (ggplot2 / Maps / Kernlab), Linear Regression, Support Vector Machines, Assocation Rule Mining

---

### [ARIMA Time Series Forecasting](https://github.com/cluceroSy4/Data-Science-Portfolio/blob/master/ARIMA%20Time%20Series%20Forecasting/Real%20Estate%20Investment%20Markdown%20Files/Real%20Estate%20Investment%20Analysis.md) (Under Construction)
* Predicting top real estate investment opportunities in Python using ARIMA forecasting
* Sources historical real estate data from Zillow, population data from the US Census and real estate LTV values from the Federal Housing Finance Agency
* Used multiple rounds of differencing to achieve stationarity as well as perform ARIMA parameter tuning to find the model with the best root mean squared error (RMSE)
* Uses: Python (Numpy / Pandas / Sklearn / Matplotlib), Autoregressive Integrated Moving Average, Time Series, Forecasting, Study Design and Strategy

---

### [Audience Segmentation - kmeans/hiearchical clustering](https://github.com/cluceroSy4/Data-Science-Portfolio/blob/master/Audience%20Segmentation%20-%20kmeans-hiearchical%20clustering/Audience%20Segmentation%20Analysis.R)
* This project uses clustering techniques to perform audience segmentation of students who responded to a survey
* I designed the study, developed the survey, collected responses, analyzed the findings to create audience segments and created a report to synthesize recommendations into marketing tactics
* Used kmeans and hiearchical clustering techniques with elbow plots to maximize between-cluster variance while minimizing in-cluster variance
* Uses: R (tm / wordcloud), k-means clustering, hierarchical clustering

---

### [Nielsen Ratings Prediction Using Classification](https://github.com/cluceroSy4/Data-Science-Portfolio/blob/master/Nielsen%20Ratings%20Prediction%20-%20SVM%20and%20DataViz/IST565%20Project%20Code.R)
* Predicted high, medium and low Nielsen Ratings based on a television show's run characteristics using various classifiction techniques
* Explored data and tested KNN, Random Forest, SVM and Naive Bayes techniques, ultimately choosing Support Vector Machine
* Created visualization of SVM classification to communicate why the data is best suited for this modeling technique
* Created recommendations on how a tv show could use these findings to negotiate better promo runs in key markets
* Uses: R (RWeka / dplyr / ggplot2 / e1071 / caret / FSelector / RColorBrewer), Random Forest, Support Vector Machine, K Nearest Neighbor, Decision Trees, Naive Bayes, Dimension Reduction, Data Visualization

---

### [Association Rule Mining - Private Equity Plans](https://github.com/cluceroSy4/Data-Science-Portfolio/blob/master/Association%20Rule%20Mining%20-%20Private%20Equity/Private%20Equity%20Association%20Rules%20Analysis.R)
* Determined demographic and banking characteristics that are generally associated with individuals who qualify for Private Equity Plans
* Used Association Rule Mining while optimizing Confidence, Support and Lift to find the most useful associations
* Defined the investment firm's target audiences based on analysis conclusions
* Uses: R (plyr / dplyr / arules / arulesViz), Association Rule Mining

---

### [Determining Authorship Using Cluster Analysis](https://github.com/cluceroSy4/Data-Science-Portfolio/blob/master/Determining%20Authorship%20Using%20Cluster%20Analysis/IST565%20-%20HW4.R)
* Demonstrated the use of clustering techniques to determine authorship of unknown written work
* Used hiearchical and k-means clustering on a dataset of stopwords to determine similarities between known- and unknown-authored work
* Uses: R, K-Means Clustering, Hierarchical Clustering

---

### [Logo Feedback Sentiment Analysis](https://github.com/cluceroSy4/Data-Science-Portfolio/blob/master/Logo%20Feedback%20Sentiment%20Analysis/Scissortail%20Analysis.R)
* Analyzed public feedback on logo design concepts to determine the most positively received concept that achieves established branding goals
* Processed survey response data using NLP techniques, creating custom stopwords lists, removing punctuation and numbers and creating a Term Document Matrix
* Performed sentiment analysis using the AFINN lexicon to determine which concepts received the most positive and negative feedback
* Used word clouds to visualize most frequently used words to find common associations
* Uses: R (tm / wordcloud / ggplot2), Sentiment Analysis, Natural Language Processing, Data Visualization

---

### [Computer Vision - MNIST Fashion](https://github.com/cluceroSy4/Data-Science-Portfolio/blob/master/Computer%20Vision%20-%20MNIST%20Fashion/MNIST%20Fashion%20Analysis.ipynb)
* Classified images of clothing items such as shoes, shirts, blouses, dresses and boots using various techniques 
* Demonstrate various machine learning techniques to determine the most accurate and most efficient models
* Uses the Kaggle MNIST Fashion dataset - similar to the popular Kaggle MNIST dataset - but using clothing items which require more advanced classification techniques to improve accuracy
* Uses: Python (Tensorflow / Pandas / keras / skLearn / matplotlib / numpy), Computer Vision, Convoluntional Neural Network, Logistic Regression, Random Forest, Cross Validation

---

### [Russian Tweets Text Analysis](https://github.com/cluceroSy4/Data-Science-Portfolio/blob/master/Russian%20Tweets%20Text%20Analysis/Russian%20Tweets%20Analysis.ipynb)
* Analyzed Tweets used in the Russian campaign to influence United State's politics and create discord among American populations 
* Used NLP techniques to analyze the content of millions of tweets while processing the unique formatting of tweets (e.g. hashtags) 
* Compared spikes in tweet activity to major historical news events to understand the temporal patterns 
* Uses: Python (Pandas / nltk / matplotlib / collections), Natural Language Processing, Word Clouds, Social Media Analysis, Data Visualization

---

### [NCAA Coach Salary Analysis](https://github.com/cluceroSy4/Data-Science-Portfolio/blob/master/NCAA%20Coach%20Salary%20Analysis/NCAA%20Salary%20Markdown%20Files/IST718Lab1PythonNotebook.md)
* Analyzed NCAA coach and university characteristics such as program revenue, stadium capacity, conference and win-loss record to develop a model to recommend how much a football coach should be paid
* Used advanced data wrangling techniques such as web scraping and fuzzy string matching to create a dataframe ready for data modeling
* Visualized data to show relationships between football teams, coaches and conferences
* Performed OLS regression on cleaned data to create a model used to predict coach salary
* Uses: Python (Pandas / FuzzyWuzzy / numpy / seaborn / matplotlib), Data Acquisition, Data Wrangling, Linear Modeling, Data Visualization

---

### [Text Analysis / Product Categorization - Retail Transactions](https://github.com/cluceroSy4/Data-Science-Portfolio/blob/master/Text%20Analysis%20%26%20Categorization/IST718_Project.ipynb)
* A multi-part project using retail transaction data that transformed data for feature creation, created audience segments based on purchase behavior and developed a model to predict the 1% of customers that make up 30% of total revenue
* Created product categories by processing and analyzing product descriptions using NLP techniques and hierarchical clustering
* Used product categories and other transaction data as features to be used in hiearchical clustering of customers into audience segments
* Used the SMOTE data mitigation technique to deal with the imbalanced data problem
* Used several classification techniques to determine the most accurate model for predicting customer segments based on their purchase patterns and behaviors
* Uses: Python (Pandas / numpy / seaborn / matplotlib / scipy / nltk / re / sklearn / textblob / wordcloud), Data Wrangling, Feature Creation, Data Transformation, Natural Language Processing, Hieararchical Clustering, Support Vector Machines, Word Clouds, Data Visualization, Synthetic Minority Oversampling Technique (SMOTE), Logistic Regression, Random Forest, RegEx, Cross Validation

### Things to add:
* Brand lift study - visualizations (professional)

