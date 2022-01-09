Lego Sales Data Analysis
================

## Task 1 - Bayesian posterior samples

### Data

For this task you have been given a tidied data frame containing the
results of a [stan](https://mc-stan.org/) model fit to the eight schools
data (Section 5.5 of Bayesian Data Analysis). To briefly summarize, a
coaching program for the SAT Verbal examine was established in eight
high schools - the outcome variable
(![y_i](https://latex.codecogs.com/png.latex?y_i "y_i")) was the
estimated treatment effect of the coaching at each of these schools
(performance of the coached students vs uncoached students with
additional controls). The sampling standard deviation of these effects
is also record as
![\\sigma_i](https://latex.codecogs.com/png.latex?%5Csigma_i "\sigma_i").

The model being fit is interested in estimating an overall mean effect
of coaching, across all 8 schools,
![\\mu](https://latex.codecogs.com/png.latex?%5Cmu "\mu"), as well as
individual school effects
![\\eta_i](https://latex.codecogs.com/png.latex?%5Ceta_i "\eta_i") and
has the following hierarchical form:

![y_i \\sim \\mathcal{N}(\\theta_i, \\sigma_i^2)](https://latex.codecogs.com/png.latex?y_i%20%5Csim%20%5Cmathcal%7BN%7D%28%5Ctheta_i%2C%20%5Csigma_i%5E2%29 "y_i \sim \mathcal{N}(\theta_i, \sigma_i^2)")

![\\theta_i = \\mu + \\tau \\times \\eta_i ](https://latex.codecogs.com/png.latex?%5Ctheta_i%20%3D%20%5Cmu%20%2B%20%5Ctau%20%5Ctimes%20%5Ceta_i%20 "\theta_i = \mu + \tau \times \eta_i ")

![\\eta_i \\sim \\mathcal{N}(0, 1)](https://latex.codecogs.com/png.latex?%5Ceta_i%20%5Csim%20%5Cmathcal%7BN%7D%280%2C%201%29 "\eta_i \sim \mathcal{N}(0, 1)")

The process of fitting this model is beyond the scope of this course,
but if you are interested in the model implementation, fitting, and
tidying then take a look at `data/8schools.R`.

The results are stored in `data/8schools.rds` and can be read into R
using `readRDS()` using the following code:

``` r
schools = readRDS("data/8schools.rds")
```

The `schools` tibble contains the results of 4 separate MCMC chains each
with 1000 posterior draws of each of the parameters. The column names
should be mostly self explanatory with the column `i` being used to
distinguish between subscripted parameters
(e.g. ![\\eta_i](https://latex.codecogs.com/png.latex?%5Ceta_i "\eta_i")
and
![\\theta_i](https://latex.codecogs.com/png.latex?%5Ctheta_i "\theta_i")).

### Questions

1.  We have claimed that is a tidy representation of these data, explain
    why this is the case. Your answer should touch on the unit of
    observation and why this might be preferred to a wide representation
    (where the parameters are stored as columns within the data frame).

2.  Report a standard five number summary of the posterior of the
    overall mean effect
    (![\\mu](https://latex.codecogs.com/png.latex?%5Cmu "\mu")) for the
    schools for each chain.

3.  Report the mean and standard deviation of the posterior means of the
    individual school effects
    (![\\eta_i](https://latex.codecogs.com/png.latex?%5Ceta_i "\eta_i")s)
    for each chain.

4.  Given the posterior samples we can ask more complex questions, for
    example for each iteration which school had the most successful
    coaching program by comparing the values of
    ![\\theta_i](https://latex.codecogs.com/png.latex?%5Ctheta_i "\theta_i")
    for that iteration (and chain). Of the 1000 posterior draws
    calculate the percentage of the iterations where each school had the
    largest
    ![\\theta](https://latex.codecogs.com/png.latex?%5Ctheta "\theta")
    for each chain.

<br/>

## Task 2 - Lego Sales Data

### Data

For this task you will be working with a synthetic data set of sales
records for Lego construction sets. We will assume that the original
data was stored in a JSON format but a colleague has managed to import
it into R as a list of lists (of lists). The code below will load a copy
of the object, called `sales`, into your environment.

``` r
sales = readRDS("data/lego_sales.rds")
```

The original JSON file is also available, as `data/lego_sales.json` in
your repo, if you would prefer to examine a text based representation of
these data.

The data is structured such that each entry in the top list represents a
different purchaser. These list entries contain basic information about
the purchaser (name, age, phone number, etc.) as well as their purchase
history. Everyone in the data set has purchased at least one lego set
but many have purchased more than one. The purchase histories are stored
in the `purchases` element which is also a list of lists. Each entry
within the `purchases` list reflects a different Lego set which the
customer purchased. Note that the customer may have purchased more than
one copy of any particular set, this number is stored as `Quantity`
within the purchase record.

<br/>

### Part 1 - Tidy the data

Your job here is to covert the `sales` object into a tidy data frame.
Tidy in this case means each row should represents a separate purchase
of a lego set by an individual and the columns should correspond to the
keys in the JSON data. Duplicate columns should be avoided as much as
possible and no data should be lost / ignored in the conversion.

Several guidelines / hints:

1.  Be careful about making assumptions about the data - it is not as
    messy as real world data, but it is also not pristine and you are
    meant to run into several hiccups along the way.

2.  Pay attention to types - the data frame you create should have
    columns that are of a type that matches the original data.

3.  Don’t worry about duplicated data - since a customer can purchase
    multiple Lego sets that customer’s information may show up in
    multiple rows. This is fine and expected given the structure of the
    data. For the CS types: first normal form is ok in this case
    regardless of whatever your Databases professor may have told you.

4.  Dealing with duplicate purchases - some customers purchased more
    than one copy of a particular lego set, for these individuals you
    can choose to code the purchase as multiple rows within the data
    frame or as a single row that also includes the quantity value.
    Either approach is fine, but your write up should discuss your
    choice.

5.  Avoid hard coding features of the data into your solutions
    (e.g. column names for your data frame should be determined at
    runtime as much as possible).

6.  Do not use magic numbers, always use column names whenever possible,
    similarly don’t assume a specific size for the data (e.g. number of
    columns or rows) - all of these should be determined at run time.

7.  More generally, assume that the specific data could be changed at
    any time, and a new but identically structured data set could be
    provided. Make as few assumptions as possible about the data (some
    will be necessary, but should be stated explicitly in your write
    up).

8.  You may assume that *purchasers* are uniquely identified by the
    first name, last name, and phone number.

9.  When answering questions, in the case of a tie - all equivalent rows
    should be returned.

<br/>

### Part 2 - Questions

This task will involve answering a number of questions about that data
that will involve manipulating and summarizing the data frame you
created in part 1. You are also welcome to use the original `sales`
object if you believe that approach is more efficient for any particular
question.

No write up is needed for these questions as long as you include
reasonably well documented code (using comments). Make sure that your
code outputs your answer and only your answer.

<br/>

1.  What are the three most common first names of purchasers?

2.  Which Lego theme has made the most money for Lego?

3.  Do men or women buy more Lego sets (per person) on average?

4.  What are the five most popular hobbies of Lego purchasers?

5.  Which area code has spent the most money on Legos? (In the US the
    area code is the first 3 digits of a phone number)

<br/>