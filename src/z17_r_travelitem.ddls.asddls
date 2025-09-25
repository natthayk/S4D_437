@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Flight Travel Item'
define view entity Z17_R_TRAVELITEM
  as select from z17_tritem
  association to parent z17_r_travel as _Travel
    on  $projection.AgencyId = _Travel.AgencyId
    and $projection.TravelId = _Travel.TravelId
  {
    key item_uuid            as ItemUuid,
        agency_id            as AgencyId,
        travel_id            as TravelId,
        carrier_id           as CarrierId,
        connection_id        as ConnectionId,
        flight_date          as FlightDate,
        booking_id           as BookingId,
        passenger_first_name as PassengerFirstName,
        passenger_last_name  as PassengerLastName,
        @Semantics.systemDateTime.lastChangedAt: true
        changed_at           as ChangedAt,
        @Semantics.user.lastChangedBy: true
        changed_by           as ChangedBy,
        @Semantics.systemDateTime.localInstanceLastChangedAt: true
        loc_changed_at       as LocChangedAt,

        _Travel

  }
