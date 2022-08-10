-- Olymic data manipulation

SELECT  [ID]
      ,[Name] as 'Compitator name'
	  ,case when Sex = 'M' then 'Male'
	        when Sex = 'F' then 'Female' end  as Sex
      ,[Age]
	  ,case when Age < 18 then 'under 18'
	       when Age between 18 and 25 then 'between 18-25'
		   when Age between 25and 30 then 'under 18'
		   when Age > 30 then 'over 30'
	  end as Age_group   
      ,[Height]
      ,[Weight]
      ,[Team]
      ,[NOC] as 'National code'
      ,[Games]
	  --CHARINDEX(' ',Games)-1 as count_year
	  --CHARINDEX(' ',reverse(Games))-1 as count_season
	  ,left(Games,CHARINDEX(' ',Games)-1 ) as Year
	  --substring(Games,CHARINDEX(' ',Games)+1 ,len(Games))
	  --len(Games)
	  ,RIGHT(Games,CHARINDEX(' ',Games)+1) as Season
      ,[City]
      ,[Sport]
      ,[Event]
      ,[Medal]
  FROM[olympic_data]
  where RIGHT(Games,CHARINDEX(' ',Games)+1) ='Summer' 


  
  