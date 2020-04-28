SELECT               
                    tblPurchaseOrder.PoNumber as 'PO Number',
                 	convert(varchar,tblPurchaseOrder.PODatePlaced, 107) 'PO Date',
                 	tblVendor.Name as 'Vendor Name',
                    isnull(tblEmployee.EmpLastName + ', ' + SUBSTRING(tblEmployee.EmpFirstName,1,1) + '.', 'No Buyer') 'Employee Buyer',
                 	case
                       	when (tblEmployee.EmpMgrID) IS NULL then 'No Manager'
                 	else (manager.EmpLastName + ', ' + SUBSTRING(tblEmployee.EmpFirstName,1,1) + '.')
                       	end 'Manager of Buyer',
                 	tblPurchaseOrderLine.ProductID as 'Product ID',
                 	tblproduct.Description as 'Product Description',
                     CONVERT(VARCHAR,tblPurchaseOrder.PODatedNeeded, 107) as 'Date Needed',
                 	tblPurchaseOrderLine.Price 'Product Price',
                 	tblPurchaseOrderLine.QtyOrdered as 'Quantity Ordered',
                 	ISNULL(SUM(tblReceiver.QtyReceived),0.00) as 'Quantity Received',
                     (tblPurchaseOrderLine.QtyOrdered - ISNULL(SUM(tblReceiver.QtyReceived),0.00)) as 'Quantity Remaining',
                 	CASE
                       	WHEN (tblPurchaseOrderLine.QtyOrdered - ISNULL(SUM(tblReceiver.QtyReceived),0.00)) = 0
                       	THEN 'Complete'
                       	WHEN (tblPurchaseOrderLine.QtyOrdered - ISNULL(SUM(tblReceiver.QtyReceived),0.00)) < 0
                       	THEN 'Over Shipment'
                       	WHEN ISNULL(SUM(tblReceiver.QtyReceived),0.00) = 0.00
                       	THEN 'Not Received'
                       	WHEN (tblPurchaseOrderLine.QtyOrdered - ISNULL(SUM(tblReceiver.QtyReceived),0.00)) > 0
                       	THEN 'Partial Shipment'
                       	END 'Receiving Status'
 
FROM             	tblPurchaseOrder
 
INNER JOIN       	tblVendor
ON                   tblPurchaseOrder.VendorID = tblVendor.VendorID
LEFT JOIN        	tblEmployee
ON                   tblPurchaseOrder.BuyerEmpID = tblEmployee.EmpID
left join 	   	tblEmployee manager
on               	tblEmployee.EmpMgrID = manager.EmpID
INNER JOIN       	tblPurchaseOrderLine
ON                   tblPurchaseOrder.PoNumber = tblPurchaseOrderLine.PONumber
INNER JOIN       	tblProduct
ON                   tblPurchaseOrderLine.ProductID = tblProduct.ProductID
LEFT JOIN        	tblReceiver
ON                   tblPurchaseOrderLine.ProductID = tblReceiver.ProductID
AND                  tblPurchaseOrderLine.PONumber = tblReceiver.PONumber
AND                  tblPurchaseOrderLine.DateNeeded = tblReceiver.DateNeeded
 
GROUP BY         	tblPurchaseOrder.PoNumber, tblPurchaseOrder.PODatePlaced, tblVendor.Name, tblEmployee.EmpLastName, tblEmployee.EmpFirstName,
                                     	tblEmployee.EmpMgrID, manager.EmpLastName, tblPurchaseOrderLine.ProductID, tblproduct.Description,
                                     	tblPurchaseOrder.PODatedNeeded, tblPurchaseOrderLine.Price, tblPurchaseOrderLine.QtyOrdered
 
ORDER BY         	tblPurchaseOrder.PoNumber, tblPurchaseOrderLine.ProductID, tblPurchaseOrder.PODatedNeeded;
