namespace re.fulfillment;
using { cuid, managed} from '@sap/cds/common';





















































































type OrderStatus:String enum{
    DREAFT;
    CONFIRMED;
    PARTIALLY_DELIVERED;
    DELIVERED;
    BILLED;
    CANCELLED;
}

type DeliveryStatus:String enum{
    CREATED;
    PICKED;
    PACKED;
    DISPATCHED;
    IN_TRANSIT;
    DILVERED;
}

type ShipmentStatus:String enum{
    CREATED;
    IN_TRANSIT;
    DELIVERED;
    DELAYED;
}

type BillingStatus:String enum{
    NOT_BILLED;
    BILLED;
    CANCELLED;
}

entity Dealers:cuid,managed{
    dealerCode:String(20);
    dealerName:String(100);
    city:String(60);
    country:String(60);
    email:String(120);
    active:Boolean default true;
    salesOrders:Association to many SalesOrders on salesOrders.dealer=$self;

};

entity SalesOrders : cuid, managed {
    orderNumber : String(30);
    orderDate : Date;
    status : OrderStatus;
    totalAmount : Decimal(15,2);
    currency : String(3);

    dealer : Association to Dealers;

    items : Composition of many SalesOrderItems
        on items.salesOrder = $self;
}

entity Products : cuid, managed {
    productCode : String(30);
    productName : String(100);
    category : String(40);
    unitPrice : Decimal(15,2);
    availableQty : Integer;
    active : Boolean;

    items : Association to many SalesOrderItems
        on items.product = $self;
}

entity SalesOrderItems:cuid{
    salesOrder:Association to SalesOrders;
    product:Association to Products;
    quantity:Integer;
    unitPrice:Decimal(15,2);
    lineAmount:Decimal(15,2);
}

entity Deliveries:cuid,managed{
    deliveryNumber:String(30);
    status:DeliveryStatus;
    deliveryDate:Date;
    destination :String(100);
    salesOrder:Association to SalesOrders;

}

entity Shipments:cuid,managed{
    shipmentNumber:String(30);
    status:ShipmentStatus;
    carrier:String(80);
    trackingNumber:String(80);
    expectedDate:String(80);
    actualDate:Date;
    salesOrder:Association to SalesOrders;
    delivery:Association to Deliveries;
}

entity Billings:cuid,managed{
    billingNumber:String(30);
    status:BillingStatus;
    billingDate:Date;
    amounts:Decimal(15,2);
    salesOrder:Association to SalesOrders;
}
