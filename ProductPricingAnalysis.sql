Create View vproduct as 
Select Distinct tblProduct.productID 'Product ID',
                        description 'Product Description',
                        EOQ 'Product Economic Order Quantity',
                        ISNULL(cast(tblPurchaseHistory.DatePurchased as varchar(100)),
                        'Not In Purchase History') 'Most Recent Purchase Date',
ISNULL(cast(tblPurchaseHistory.Qty as varchar(10)), '--') 'Quantity Purchased',
ISNULL(tblPurchaseHistory.Price, 0) 'Purchase Price'
from                    tblProduct
LEFT JOIN               tblPurchaseHistory
on                      tblProduct.ProductID = tblPurchaseHistory.ProductID
WHERE                   tblPurchaseHistory.DatePurchased IS NULL
OR                      tblPurchaseHistory.Price = (SELECT max (tblPurchaseHistory.Price)
from                    tblPurchaseHistory   where tblProduct.ProductID = tblPurchaseHistory.ProductID);

select * from vproduct

Select 
tblpurchaseorderline.productid 'ProductID', 
tblproduct.description 'Product Description',
vproduct.[Purchase Price] 'Recent History Price',
tblpurchaseorderline.price 'Current Price' , 
tblpurchaseorder.ponumber ,
tblVendor.name 'Vendor Name' 
from tblPurchaseOrderLine 
Inner join  vproduct
On tblPurchaseOrderline.productID = vproduct.[Product ID]
inner join tblproduct
on tblPurchaseorderline.ProductID = tblproduct.ProductID 
inner join tblpurchaseorder
on tblpurchaseorderline.ponumber = tblpurchaseorder.ponumber
inner join tblVendor
on tblpurchaseorder.vendorid = tblVendor.vendorid
Where price > 1.2 * [Purchase Price]