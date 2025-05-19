@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_ORDER_PPV
  as select from zorders_ppv

  association [0..*] to ZI_ITEM_PPV as _Item on $projection.OrderUUID = _Item.OrderUUID
{
  key order_uuid        as OrderUUID,
      order_id          as OrderId,
      name              as OrderName,
      status            as OrderStatus,
      customer          as Customer,
      creation_date     as OrderCreationDate,
      cancellation_date as OrderCancellationDate,
      completion_date   as OrderCompletionDate,
      delivery_country  as OrderDeliveryCountry,
      @Semantics.amount.currencyCode: 'OrderCurrency'
      total_price       as OrderTotalPrice,
      currency          as OrderCurrency,
      @Semantics.user.createdBy: true
      created_by        as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at        as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by   as LastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_changed_at   as LastChangedAt,

      /* associations */
      _Item

}
