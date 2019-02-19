
# NCAA Football Coach Salary Analysis

## Abstract

The goal of this project was to make a recommendation on the Syracuse head football coaches' salary using linear regression. The initial dataset given was a list of NCAA coaches, their university, football conference and their pay including salary and bonuses. The real challenge was in defining the additional variables to be used in the salary analysis, sourcing them and incorporating them into the dataset. This project demonstrates using linear regression as well as the process of data wrangling. 

## Importing and Cleaning Data

The majority of the time spent on this project involved defining, sourcing and integrating datasets with the coaches salary. The data that was added to the data is as follows:

* Student Athlete Graduation Rate
    * TSV File Download and Import
    * Sourced from Inter-University Consortium for Political and Social Research
* Program Win-Loss Record
    * Parsehub API Web-Scraping Tool / CSV Download and Import
    * NCAA Website
* Football Program Revenue
    * CSV Download and Import
    * U.S. Department of Education
* Football Stadium Capacity
    * Parsehub API Web-Scraping Tool / CSV Download and Import
    * Wikipedia


```python
import os

os.chdir('/Users/coreylucero/Desktop/Syracuse/IST718/Lab 1')

# Import pandas
import pandas as pd # used to load in data
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plot
```

### Coach Salary Dataset

The provided dataset included salaries from most NCAA coaches, however a few of them were left blank. This was a small enough dataset that I was able to source the figures through articles or IRS forms.


```python

file = '/Users/coreylucero/Desktop/Syracuse/IST718/Lab 1/Coaches_2_2_2.xlsx'

xl = pd.ExcelFile(file)
df1 = xl.parse('Coaches') #Save sheet within excel file as a dataframe

#Identify missing values

print('Salary:',(df1['Salary'].isna()).sum())
print('Other Pay:',(df1['OtherPay'].isna()).sum())
print('Total Salary:',(df1['TotalSalary'].isna()).sum())
print('Max Bonus:',(df1['MaxBonus'].isna()).sum())
```

    ['Coaches']





<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Name</th>
      <th>School</th>
      <th>Conference</th>
      <th>Salary</th>
      <th>OtherPay</th>
      <th>TotalSalary</th>
      <th>MaxBonus</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Steve Addazio</td>
      <td>Temple</td>
      <td>Big East</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Robb Akey</td>
      <td>Idaho</td>
      <td>WAC</td>
      <td>375797.0</td>
      <td>6200.0</td>
      <td>381997.0</td>
      <td>158262.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Gary Andersen</td>
      <td>Utah State</td>
      <td>WAC</td>
      <td>415000.0</td>
      <td>0.0</td>
      <td>415000.0</td>
      <td>150000.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Chris Ault</td>
      <td>Nevada</td>
      <td>Mt. West</td>
      <td>493093.0</td>
      <td>0.0</td>
      <td>493093.0</td>
      <td>30000.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>David Bailiff</td>
      <td>Rice</td>
      <td>CUSA</td>
      <td>608846.0</td>
      <td>NaN</td>
      <td>608846.0</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Frank Beamer</td>
      <td>Virginia Tech</td>
      <td>ACC</td>
      <td>2343000.0</td>
      <td>85000.0</td>
      <td>2428000.0</td>
      <td>407500.0</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Tim Beckman</td>
      <td>Illinois</td>
      <td>Big Ten</td>
      <td>1600000.0</td>
      <td>NaN</td>
      <td>1600000.0</td>
      <td>80000.0</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Todd Berry</td>
      <td>Louisiana-Monroe</td>
      <td>Sun Belt</td>
      <td>250000.0</td>
      <td>NaN</td>
      <td>250000.0</td>
      <td>62500.0</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Bret Bielema</td>
      <td>Wisconsin</td>
      <td>Big Ten</td>
      <td>2600000.0</td>
      <td>40140.0</td>
      <td>2640140.0</td>
      <td>400000.0</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Larry Blakeney</td>
      <td>Troy</td>
      <td>Sun Belt</td>
      <td>455000.0</td>
      <td>0.0</td>
      <td>455000.0</td>
      <td>75000.0</td>
    </tr>
  </tbody>
</table>
</div>




```python
#Show the coaches that don't have Salary data
print(df1.loc[df1['Salary'].isna()])
```

                      Name         School Conference  Salary  OtherPay  \
    0        Steve Addazio         Temple   Big East     NaN       NaN   
    10    Bill Blankenship          Tulsa       CUSA     NaN       NaN   
    19         Paul Chryst     Pittsburgh   Big East     NaN       NaN   
    42      James Franklin     Vanderbilt        SEC     NaN       NaN   
    45           Al Golden          Miami        ACC     NaN       NaN   
    59      Curtis Johnson         Tulane       CUSA     NaN       NaN   
    79   Bronco Mendenhall  Brigham Young       Ind.     NaN       NaN   
    105         David Shaw       Stanford     PAC-12     NaN       NaN   
    
         TotalSalary  MaxBonus  
    0            NaN       NaN  
    10           NaN       NaN  
    19           NaN       NaN  
    42           NaN       NaN  
    45           NaN       NaN  
    59           NaN       NaN  
    79           NaN       NaN  
    105          NaN       NaN  


Once I was able to identify which coaches were missing salary data, I was able to source this information online.

* Steve Addazio
    * 1,201,771 per season
    * Temple 2012 IRS Form 990 - Top 25 highest paid employees
* Bill Blankenship
    * 625,000 per season
    * News Article
* Paul Chryst
    * 1,578,757 per season
    * USA Today Salaries
* James Franklin
    * 1,547,682 base salary/ 295,089 other / 1,842,771 total / 50,000 bonus
    * Article
* Al Golden
    * 2,539,315 per season
    * Article
* Curtis Johnson
    * 1,000,000 per season
    * Article
* Bronco Mendenhall
    * 1,500,000 per season
    * Article
* David Shaw
    * 5,680,441 per season
    * USA Today Salaries



```python
#Replace NAs with found data

df1.iloc[0,3] = 1201771 

df1.iloc[10,3] = 625000

df1.iloc[19,3] = 1578757

df1.iloc[42,3] = 1547682
df1.iloc[42,4] = 295089
df1.iloc[42,5] = 1842771
df1.iloc[42,6] = 50000

df1.iloc[45,3] = 2539315

df1.iloc[59,3] = 1000000

df1.iloc[79,3] = 1500000

df1.iloc[105,3] = 5680441

print('Salary:',(df1['Salary'].isna()).sum()) #Make sure there are no more NAs in Salary - should = 0
```

    Salary: 0


### Student Athlete Graduation Rate

Next the Student Athlete Graduate Rate data was imported, isolated to only relevant information and an attempt was made to merge this with the original dataset. This highlighted an additional challenge in preprocessing - colleges and universities have too many variations on their name for a simple join or merge statement to work. To solve this problem, I turned to the FuzzyWuzzy package which got the majority combined. The few remaining that even FuzzyWuzzy couldn't find I had to alter manually.


