--Data cleaning

--Formatting date 

select * from house_sales

select SaleDate, convert(date,SaleDate ) saledate from house_sales
                     
update house_sales                      -- updating the value         
set SaleDate = convert(date,SaleDate ) -- update was not functioning

alter table house_sales               --creating table and updation
add sale_date date                    

update house_sales
set sale_date = convert(date,SaleDate )

select SaleDate,sale_date from house_sales 


-- managing null values in property address


select PropertyAddress 
from house_sales
where PropertyAddress is null

select a.ParcelID ,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from house_sales a
join house_sales b on a.ParcelID = b.ParcelID 
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

                                                            -- updating the value
update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from house_sales a
join house_sales b on a.ParcelID = b.ParcelID 
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-- breaking the property address

select 
substring(PropertyAddress,1,charindex(',',PropertyAddress)-1) as address,
substring( PropertyAddress,charindex(',',PropertyAddress)+1,len(propertyAddress)) as city

from house_sales


alter table house_sales                                  -- updating the value
add address varchar(255)                    
update house_sales
set address = substring(PropertyAddress,1,charindex(',',PropertyAddress)-1) 


alter table house_sales 
add city varchar(255)                

update house_sales
set city = substring( PropertyAddress,charindex(',',PropertyAddress)+1,len(propertyAddress))

select * from house_sales



select OwnerAddress ,                                       -- prasename method
 parsename(replace (OwnerAddress ,',','.'),3) as address,
  parsename(replace (OwnerAddress ,',','.'),2) as city,
   parsename(replace (OwnerAddress ,',','.'),1) as state

from house_sales

                                         -- updating the value
alter table house_sales 
add owner_spilt_address varchar(255) ,   
 owner_spilt_city varchar(255),
 owner_spilt_state varchar(255)


update house_sales
set owner_spilt_address  =  parsename(replace (OwnerAddress ,',','.'),3) ,
		owner_spilt_city =		parsename(replace (OwnerAddress ,',','.'),2) ,
		 owner_spilt_state	=	parsename(replace (OwnerAddress ,',','.'),1) 


select * from house_sales



--change y into yes and n as no
 
select distinct(SoldAsVacant),count(SoldAsVacant)
from house_sales
group by SoldAsVacant
order by 2

select SoldAsVacant ,
case when SoldAsvacant  = 'y' then 'Yes'
	when  SoldAsvacant  = 'n' then 'No'
	else SoldAsVacant 
end
from house_sales

   

update house_sales                                         -- updating the value
set SoldAsvacant= case when SoldAsvacant  = 'y' then 'Yes'
	when  SoldAsvacant  = 'n' then 'No'
	else SoldAsVacant 
	end


--removing duplicates

with t1 as (
select * ,
row_number()over(partition by ParcelID,
							PropertyAddress,
							 SalePrice,
							 SaleDate,
							 LegalReference 
				 order by UniqueId ) as row_num
from house_sales
 )

delete 
from t1
where row_num > 1

--select * from t1
--where row_num > 1


--deleting unwanted columns

select * from house_sales


 alter table house_sales
 drop column PropertyAddress,SaleDate,OwnerAddress 






