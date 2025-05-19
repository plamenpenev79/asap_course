@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_ITEM_PPV
  as select from zitems_ppv as Item
  
  association [1..1] to ZI_ORDER_PPV as _Order  on $projection.OrderUUID = _Order.OrderUUID
{
  key order_uuid      as OrderUUID,
      name            as ItemName,
      @Semantics.amount.currencyCode: 'ItemCurrency'
      price           as ItemPrice,
      currency        as ItemCurrency,
      quantity        as ItemQuantity,
      @Semantics.user.createdBy: true
      created_by      as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at      as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by as LastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_changed_at as LastChangedAt,
      
      /* associations */
      _Order

}