```python
# Read in graduation rate data
from pandas import DataFrame
GSRdf = pd.read_csv("30022-0004-Data.tsv", sep="\t", index_col=0)

#Subset only the school name and graduation rate for latest school year available
GSRdf = GSRdf[['SCL_NAME', 'GSR_2008_SA']]

# Merge main df (df1) and graduation rate dataframe (GSRdf) 
Merged1 = df1.merge(GSRdf, 
                        left_on='School', 
                        right_on='SCL_NAME', 
                        how='left' 
                       )
#Selecting people with missing salaries
missing_gradrates = Merged1[Merged1.GSR_2008_SA.isnull()]

#Nearly all were missing, so we turn to fuzzywuzzy 
```


```python
#Load fuzzywuzzy and create a function to calculate fuzzy ratios for each school name 
from fuzzywuzzy import fuzz
from fuzzywuzzy import process

def match_name(name, list_names, min_score=0):
    # -1 score in case we don't get any matches
    max_score = -1
    # Returning empty name for no match as well
    max_name = ""
    # Iterating over all names in the other
    for name2 in list_names:
        #Finding fuzzy match score
        score = fuzz.token_set_ratio(name, name2)
        # Checking if we are above our threshold and have a better score
        if (score > min_score) & (score > max_score):
            max_name = name2
            max_score = score
    return (max_name, max_score)
```


```python
# List for dicts for easy dataframe creation
dict_list = []
# Apply the function 
for name in missing_gradrates.School:
    # Use function to find best match, and set threshold to 80%
    match = match_name(name, GSRdf.SCL_NAME, 80)
    
    # Store data from loop into a dictionary
    dict_ = {}
    dict_.update({"School" : name})
    dict_.update({"match_name" : match[0]})
    dict_.update({"score" : match[1]})
    dict_list.append(dict_)

#Convert dictionary to a dataframe
merge_table = pd.DataFrame(dict_list)
```


```python
#The table shows there are still issues
#Export table to excel sheet to review
#writer = ExcelWriter('mergedtable.xlsx')
#merge_table.to_excel(writer,'Sheet1',index=False)
#writer.save()
```


    ---------------------------------------------------------------------------

    NameError                                 Traceback (most recent call last)

    <ipython-input-99-077f045a5e97> in <module>()
          1 #The table shows there are still issues
          2 #Export table to excel sheet to review
    ----> 3 writer = ExcelWriter('mergedtable.xlsx')
          4 merge_table.to_excel(writer,'Sheet1',index=False)
          5 writer.save()


    NameError: name 'ExcelWriter' is not defined



```python
#Made changes directly to Excel file - Army to United States Military Academy; University of Texas - El Paso to Austin; LSU to Louisiana State University, etc..
file2 = 'mergedtable.xlsx'

x2 = pd.ExcelFile(file2)

merge_table = x2.parse('Sheet1') #Save sheet within excel file as a dataframe
```

    ['Sheet1']





<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>School</th>
      <th>match_name</th>
      <th>score</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Temple</td>
      <td>Temple University</td>
      <td>100</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Idaho</td>
      <td>University of Idaho</td>
      <td>100</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Utah State</td>
      <td>Utah State University</td>
      <td>100</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Nevada</td>
      <td>University of Nevada-Reno</td>
      <td>100</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Rice</td>
      <td>Rice University</td>
      <td>100</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Virginia Tech</td>
      <td>Virginia Polytechnic Institute and State Unive...</td>
      <td>-1</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Illinois</td>
      <td>University of Illinois at Urbana-Champaign</td>
      <td>100</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Louisiana-Monroe</td>
      <td>University of Louisiana at Monroe</td>
      <td>100</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Wisconsin</td>
      <td>University of Wisconsin-Green Bay</td>
      <td>100</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Troy</td>
      <td>Troy University</td>
      <td>100</td>
    </tr>
  </tbody>
</table>
</div>




```python
# Merge main df (df1) and updated school table(merge_table) to include matched_name column  
Merged2 = df1.merge(merge_table, 
                        left_on='School', 
                        right_on='School', 
                        how='left',
                        suffixes=["","_matched"]
                       )

# Merge updated school table (Merged 2) with graduation rate data (GSRdf) using matched_name column 
Merge3 = Merged2.merge(GSRdf, 
                        left_on='match_name', 
                        right_on='SCL_NAME', 
                        how='left' 
                       )

#See if there are still any missing
missing_gradrates = Merge3[Merge3.GSR_2008_SA.isnull()]

#Displaying results
missing_gradrates.reset_index(inplace=True,drop='index')
missing_gradrates
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Name</th>
      <th>School</th>
      <th>Conference</th>
      <th>Salary</th>
      <th>OtherPay</th>
      <th>TotalSalary</th>
      <th>MaxBonus</th>
      <th>match_name</th>
      <th>score</th>
      <th>SCL_NAME</th>
      <th>GSR_2008_SA</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Frank Spaziani</td>
      <td>Boston College</td>
      <td>ACC</td>
      <td>1094976.0</td>
      <td>NaN</td>
      <td>1094976.0</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>




```python
#Identified one NA
#Add Boston College graduation rate after referencing GSRdf data
Merge3.iloc[109,10] = 94
Merge3.iloc[114,10] = 83
Merge3.iloc[8,10] = 87
#Confirm once more
missing_gradrates = Merge3[Merge3.GSR_2008_SA.isnull()]

#Displaying results
missing_gradrates.reset_index(inplace=True,drop='index')
missing_gradrates

#All schools are accounted for
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Name</th>
      <th>School</th>
      <th>Conference</th>
      <th>Salary</th>
      <th>OtherPay</th>
      <th>TotalSalary</th>
      <th>MaxBonus</th>
      <th>match_name</th>
      <th>score</th>
      <th>SCL_NAME</th>
      <th>GSR_2008_SA</th>
    </tr>
  </thead>
  <tbody>
  </tbody>
</table>
</div>




```python
#Drop unneccessary columns and rename graduation rate column to something more human readable
df1 = Merge3.drop(Merge3.columns[[8, 9]], axis=1)
df1.rename(columns={'GSR_2008_SA': 'Grad_Rate'}, inplace=True)
df1.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Name</th>
      <th>School</th>
      <th>Conference</th>
      <th>Salary</th>
      <th>OtherPay</th>
      <th>TotalSalary</th>
      <th>MaxBonus</th>
      <th>match_name</th>
      <th>Grad_Rate</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Steve Addazio</td>
      <td>Temple</td>
      <td>Big East</td>
      <td>1201771.0</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>Temple University</td>
      <td>86.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Robb Akey</td>
      <td>Idaho</td>
      <td>WAC</td>
      <td>375797.0</td>
      <td>6200.0</td>
      <td>381997.0</td>
      <td>158262.0</td>
      <td>University of Idaho</td>
      <td>75.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Gary Andersen</td>
      <td>Utah State</td>
      <td>WAC</td>
      <td>415000.0</td>
      <td>0.0</td>
      <td>415000.0</td>
      <td>150000.0</td>
      <td>Utah State University</td>
      <td>88.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Chris Ault</td>
      <td>Nevada</td>
      <td>Mt. West</td>
      <td>493093.0</td>
      <td>0.0</td>
      <td>493093.0</td>
      <td>30000.0</td>
      <td>University of Nevada-Reno</td>
      <td>76.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>David Bailiff</td>
      <td>Rice</td>
      <td>CUSA</td>
      <td>608846.0</td>
      <td>NaN</td>
      <td>608846.0</td>
      <td>NaN</td>
      <td>Rice University</td>
      <td>95.0</td>
    </tr>
  </tbody>
</table>
</div>



### Stadium Capacity Dataset

The stadium capacity dataset was fairly straightforward. A few stadium capacity numbers were NA so these were sourced and inserted separately.


```python
# Read in stadium data
file2 = 'StadiumData.xlsx'

