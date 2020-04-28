SELECT 
			PO.Ponumber 'PO Number',
			Format(po.POdatePlaced, 'MMM dd,yyyy') 'PO Date',
			vendor.Name 'Vendor Name',
			ISNULL(emp.EmpLastName + ' ' + Substring(emp.EmpFirstName,1,1) + '.','No Buyer on File') 'Employee Buyer',
			ISNULL(mgr.EmpLastName + ' ' + Substring(mgr.EmpFirstName,1,1) + '.','No Manager on File') 'Manager of Buyer',
			poline.ProductID 'Product ID',
			pro.Description 'Product Description',
			Format(poline.DateNeeded, 'MMM dd,yyyy') 'Date Needed',
			poline.Price 'Product Price',
			poline.QtyOrdered 'Quantity Ordered',
			vpo.TotalQtyReceived 'Quantity Received',
			ISNULL(vpo.TotalRemaning,poline.QtyOrdered) 'Quantity Remaining',
			vpo.ReceivingStatus 'Receiving Status'

		

from tblPurchaseOrderLine poline 
LEFT OUTER JOIN tblPurchaseOrder po
ON poline.PONumber=po.PoNumber
LEFT OUTER JOIN tblVendor vendor
ON vendor.VendorID=po.VendorID
LEFT OUTER JOIN	tblEmployee emp
ON	po.BuyerEmpID=emp.EmpID
LEFT OUTER JOIN	tblEmployee mgr
ON	emp.EmpMgrID=mgr.EmpID
LEFT OUTER JOIN tblProduct pro
ON pro.ProductID=poline.ProductID
LEFT OUTER JOIN VW_PODateNeeded vpo
ON vpo.PoNumber=poline.PONumber
AND vpo.ProductID=poline.ProductID
AND vpo.DateNeeded=poline.DateNeeded