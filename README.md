# -comp112_final_XLASOJ
project
Title: Where should I live in the United States?

Group Members: Amanda Souza, Xiang Li, Olivia Jarvis

Introduction and Background: When moving somewhere new in the United States, everyone knows if the place they're moving is more hot or cold and what kind of seasons it has. But, there are many other things that may be factors in the decision when choosing a place to live. In our app we will answer the questions:

What is the temperature like in different US states?

How much precipitation does this state get?

What types of weather does this state get?

How often does this state have severe weather?

What is the air quality like in this state?

Data Collection: In this app, we use the datasets "US Weather Events (2016 - 2021)" posted by Sobhan Moosavi on Kaggle, "1980-2021 Daily Air Quality Index from the EPA" posted by Jen Wadkins, also on Kaggle, and data from the CORGIS Dataset Project, posted by Austin Cory Bart and Ryan Whitcomb. 

Analysis: 

  Using the different interactive plots, users should be able to get a good idea of the weather in different states. The idea is that this app will be used by people choosing which state they want to move to so they can be more informed about the weather in that state. 
  The first plot in the app is a basic temperature comparison plot. Temperature is often on of the first things people think about when moving to a new place. We chose a data set that spanned over a year, to give the user an understanding of the changes over the year. The comparison feature of the plot is especially when deciding between two or more different states. For example, California and Arizona are relatively close and are thought to have similar climates. But by using this app, the user can see that, in fact, Arizona has a much hotter summer then California, which could change their opinion on where they would prefer to live. 
  The next plot is a choropleth of the US with the states colored to indicate the precipitation, and users can choose which year, from 2016-2021, they would like to look at. Precipitation is another one of the things that people often first consider. Many people would prefer to not live in areas that are very rainy, while others may prefer to not live in areas that are very dry. The precipitation shown is not the total precipitation, but instead it is the total precipitation divided by the total area of the state, which then shows the amount of rain per square mile in that state. This was done because some states, like Texas, are much larger so it looks like they are getting much more precipitation, when in reality they just have more because there is more area. One example of an interesting finding from this app. One example of an interesting finding is on the 2018 map, where it shows that New York got a much higher amount of rain than most other states. As New York is not typically thought of as a very rainy state, this could be a new insight that may change people's opinions on moving there. 
  After knowing the amount of precipitation, users will likely want to know what types of precipitation and weather in general a state has. The next plot allows users to compare the different types of weather different states have. This could be something that would change someones mind because they may not mind that a particular state gets a lot of precipitation, as long as it's mostly rain and now hail or snow. One example of the way this could be used is by comparing Wisconsin and Minnesota, another set of states that are thought of as very similar climate-wise. But using this plot, it shows that, in fact, Minnesota gets more snow and rain than Wisconsin. 
  Following this plot, there is a choropleth that visualizes the amount of severe weather different states have. This follows the two plots before because this looks not at just the overall types of weather, but the severity of the weather. Many people will likely want to avoid states that get high amounts of severe weather, but the amounts of severe a state gets will likely not be something someone knows off the top of their head. Like the precipitation plot, this plot also does severe weather per square mile. This controls for the size of the states, because it may appear that larger states have a higher rate severe weather, when in reality they just have more due to a larger area. An interesting finding from the choropleth is that Rhode Island has a high level of severe weather, which is not something that is typically thought of in relation to Rhode Island.
  The final plot is another choropleth that shows the air quality of the different states. Although this is somewhat unrelated to the other types of weather that is investigated in this app, this choropleth was included because for many air quality is a deciding factor in where they can live. For those with more severe pulmonary issues, areas with bad air quality will likely automatically not be an option for them. An example of when this could be helpful is with Utah. Utah is often connected to its wide plains and mountains, but this choropleth shows that around 2018, the state had some of the worst air quality in the country. 
  After investigating their options through this app, users will come away with a more well-rounded and thorough understanding the climate in the places they are considering moving to. By having all of this information in one app streamlines this process so people no longer have to search the internet, which is important because moving is stressful enough on its own. Our hope with this app is to help people educate themselves on their options, but also avoid increasing the anxiety around an already stressful process. 

ShinyApp Link: https://monicali.shinyapps.io/comp112_final_project_weatherapp/

Github Link: https://github.com/ojarvis24/comp112_final_XLASOJ