x2 = pd.ExcelFile(file2)

print(x2.sheet_names)

Stadf = x2.parse('Sheet1') #Save sheet within excel file as a dataframe
Stadf.head(5) # Preview first 10 rows of dataframe
```

    ['Sheet1']





<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>stadium</th>
      <th>city</th>
      <th>state</th>
      <th>team</th>
      <th>conference</th>
      <th>capacity</th>
      <th>built</th>
      <th>expanded</th>
      <th>div</th>
      <th>latitude</th>
      <th>longitude</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Michigan Stadium</td>
      <td>Ann Arbor</td>
      <td>MI</td>
      <td>Michigan</td>
      <td>Big Ten</td>
      <td>107601</td>
      <td>1927</td>
      <td>2015</td>
      <td>fbs</td>
      <td>42.265869</td>
      <td>-83.748726</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Beaver Stadium</td>
      <td>University Park</td>
      <td>PA</td>
      <td>Penn State</td>
      <td>Big Ten</td>
      <td>106572</td>
      <td>1960</td>
      <td>2001</td>
      <td>fbs</td>
      <td>40.812153</td>
      <td>-77.856202</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Ohio Stadium</td>
      <td>Columbus</td>
      <td>OH</td>
      <td>Ohio State</td>
      <td>Big Ten</td>
      <td>104944</td>
      <td>1922</td>
      <td>2014</td>
      <td>fbs</td>
      <td>40.001686</td>
      <td>-83.019728</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Kyle Field</td>
      <td>College Station</td>
      <td>TX</td>
      <td>Texas A&amp;M</td>
      <td>SEC</td>
      <td>102733</td>
      <td>1927</td>
      <td>2015</td>
      <td>fbs</td>
      <td>30.610098</td>
      <td>-96.340729</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Neyland Stadium</td>
      <td>Knoxville</td>
      <td>TN</td>
      <td>Tennessee</td>
      <td>SEC</td>
      <td>102455</td>
      <td>1921</td>
      <td>2010</td>
      <td>fbs</td>
      <td>35.954734</td>
      <td>-83.925333</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Tiger Stadium</td>
      <td>Baton Rouge</td>
      <td>LA</td>
      <td>LSU</td>
      <td>SEC</td>
      <td>102321</td>
      <td>1924</td>
      <td>2014</td>
      <td>fbs</td>
      <td>30.412012</td>
      <td>-91.183820</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Bryant–Denny Stadium</td>
      <td>Tuscaloosa</td>
      <td>AL</td>
      <td>Alabama</td>
      <td>SEC</td>
      <td>101821</td>
      <td>1929</td>
      <td>2010</td>
      <td>fbs</td>
      <td>33.207490</td>
      <td>-87.550392</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Darrell K Royal–Texas Memorial Stadium</td>
      <td>Austin</td>
      <td>TX</td>
      <td>Texas</td>
      <td>Big 12</td>
      <td>100119</td>
      <td>1924</td>
      <td>2009</td>
      <td>fbs</td>
      <td>30.283603</td>
      <td>-97.732337</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Los Angeles Memorial Coliseum</td>
      <td>Los Angeles</td>
      <td>CA</td>
      <td>Southern California</td>
      <td>Pac-12</td>
      <td>93607</td>
      <td>1923</td>
      <td>2008</td>
      <td>fbs</td>
      <td>34.014010</td>
      <td>-118.287896</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Sanford Stadium</td>
      <td>Athens</td>
      <td>GA</td>
      <td>Georgia</td>
      <td>SEC</td>
      <td>92746</td>
      <td>1929</td>
      <td>2004</td>
      <td>fbs</td>
      <td>33.949821</td>
      <td>-83.373442</td>
    </tr>
  </tbody>
</table>
</div>




```python
# Merge main df (df1) and stadium data (Stadf)  
StaMerge = df1.merge(Stadf, 
                        left_on='School', 
                        right_on='team', 
                        how='left' 
                       )
#Select people with missing stadium capacities
missing_stadium = StaMerge[StaMerge.team.isnull()]
#Alabama at birmingham identified as NA

#Drop unneccessary columns and rename capacity column to something more human readable
df1 = StaMerge.drop(StaMerge.columns[[9, 12, 13, 15, 16, 17]], axis=1)
df1.rename(columns={'capacity': 'Stadium_Capacity'}, inplace=True)

#71954 - Alabama at birmingham
df1.iloc[77,10] = 71954
```

### Football Program Revenue Dataset


```python
# Read in revenue data
#Source: https://ope.ed.gov/athletics/
file2 = 'Sport_Data_2016.csv'
Revdf = pd.read_csv(file2, index_col=None, parse_dates=True)
Revdf = Revdf[['Institution Name', 'Revenues Men\'s Team']]
Revdf.rename(columns={'Institution Name': 'InstitutionName', 'Revenues Men\'s Team': 'Revenue'}, inplace=True)
Revdf.head(5)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>InstitutionName</th>
      <th>Revenue</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Appalachian State University</td>
      <td>7923498</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Arizona State University-Tempe</td>
      <td>43012682</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Arkansas State University-Main Campus</td>
      <td>7159248</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Auburn University</td>
      <td>91652926</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Ball State University</td>
      <td>7044512</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Baylor University</td>
      <td>43223215</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Boise State University</td>
      <td>21302390</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Boston College</td>
      <td>28487714</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Bowling Green State University-Main Campus</td>
      <td>6537321</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Brigham Young University-Provo</td>
      <td>26116548</td>
    </tr>
  </tbody>
</table>
</div>




```python
# Read in data to be used as merge table for team names
# Source: ParseHub pull of Wikipedia
file2 = 'run_results.csv'
Tnames = pd.read_csv(file2, index_col=None, parse_dates=True)
Tnames.head(5)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>selection1_name</th>
      <th>selection1_team_name</th>
      <th>selection1_city</th>
      <th>selection1_state</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Air Force</td>
      <td>Falcons</td>
      <td>Colorado Springs</td>
      <td>Colorado</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Akron</td>
      <td>Zips</td>
      <td>Akron</td>
      <td>Ohio</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Alabama</td>
      <td>Crimson Tide</td>
      <td>Tuscaloosa</td>
      <td>Alabama</td>
    </tr>
    <tr>
      <th>3</th>
      <td>UAB</td>
      <td>Blazers</td>
      <td>Birmingham</td>
      <td>Alabama</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Appalachian State</td>
      <td>Mountaineers</td>
      <td>Boone</td>
      <td>North Carolina</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Arizona</td>
      <td>Wildcats</td>
      <td>Tucson</td>
      <td>Arizona</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Arizona State</td>
      <td>Sun Devils</td>
      <td>Tempe</td>
      <td>Arizona</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Arkansas</td>
      <td>Razorbacks</td>
      <td>Fayetteville</td>
      <td>Arkansas</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Arkansas State</td>
      <td>Red Wolves</td>
      <td>Jonesboro</td>
      <td>Arkansas</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Army West Point</td>
      <td>Black Knights</td>
      <td>West Point</td>
      <td>New York</td>
    </tr>
  </tbody>
</table>
</div>




```python
df1.iloc[114,7] = 'Texas A & M University-College Station'
df1.iloc[77,9] = 'Birmingham'
df1.iloc[77,10] = 'AL'
df1.iloc[77,11] = 71954
df1.iloc[77,12] = float(32.20)
df1.iloc[77,13] = float(-77.94)

