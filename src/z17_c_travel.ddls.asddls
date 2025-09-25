@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Flight Travel (Projection)'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity Z17_C_TRAVEL
  provider contract transactional_query
  as projection on z17_r_travel
{
  key AgencyId,
  key TravelId,
      @Search.defaultSearchElement: true
      Description,
      @Search.defaultSearchElement: true
      CustomerId,
      BeginDate,
      EndDate,
      Duration,
      Status,
      ChangedAt,
      ChangedBy,
      LocChangedAt,
      
      _TravelItem : redirected to composition child Z17_C_TRAVELITEM
}

