@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Flight Travel (Data Model)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity z17_r_travel
  as select from z17_travel
  composition [0..*] of Z17_R_TRAVELITEM as _TravelItem
{
  key agency_id                                 as AgencyId,
  key travel_id                                 as TravelId,
      description                               as Description,
      customer_id                               as CustomerId,
      begin_date                                as BeginDate,
      end_date                                  as EndDate,

      @EndUserText.label: 'Duration (days)'
      dats_days_between( begin_date, end_date ) as Duration,

      status                                    as Status,

      //total ETag field
      @Semantics.systemDateTime.lastChangedAt: true
      changed_at                                as ChangedAt,

      @Semantics.user.lastChangedBy: true
      changed_by                                as ChangedBy,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      loc_changed_at                            as LocChangedAt,
      
      _TravelItem
}