# Merge main df (df1) and graduation rate dataframe (GSRdf) 
RevMerge = df1.merge(Revdf, 
                        left_on='match_name', 
                        right_on='InstitutionName', 
                        how='left' 
                       )

RevMerge.iloc[8,15] = 73548409
RevMerge.iloc[109,15] = 28487714

df1 = RevMerge
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Name</th>
      <th>School</th>
      <th>Conference</th>
      <th>Salary</th>
      <th>OtherPay</th>
      <th>TotalSalary</th>
      <th>MaxBonus</th>
      <th>match_name</th>
      <th>Grad_Rate</th>
      <th>city</th>
      <th>state</th>
      <th>Stadium_Capacity</th>
      <th>latitude</th>
      <th>longitude</th>
      <th>InstitutionName</th>
      <th>Revenue</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Steve Addazio</td>
      <td>Temple</td>
      <td>Big East</td>
      <td>1201771.0</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>Temple University</td>
      <td>86.0</td>
      <td>Philadelphia</td>
      <td>PA</td>
      <td>68532.0</td>
      <td>39.900749</td>
      <td>-75.167491</td>
      <td>Temple University</td>
      <td>20624125.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Robb Akey</td>
      <td>Idaho</td>
      <td>WAC</td>
      <td>375797.0</td>
      <td>6200.0</td>
      <td>381997.0</td>
      <td>158262.0</td>
      <td>University of Idaho</td>
      <td>75.0</td>
      <td>Moscow</td>
      <td>ID</td>
      <td>16000.0</td>
      <td>46.726350</td>
      <td>-117.017552</td>
      <td>University of Idaho</td>
      <td>7283199.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Gary Andersen</td>
      <td>Utah State</td>
      <td>WAC</td>
      <td>415000.0</td>
      <td>0.0</td>
      <td>415000.0</td>
      <td>150000.0</td>
      <td>Utah State University</td>
      <td>88.0</td>
      <td>Logan</td>
      <td>UT</td>
      <td>25513.0</td>
      <td>41.751532</td>
      <td>-111.812106</td>
      <td>Utah State University</td>
      <td>8981573.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Chris Ault</td>
      <td>Nevada</td>
      <td>Mt. West</td>
      <td>493093.0</td>
      <td>0.0</td>
      <td>493093.0</td>
      <td>30000.0</td>
      <td>University of Nevada-Reno</td>
      <td>76.0</td>
      <td>Reno</td>
      <td>NV</td>
      <td>30000.0</td>
      <td>39.546925</td>
      <td>-119.817560</td>
      <td>University of Nevada-Reno</td>
      <td>9730719.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>David Bailiff</td>
      <td>Rice</td>
      <td>CUSA</td>
      <td>608846.0</td>
      <td>NaN</td>
      <td>608846.0</td>
      <td>NaN</td>
      <td>Rice University</td>
      <td>95.0</td>
      <td>Houston</td>
      <td>TX</td>
      <td>47000.0</td>
      <td>29.716234</td>
      <td>-95.409265</td>
      <td>Rice University</td>
      <td>12001178.0</td>
    </tr>
  </tbody>
</table>
</div>



### Football Win-Loss Record Dataset

Once the data was scraped from the NCAA website, it required some additional cleaning. The win-loss record was written as #-#, so I needed to separate these into their own columns and calculate the actual w/l ratio.


```python
# Read in win-loss data
# Source: ParseHub pull of NCAA website
file2 = 'run_results_record.csv'
Record = pd.read_csv(file2, index_col=None, parse_dates=True)
Record.head(5)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>selection1_name</th>
      <th>selection1_w_l</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Clemson</td>
      <td>12-2</td>
    </tr>
    <tr>
      <th>1</th>
      <td>North Carolina State</td>
      <td>9-4</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Louisville</td>
      <td>8-5</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Wake Forest</td>
      <td>8-5</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Boston College</td>
      <td>7-6</td>
    </tr>
  </tbody>
</table>
</div>




```python
#Split w-l into two columns and change datatypes
Record['Wins'], Record['Losses'] = Record['selection1_w_l'].str.split('-', 1).str
Record = Record.drop(Record.columns[[1]], axis=1)
Record['Wins'] = Record['Wins'].astype(float)
Record['Losses'] = Record['Losses'].astype(float)

#Create win percentage column from win/loss calculation
Record['WLPct'] = Record['Wins']/(Record['Wins'] + Record['Losses'])

# Merge main df (df1) and graduation rate dataframe (GSRdf) 
RecordMerge = df1.merge(Record, 
                        left_on='School', 
                        right_on='selection1_name', 
                        how='left' 
                       )

#Drop unneccessary columns
df1 = RecordMerge.drop(RecordMerge.columns[[16, 17, 18]], axis=1)

df1 = df1.drop(df1.columns[[7, 14]], axis=1)
```


```python
#Export table to excel sheet
writer = pd.ExcelWriter('CoachesClean.xlsx')
df1.to_excel(writer,'Sheet1',index=False)
writer.save()
```


```python
#Made changes directly to Excel file - Army to United States Military Academy; University of Texas - El Paso to Austin; LSU to Louisiana State University, etc..
file2 = 'CoachesClean.xlsx'

x2 = pd.ExcelFile(file2)

print(x2.sheet_names)

df1 = x2.parse('Sheet1') #Save sheet within excel file as a dataframe
```

    ['Sheet1']





<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Name</th>
      <th>School</th>
      <th>Conference</th>
      <th>Salary</th>
      <th>OtherPay</th>
      <th>TotalSalary</th>
      <th>MaxBonus</th>
      <th>Grad_Rate</th>
      <th>city</th>
      <th>state</th>
      <th>Stadium_Capacity</th>
      <th>latitude</th>
      <th>longitude</th>
      <th>Revenue</th>
      <th>WLPct</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Steve Addazio</td>
      <td>Temple</td>
      <td>Big East</td>
      <td>1201771</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>86</td>
      <td>Philadelphia</td>
      <td>PA</td>
      <td>68532</td>
      <td>39.900749</td>
      <td>-75.167491</td>
      <td>20624125.0</td>
      <td>0.538462</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Robb Akey</td>
      <td>Idaho</td>
      <td>WAC</td>
      <td>375797</td>
      <td>6200.0</td>
      <td>381997.0</td>
      <td>158262.0</td>
      <td>75</td>
      <td>Moscow</td>
      <td>ID</td>
      <td>16000</td>
      <td>46.726350</td>
      <td>-117.017552</td>
      <td>7283199.0</td>
      <td>0.333333</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Gary Andersen</td>
      <td>Utah State</td>
      <td>WAC</td>
      <td>415000</td>
      <td>0.0</td>
      <td>415000.0</td>
      <td>150000.0</td>
      <td>88</td>
      <td>Logan</td>
      <td>UT</td>
      <td>25513</td>
      <td>41.751532</td>
      <td>-111.812106</td>
      <td>8981573.0</td>
      <td>0.461538</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Chris Ault</td>
      <td>Nevada</td>
      <td>Mt. West</td>
      <td>493093</td>
      <td>0.0</td>
      <td>493093.0</td>
      <td>30000.0</td>
      <td>76</td>
      <td>Reno</td>
      <td>NV</td>
      <td>30000</td>
      <td>39.546925</td>
      <td>-119.817560</td>
      <td>9730719.0</td>
      <td>0.250000</td>
    </tr>
    <tr>
      <th>4</th>
      <td>David Bailiff</td>
      <td>Rice</td>
      <td>CUSA</td>
      <td>608846</td>
      <td>NaN</td>
      <td>608846.0</td>
      <td>NaN</td>
      <td>95</td>
      <td>Houston</td>
      <td>TX</td>
      <td>47000</td>
      <td>29.716234</td>
      <td>-95.409265</td>
      <td>12001178.0</td>
      <td>0.083333</td>
    </tr>
  </tbody>
</table>
</div>



## Initial Data Exploration

Once the complete dataframe was created, I started the analysis by exploring and visualizing the data using several techniques.


```python
pd.options.display.float_format = '{:.2f}'.format #Change float format to suppress scientific notation
df1.describe() #Show descriptive statistics of numeric variables
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Salary</th>
      <th>OtherPay</th>
      <th>TotalSalary</th>
      <th>MaxBonus</th>
      <th>Grad_Rate</th>
      <th>Stadium_Capacity</th>
      <th>latitude</th>
      <th>longitude</th>
      <th>Revenue</th>
      <th>WLPct</th>
      <th>runiform</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>124.00</td>
      <td>75.00</td>
      <td>117.00</td>
      <td>105.00</td>
      <td>124.00</td>
      <td>124.00</td>
      <td>124.00</td>
      <td>124.00</td>
      <td>117.00</td>
      <td>124.00</td>
      <td>124.00</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>1606215.11</td>
      <td>29427.23</td>
      <td>1600448.14</td>
      <td>518537.98</td>
      <td>84.87</td>
      <td>52703.15</td>
      <td>36.88</td>
      <td>-92.91</td>
      <td>34794267.27</td>
      <td>0.52</td>
      <td>0.53</td>
    </tr>
    <tr>
      <th>std</th>
      <td>1184399.66</td>
      <td>121702.18</td>
      <td>1161112.49</td>
      <td>428156.12</td>
      <td>6.55</td>
      <td>22985.67</td>
      <td>5.03</td>
      <td>14.84</td>
      <td>29272049.16</td>
      <td>0.21</td>
      <td>0.28</td>
    </tr>
    <tr>
      <th>min</th>
      <td>250000.00</td>
      <td>0.00</td>
      <td>250000.00</td>
      <td>25000.00</td>
      <td>68.00</td>
      <td>16000.00</td>
      <td>21.37</td>
      <td>-157.93</td>
      <td>5394664.00</td>
      <td>0.00</td>
      <td>0.01</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>587500.00</td>
      <td>0.00</td>
      <td>550000.00</td>
      <td>158262.00</td>
      <td>81.00</td>
      <td>32186.00</td>
      <td>33.11</td>
      <td>-97.78</td>
      <td>10046711.00</td>
      <td>0.40</td>
      <td>0.31</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>1405823.00</td>
      <td>1550.00</td>
      <td>1461646.00</td>
      <td>407500.00</td>
      <td>85.00</td>
      <td>50000.00</td>
      <td>37.27</td>
      <td>-88.51</td>
      <td>26116548.00</td>
      <td>0.54</td>
      <td>0.56</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>2386626.25</td>
      <td>9500.00</td>
      <td>2406505.00</td>
      <td>740000.00</td>
      <td>88.25</td>
      <td>65951.00</td>
      <td>40.81</td>
      <td>-82.48</td>
      <td>44646242.00</td>
      <td>0.69</td>
      <td>0.77</td>
    </tr>
    <tr>
      <th>max</th>
      <td>5680441.00</td>
      <td>1000000.00</td>
      <td>5476738.00</td>
      <td>2050000.00</td>
      <td>100.00</td>
      <td>107601.00</td>
      <td>47.65</td>
      <td>-71.17</td>
      <td>141173444.00</td>
      <td>1.00</td>
      <td>0.99</td>
    </tr>
  </tbody>
</table>
</div>




```python
grouped_conference = df1.groupby(['Conference']) # Create variable 
grouped_conference['Salary'].mean().reset_index() # Compare salary means by conference
grouped_conference['Salary'].quantile([.25, .5, .75]).unstack() # Interquartile range
grouped_conference['Salary'].var().reset_index() # Compare variances by conference
grouped_conference['Salary'].describe().unstack() # Descriptive statistics summary by conference
grouped_conference['Name'].count().reset_index() # Count number of coaches by conference
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Conference</th>
      <th>Name</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>ACC</td>
      <td>12</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Big 12</td>
      <td>10</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Big East</td>
      <td>8</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Big Ten</td>
      <td>12</td>
    </tr>
    <tr>
      <th>4</th>
      <td>CUSA</td>
      <td>12</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Ind.</td>
      <td>4</td>
    </tr>
    <tr>
      <th>6</th>
      <td>MAC</td>
      <td>13</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Mt. West</td>
      <td>10</td>
    </tr>
    <tr>
      <th>8</th>
      <td>PAC-12</td>
      <td>12</td>
    </tr>
    <tr>
      <th>9</th>
      <td>SEC</td>
      <td>14</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Sun Belt</td>
      <td>10</td>
    </tr>
    <tr>
      <th>11</th>
      <td>WAC</td>
      <td>7</td>
    </tr>
  </tbody>
</table>
</div>




```python
plot.subplots(figsize=(10,10))
sns.countplot(x="Conference", data=df1)
```




    <matplotlib.axes._subplots.AxesSubplot at 0x1c2eaa6da0>




![png](output_39_1.png)



```python
plot.subplots(figsize=(10,10))
sns.set(style="whitegrid")
plot1 = sns.boxplot(x='Conference', y='Salary', data=df1, palette = "Set3", 
                    linewidth=1.25).set_title('Salary Box & Whisker Plot')
```


![png](output_40_0.png)



```python
import seaborn as sns

sns.catplot(x="Conference", y="Salary", kind="swarm", data=df1,height=6, aspect=2)
```




    <seaborn.axisgrid.FacetGrid at 0x1a1dd0fb00>




![png](output_41_1.png)



```python
# Visualize correlations with a heatmap
plot.subplots(figsize=(13,10))
sns.heatmap(df1.drop(['latitude','longitude'], axis=1).corr(),
            annot=True,
            cmap="YlGnBu")
```




    <matplotlib.axes._subplots.AxesSubplot at 0x1a28af9710>




![png](output_42_1.png)



```python
sns.pairplot(df1,
             vars=["Salary", "Stadium_Capacity","Revenue","WLPct"],
             hue="Conference")
```

    /Users/coreylucero/anaconda3/lib/python3.6/site-packages/statsmodels/nonparametric/kde.py:448: RuntimeWarning: invalid value encountered in greater
      X = X[np.logical_and(X > clip[0], X < clip[1])] # won't work for two columns.
    /Users/coreylucero/anaconda3/lib/python3.6/site-packages/statsmodels/nonparametric/kde.py:448: RuntimeWarning: invalid value encountered in less
      X = X[np.logical_and(X > clip[0], X < clip[1])] # won't work for two columns.





    <seaborn.axisgrid.PairGrid at 0x1a28914d68>




![png](output_43_2.png)


## Data Modeling


```python

# import packages for analysis and modeling
import pandas as pd  # data frame operations

import numpy as np  # arrays and math functions
from scipy.stats import uniform  # for training-and-test split
import statsmodels.api as sm  # statistical models (including regression)
import statsmodels.formula.api as smf  # R-like model specification
import matplotlib.pyplot as plt  # 2D plotting
from sklearn import linear_model
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error
from sklearn.model_selection import cross_val_score
from patsy import dmatrices

```


```python
np.random.seed(1234)
df1['runiform'] = uniform.rvs(loc = 0, scale = 1, size = len(df1))
df1_train = df1[df1['runiform'] >= 0.33]
df1_test = df1[df1['runiform'] < 0.33]
```


```python
### OLS Regression Model built and used ###

lm_df = df1_train[['Salary', 'Revenue', 'Stadium_Capacity', 'WLPct', 'Conference']]
train_model_fit = smf.ols("Salary ~  Revenue + WLPct + Conference", lm_df).fit()

train_model_fit.predict(df1_test)
#1885813.85 is the recommended salary in Big East
#1259276 - Actual salary
df1_test

dfsyr = pd.DataFrame({'Conference':['ACC','Big Ten'], 'Salary': [1259276,1259276], 'Revenue': [44182377,44182377], 'Stadium_Capacity': [49250,49250], 'WLPct': .33})

train_model_fit.predict(dfsyr)
#ACC = 2,003,228
#Big Ten = 1,555,761
train_model_fit.summary()

#Revenue had the single greatest impact on R-squared - .723/.826
```




<table class="simpletable">
<caption>OLS Regression Results</caption>
<tr>
  <th>Dep. Variable:</th>         <td>Salary</td>      <th>  R-squared:         </th> <td>   0.824</td>
</tr>
<tr>
  <th>Model:</th>                   <td>OLS</td>       <th>  Adj. R-squared:    </th> <td>   0.794</td>
</tr>
<tr>
  <th>Method:</th>             <td>Least Squares</td>  <th>  F-statistic:       </th> <td>   27.40</td>
</tr>
<tr>
  <th>Date:</th>             <td>Sat, 04 Aug 2018</td> <th>  Prob (F-statistic):</th> <td>9.23e-22</td>
</tr>
<tr>
  <th>Time:</th>                 <td>12:05:09</td>     <th>  Log-Likelihood:    </th> <td> -1207.9</td>
</tr>
<tr>
  <th>No. Observations:</th>      <td>    83</td>      <th>  AIC:               </th> <td>   2442.</td>
</tr>
<tr>
  <th>Df Residuals:</th>          <td>    70</td>      <th>  BIC:               </th> <td>   2473.</td>
</tr>
<tr>
  <th>Df Model:</th>              <td>    12</td>      <th>                     </th>     <td> </td>   
</tr>
<tr>
  <th>Covariance Type:</th>      <td>nonrobust</td>    <th>                     </th>     <td> </td>   
</tr>
</table>
<table class="simpletable">
<tr>
             <td></td>               <th>coef</th>     <th>std err</th>      <th>t</th>      <th>P>|t|</th>  <th>[0.025</th>    <th>0.975]</th>  
</tr>
<tr>
  <th>Intercept</th>              <td> 7.181e+05</td> <td> 2.67e+05</td> <td>    2.692</td> <td> 0.009</td> <td> 1.86e+05</td> <td> 1.25e+06</td>
</tr>
<tr>
  <th>Conference[T.Big 12]</th>   <td> 3.535e+05</td> <td> 2.76e+05</td> <td>    1.280</td> <td> 0.205</td> <td>-1.97e+05</td> <td> 9.04e+05</td>
</tr>
<tr>
  <th>Conference[T.Big East]</th> <td>-1.199e+05</td> <td> 3.75e+05</td> <td>   -0.320</td> <td> 0.750</td> <td>-8.67e+05</td> <td> 6.28e+05</td>
</tr>
<tr>
  <th>Conference[T.Big Ten]</th>  <td>-4.688e+05</td> <td> 2.78e+05</td> <td>   -1.685</td> <td> 0.096</td> <td>-1.02e+06</td> <td>  8.6e+04</td>
</tr>
<tr>
  <th>Conference[T.CUSA]</th>     <td>-5.331e+05</td> <td> 2.87e+05</td> <td>   -1.860</td> <td> 0.067</td> <td> -1.1e+06</td> <td> 3.84e+04</td>
</tr>
<tr>
  <th>Conference[T.Ind.]</th>     <td>-2.169e-10</td> <td> 1.64e-10</td> <td>   -1.325</td> <td> 0.190</td> <td>-5.44e-10</td> <td>  1.1e-10</td>
</tr>
<tr>
  <th>Conference[T.MAC]</th>      <td>-9.896e+05</td> <td> 2.92e+05</td> <td>   -3.388</td> <td> 0.001</td> <td>-1.57e+06</td> <td>-4.07e+05</td>
</tr>
<tr>
  <th>Conference[T.Mt. West]</th> <td>-5.872e+05</td> <td> 2.88e+05</td> <td>   -2.040</td> <td> 0.045</td> <td>-1.16e+06</td> <td> -1.3e+04</td>
</tr>
<tr>
  <th>Conference[T.PAC-12]</th>   <td>-1.784e+05</td> <td>    3e+05</td> <td>   -0.596</td> <td> 0.553</td> <td>-7.76e+05</td> <td> 4.19e+05</td>
</tr>
<tr>
  <th>Conference[T.SEC]</th>      <td>-2.077e+05</td> <td> 2.84e+05</td> <td>   -0.730</td> <td> 0.468</td> <td>-7.75e+05</td> <td>  3.6e+05</td>
</tr>
<tr>
  <th>Conference[T.Sun Belt]</th> <td>-9.564e+05</td> <td> 3.03e+05</td> <td>   -3.161</td> <td> 0.002</td> <td>-1.56e+06</td> <td>-3.53e+05</td>
</tr>
<tr>
  <th>Conference[T.WAC]</th>      <td>-8.729e+05</td> <td> 3.13e+05</td> <td>   -2.785</td> <td> 0.007</td> <td> -1.5e+06</td> <td>-2.48e+05</td>
</tr>
<tr>
  <th>Revenue</th>                <td>    0.0238</td> <td>    0.003</td> <td>    7.104</td> <td> 0.000</td> <td>    0.017</td> <td>    0.030</td>
</tr>
<tr>
  <th>WLPct</th>                  <td> 9.423e+05</td> <td> 3.01e+05</td> <td>    3.131</td> <td> 0.003</td> <td> 3.42e+05</td> <td> 1.54e+06</td>
</tr>
</table>
<table class="simpletable">
<tr>
  <th>Omnibus:</th>       <td> 6.197</td> <th>  Durbin-Watson:     </th> <td>   1.991</td>
</tr>
<tr>
  <th>Prob(Omnibus):</th> <td> 0.045</td> <th>  Jarque-Bera (JB):  </th> <td>   6.914</td>
</tr>
<tr>
  <th>Skew:</th>          <td> 0.366</td> <th>  Prob(JB):          </th> <td>  0.0315</td>
</tr>
<tr>
  <th>Kurtosis:</th>      <td> 4.210</td> <th>  Cond. No.          </th> <td>2.56e+24</td>
</tr>
</table><br/><br/>Warnings:<br/>[1] Standard Errors assume that the covariance matrix of the errors is correctly specified.<br/>[2] The smallest eigenvalue is 2.86e-32. This might indicate that there are<br/>strong multicollinearity problems or that the design matrix is singular.




```python
#Final model used after model selection
final_model = smf.ols("Salary ~  Revenue + WLPct + Conference", df1).fit()
final_model.summary()

#final_model.predict(df1.iloc[[74]])
#Syracuse coach recommendation - $1,748,106


#final_model.predict(dfsyr)
#ACC - $2,006,831
#Big Ten - $1,686,848
```




<table class="simpletable">
<caption>OLS Regression Results</caption>
<tr>
  <th>Dep. Variable:</th>         <td>Salary</td>      <th>  R-squared:         </th> <td>   0.749</td>
</tr>
<tr>
  <th>Model:</th>                   <td>OLS</td>       <th>  Adj. R-squared:    </th> <td>   0.717</td>
</tr>
<tr>
  <th>Method:</th>             <td>Least Squares</td>  <th>  F-statistic:       </th> <td>   23.66</td>
</tr>
<tr>
  <th>Date:</th>             <td>Sat, 04 Aug 2018</td> <th>  Prob (F-statistic):</th> <td>3.15e-25</td>
</tr>
<tr>
  <th>Time:</th>                 <td>12:29:10</td>     <th>  Log-Likelihood:    </th> <td> -1722.8</td>
</tr>
<tr>
  <th>No. Observations:</th>      <td>   117</td>      <th>  AIC:               </th> <td>   3474.</td>
</tr>
<tr>
  <th>Df Residuals:</th>          <td>   103</td>      <th>  BIC:               </th> <td>   3512.</td>
</tr>
<tr>
  <th>Df Model:</th>              <td>    13</td>      <th>                     </th>     <td> </td>   
</tr>
<tr>
  <th>Covariance Type:</th>      <td>nonrobust</td>    <th>                     </th>     <td> </td>   
</tr>
</table>
<table class="simpletable">
<tr>
             <td></td>               <th>coef</th>     <th>std err</th>      <th>t</th>      <th>P>|t|</th>  <th>[0.025</th>    <th>0.975]</th>  
</tr>
<tr>
  <th>Intercept</th>              <td> 7.665e+05</td> <td> 2.69e+05</td> <td>    2.849</td> <td> 0.005</td> <td> 2.33e+05</td> <td>  1.3e+06</td>
</tr>
<tr>
  <th>Conference[T.Big 12]</th>   <td>  4.99e+05</td> <td> 2.85e+05</td> <td>    1.750</td> <td> 0.083</td> <td>-6.67e+04</td> <td> 1.06e+06</td>
</tr>
<tr>
  <th>Conference[T.Big East]</th> <td>-2.621e+05</td> <td> 3.01e+05</td> <td>   -0.871</td> <td> 0.386</td> <td>-8.59e+05</td> <td> 3.35e+05</td>
</tr>
<tr>
  <th>Conference[T.Big Ten]</th>  <td>  -3.2e+05</td> <td> 2.84e+05</td> <td>   -1.127</td> <td> 0.262</td> <td>-8.83e+05</td> <td> 2.43e+05</td>
</tr>
<tr>
  <th>Conference[T.CUSA]</th>     <td>-6.024e+05</td> <td> 2.89e+05</td> <td>   -2.087</td> <td> 0.039</td> <td>-1.17e+06</td> <td>-2.99e+04</td>
</tr>
<tr>
  <th>Conference[T.Ind.]</th>     <td>-6.112e+05</td> <td> 4.98e+05</td> <td>   -1.228</td> <td> 0.222</td> <td> -1.6e+06</td> <td> 3.76e+05</td>
</tr>
<tr>
  <th>Conference[T.MAC]</th>      <td>-1.025e+06</td> <td> 2.85e+05</td> <td>   -3.595</td> <td> 0.000</td> <td>-1.59e+06</td> <td> -4.6e+05</td>
</tr>
<tr>
  <th>Conference[T.Mt. West]</th> <td>-6.425e+05</td> <td> 3.03e+05</td> <td>   -2.118</td> <td> 0.037</td> <td>-1.24e+06</td> <td> -4.1e+04</td>
</tr>
<tr>
  <th>Conference[T.PAC-12]</th>   <td> 2.045e+05</td> <td> 2.74e+05</td> <td>    0.746</td> <td> 0.457</td> <td>-3.39e+05</td> <td> 7.48e+05</td>
</tr>
<tr>
  <th>Conference[T.SEC]</th>      <td>  -1.5e+05</td> <td> 2.76e+05</td> <td>   -0.544</td> <td> 0.587</td> <td>-6.97e+05</td> <td> 3.97e+05</td>
</tr>
<tr>
  <th>Conference[T.Sun Belt]</th> <td>-9.768e+05</td> <td> 3.03e+05</td> <td>   -3.225</td> <td> 0.002</td> <td>-1.58e+06</td> <td>-3.76e+05</td>
</tr>
<tr>
  <th>Conference[T.WAC]</th>      <td>-8.979e+05</td> <td>  3.3e+05</td> <td>   -2.722</td> <td> 0.008</td> <td>-1.55e+06</td> <td>-2.44e+05</td>
</tr>
<tr>
  <th>Revenue</th>                <td>    0.0204</td> <td>    0.004</td> <td>    5.770</td> <td> 0.000</td> <td>    0.013</td> <td>    0.027</td>
</tr>
<tr>
  <th>WLPct</th>                  <td> 1.022e+06</td> <td> 2.95e+05</td> <td>    3.464</td> <td> 0.001</td> <td> 4.37e+05</td> <td> 1.61e+06</td>
</tr>
</table>
<table class="simpletable">
<tr>
  <th>Omnibus:</th>       <td>42.922</td> <th>  Durbin-Watson:     </th> <td>   1.917</td>
</tr>
<tr>
  <th>Prob(Omnibus):</th> <td> 0.000</td> <th>  Jarque-Bera (JB):  </th> <td> 191.613</td>
</tr>
<tr>
  <th>Skew:</th>          <td> 1.143</td> <th>  Prob(JB):          </th> <td>2.46e-42</td>
</tr>
<tr>
  <th>Kurtosis:</th>      <td> 8.838</td> <th>  Cond. No.          </th> <td>5.53e+08</td>
</tr>
</table><br/><br/>Warnings:<br/>[1] Standard Errors assume that the covariance matrix of the errors is correctly specified.<br/>[2] The condition number is large, 5.53e+08. This might indicate that there are<br/>strong multicollinearity or other numerical problems.




```python
### OLS Regression model built to evaluate impact of graduation rate ###
lm_df2 = df1_train[['Salary', 'Revenue', 'Stadium_Capacity', 'WLPct', 'Conference', 'Grad_Rate']]
train_model_fit2 = smf.ols("Salary ~ Revenue + WLPct + Conference + Grad_Rate", lm_df2).fit()

train_model_fit2.summary()

#Graduation rate is not significant in predicting salary
```




<table class="simpletable">
<caption>OLS Regression Results</caption>
<tr>
  <th>Dep. Variable:</th>         <td>Salary</td>      <th>  R-squared:         </th> <td>   0.824</td>
</tr>
<tr>
  <th>Model:</th>                   <td>OLS</td>       <th>  Adj. R-squared:    </th> <td>   0.791</td>
</tr>
<tr>
  <th>Method:</th>             <td>Least Squares</td>  <th>  F-statistic:       </th> <td>   24.93</td>
</tr>
<tr>
  <th>Date:</th>             <td>Sat, 04 Aug 2018</td> <th>  Prob (F-statistic):</th> <td>4.93e-21</td>
</tr>
<tr>
  <th>Time:</th>                 <td>12:31:43</td>     <th>  Log-Likelihood:    </th> <td> -1207.9</td>
</tr>
<tr>
  <th>No. Observations:</th>      <td>    83</td>      <th>  AIC:               </th> <td>   2444.</td>
</tr>
<tr>
  <th>Df Residuals:</th>          <td>    69</td>      <th>  BIC:               </th> <td>   2478.</td>
</tr>
<tr>
  <th>Df Model:</th>              <td>    13</td>      <th>                     </th>     <td> </td>   
</tr>
<tr>
  <th>Covariance Type:</th>      <td>nonrobust</td>    <th>                     </th>     <td> </td>   
</tr>
</table>
<table class="simpletable">
<tr>
             <td></td>               <th>coef</th>     <th>std err</th>      <th>t</th>      <th>P>|t|</th>  <th>[0.025</th>    <th>0.975]</th>  
</tr>
<tr>
  <th>Intercept</th>              <td> 5.939e+05</td> <td>  1.1e+06</td> <td>    0.542</td> <td> 0.590</td> <td>-1.59e+06</td> <td> 2.78e+06</td>
</tr>
<tr>
  <th>Conference[T.Big 12]</th>   <td> 3.577e+05</td> <td> 2.81e+05</td> <td>    1.275</td> <td> 0.207</td> <td>-2.02e+05</td> <td> 9.17e+05</td>
</tr>
<tr>
  <th>Conference[T.Big East]</th> <td>-1.165e+05</td> <td> 3.79e+05</td> <td>   -0.308</td> <td> 0.759</td> <td>-8.72e+05</td> <td> 6.39e+05</td>
</tr>
<tr>
  <th>Conference[T.Big Ten]</th>  <td>-4.687e+05</td> <td>  2.8e+05</td> <td>   -1.673</td> <td> 0.099</td> <td>-1.03e+06</td> <td> 9.02e+04</td>
</tr>
<tr>
  <th>Conference[T.CUSA]</th>     <td>-5.299e+05</td> <td>  2.9e+05</td> <td>   -1.828</td> <td> 0.072</td> <td>-1.11e+06</td> <td> 4.85e+04</td>
</tr>
<tr>
  <th>Conference[T.Ind.]</th>     <td>  2.55e-10</td> <td> 1.09e-10</td> <td>    2.329</td> <td> 0.023</td> <td> 3.66e-11</td> <td> 4.73e-10</td>
</tr>
<tr>
  <th>Conference[T.MAC]</th>      <td>-9.824e+05</td> <td> 3.01e+05</td> <td>   -3.268</td> <td> 0.002</td> <td>-1.58e+06</td> <td>-3.83e+05</td>
</tr>
<tr>
  <th>Conference[T.Mt. West]</th> <td>-5.774e+05</td> <td> 3.02e+05</td> <td>   -1.914</td> <td> 0.060</td> <td>-1.18e+06</td> <td> 2.45e+04</td>
</tr>
<tr>
  <th>Conference[T.PAC-12]</th>   <td>-1.721e+05</td> <td> 3.06e+05</td> <td>   -0.562</td> <td> 0.576</td> <td>-7.83e+05</td> <td> 4.39e+05</td>
</tr>
<tr>
  <th>Conference[T.SEC]</th>      <td>-2.017e+05</td> <td> 2.91e+05</td> <td>   -0.693</td> <td> 0.491</td> <td>-7.82e+05</td> <td> 3.79e+05</td>
</tr>
<tr>
  <th>Conference[T.Sun Belt]</th> <td>-9.457e+05</td> <td> 3.18e+05</td> <td>   -2.972</td> <td> 0.004</td> <td>-1.58e+06</td> <td>-3.11e+05</td>
</tr>
<tr>
  <th>Conference[T.WAC]</th>      <td>-8.633e+05</td> <td> 3.26e+05</td> <td>   -2.646</td> <td> 0.010</td> <td>-1.51e+06</td> <td>-2.12e+05</td>
</tr>
<tr>
  <th>Revenue</th>                <td>    0.0238</td> <td>    0.003</td> <td>    7.049</td> <td> 0.000</td> <td>    0.017</td> <td>    0.031</td>
</tr>
<tr>
  <th>WLPct</th>                  <td> 9.417e+05</td> <td> 3.03e+05</td> <td>    3.106</td> <td> 0.003</td> <td> 3.37e+05</td> <td> 1.55e+06</td>
</tr>
<tr>
  <th>Grad_Rate</th>              <td> 1401.0275</td> <td>  1.2e+04</td> <td>    0.117</td> <td> 0.907</td> <td>-2.25e+04</td> <td> 2.53e+04</td>
</tr>
</table>
<table class="simpletable">
<tr>
  <th>Omnibus:</th>       <td> 6.187</td> <th>  Durbin-Watson:     </th> <td>   1.983</td>
</tr>
<tr>
  <th>Prob(Omnibus):</th> <td> 0.045</td> <th>  Jarque-Bera (JB):  </th> <td>   6.893</td>
</tr>
<tr>
  <th>Skew:</th>          <td> 0.366</td> <th>  Prob(JB):          </th> <td>  0.0319</td>
</tr>
<tr>
  <th>Kurtosis:</th>      <td> 4.207</td> <th>  Cond. No.          </th> <td>1.92e+24</td>
</tr>
</table><br/><br/>Warnings:<br/>[1] Standard Errors assume that the covariance matrix of the errors is correctly specified.<br/>[2] The smallest eigenvalue is 5.09e-32. This might indicate that there are<br/>strong multicollinearity problems or that the design matrix is singular.



## Final Conclusions and Recommendations

The analysis led to the following conclusions:
* Although the data was not all temporally aligned, this academic exercise shows that an ordinary-least-squares model can be used to predict an NCAA coaches football salary. 
* The model managed to maintain the integrity of the data by not eliminating any schools from the analysis for the final model.
* Graduation rate of the athletes was not a significant variable in predicting coach salaries.
* By eliminating each variable one-by-one I determined ‘Revenue’ had the single greatest impact on R2 making it the most important single variable in predicting salary.
* Based on the data for the Syracuse head coach - Big East conference, Revenue of 42.1 million and a win-loss percentage of .333, I would recommend a salary of 1,748,107 to be competitive with peer institutions. This information is not 100% accurate to 2018 Syracuse figures, but would mean a major cut to Dino Baber’s current 2.8 million annual salary. (Sorry Dino!).
* If we change the Syracuse conference to the ACC, as is current in 2018, the recommended salary would increase to a base salary of 2,006,831. But if Syracuse hypothetically moved to the Big Ten the recommended salary would decrease to a base salary of 1,686,848.

